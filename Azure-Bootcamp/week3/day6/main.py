"""
AI-Powered Log Analyser — Week 3 Day 6 Capstone
Accepts a log file (upload) or raw log text (JSON), sends it to Azure OpenAI
(GPT-4o) for root-cause analysis, and returns a structured summary.

Config is read from environment variables. Locally these come from a .env
file (see .env.example). On AKS, the same variable names will be populated
by the Secrets Store CSI driver pulling from Azure Key Vault — no code
changes needed when you make that switch.
"""

import logging
import os

from fastapi import FastAPI, File, HTTPException, UploadFile
from pydantic import BaseModel

from analyser import analyse_log_text, AzureOpenAIConfigError, AzureOpenAIRequestError

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("log-analyser")

app = FastAPI(
    title="AI Log Analyser",
    description="Upload or paste server logs and get an AI-generated root-cause summary.",
    version="1.0.0",
)

MAX_LOG_CHARS = 20_000  # keep prompt size sane; truncate beyond this


class LogTextRequest(BaseModel):
    log_text: str


class AnalysisResponse(BaseModel):
    summary: str
    truncated: bool


def _truncate(text: str) -> tuple[str, bool]:
    if len(text) > MAX_LOG_CHARS:
        return text[-MAX_LOG_CHARS:], True
    return text, False


@app.get("/healthz")
def healthz():
    """Liveness/readiness probe target for Kubernetes."""
    return {"status": "ok"}


@app.get("/readyz")
def readyz():
    """Checks that required config is present (does not call OpenAI)."""
    missing = [
        var
        for var in ("AZURE_OPENAI_ENDPOINT", "AZURE_OPENAI_API_KEY", "AZURE_OPENAI_DEPLOYMENT")
        if not os.getenv(var)
    ]
    if missing:
        raise HTTPException(status_code=503, detail=f"Missing config: {', '.join(missing)}")
    return {"status": "ready"}


@app.post("/analyse/text", response_model=AnalysisResponse)
def analyse_text(payload: LogTextRequest):
    """Accepts raw log text in a JSON body: {"log_text": "..."}"""
    if not payload.log_text.strip():
        raise HTTPException(status_code=400, detail="log_text must not be empty")

    text, truncated = _truncate(payload.log_text)
    try:
        summary = analyse_log_text(text)
    except AzureOpenAIConfigError as e:
        logger.error("Config error: %s", e)
        raise HTTPException(status_code=503, detail=str(e))
    except AzureOpenAIRequestError as e:
        logger.error("Upstream error: %s", e)
        raise HTTPException(status_code=502, detail=str(e))

    return AnalysisResponse(summary=summary, truncated=truncated)


@app.post("/analyse/upload", response_model=AnalysisResponse)
async def analyse_upload(file: UploadFile = File(...)):
    """Accepts a log file via multipart/form-data upload."""
    raw = await file.read()
    try:
        text = raw.decode("utf-8", errors="replace")
    except Exception:
        raise HTTPException(status_code=400, detail="Could not decode file as text")

    if not text.strip():
        raise HTTPException(status_code=400, detail="Uploaded file is empty")

    text, truncated = _truncate(text)
    try:
        summary = analyse_log_text(text)
    except AzureOpenAIConfigError as e:
        logger.error("Config error: %s", e)
        raise HTTPException(status_code=503, detail=str(e))
    except AzureOpenAIRequestError as e:
        logger.error("Upstream error: %s", e)
        raise HTTPException(status_code=502, detail=str(e))

    return AnalysisResponse(summary=summary, truncated=truncated)