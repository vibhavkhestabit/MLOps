"""
Wraps the call to Azure OpenAI for log analysis.

Kept isolated from main.py on purpose: once Week 3 Day 5 is complete and you
have a real GPT-4o deployment, this is the ONLY file that needs real logic.
Right now analyse_log_text() raises AzureOpenAIConfigError until the env
vars below are set — that's intentional, not a bug. It lets /healthz and
/readyz work today, while /analyse/* correctly reports "not configured yet"
instead of silently returning fake data.

Required env vars (set these once Day 5 gives you real values):
    AZURE_OPENAI_ENDPOINT     e.g. https://<resource>.openai.azure.com/
    AZURE_OPENAI_API_KEY      key from the Azure OpenAI resource
    AZURE_OPENAI_DEPLOYMENT   the deployment name you gave the GPT-4o model
    AZURE_OPENAI_API_VERSION  optional, defaults to a known-good version
"""

import os

DEFAULT_API_VERSION = "2024-08-01-preview"

SYSTEM_PROMPT = (
    "You are a senior DevOps engineer. You will be given raw server or "
    "application log output. Identify the most likely root cause(s) of any "
    "errors or anomalies present, summarise what happened in plain language, "
    "and suggest concrete next steps to fix or investigate further. If the "
    "logs show no problems, say so plainly. Be concise and structured."
)


class AzureOpenAIConfigError(RuntimeError):
    """Raised when required Azure OpenAI configuration is missing."""


class AzureOpenAIRequestError(RuntimeError):
    """Raised when the call to Azure OpenAI fails or returns an error."""


def _load_config() -> dict:
    endpoint = os.getenv("AZURE_OPENAI_ENDPOINT")
    api_key = os.getenv("AZURE_OPENAI_API_KEY")
    deployment = os.getenv("AZURE_OPENAI_DEPLOYMENT")
    api_version = os.getenv("AZURE_OPENAI_API_VERSION", DEFAULT_API_VERSION)

    missing = [
        name
        for name, val in (
            ("AZURE_OPENAI_ENDPOINT", endpoint),
            ("AZURE_OPENAI_API_KEY", api_key),
            ("AZURE_OPENAI_DEPLOYMENT", deployment),
        )
        if not val
    ]
    if missing:
        raise AzureOpenAIConfigError(
            f"Azure OpenAI is not configured yet (missing: {', '.join(missing)}). "
            "This is expected until Week 3 Day 5 is complete — set these env "
            "vars once you have a deployed GPT-4o resource."
        )

    return {
        "endpoint": endpoint,
        "api_key": api_key,
        "deployment": deployment,
        "api_version": api_version,
    }


def analyse_log_text(log_text: str) -> str:
    """
    Sends log_text to Azure OpenAI Chat Completions and returns the model's
    summary as a string. Raises AzureOpenAIConfigError if env vars aren't
    set, or AzureOpenAIRequestError if the API call itself fails.
    """
    config = _load_config()

    # Imported here (not top-level) so the module still imports cleanly even
    # if the openai package version changes later — keeps main.py decoupled.
    from openai import AzureOpenAI, APIError

    client = AzureOpenAI(
        azure_endpoint=config["endpoint"],
        api_key=config["api_key"],
        api_version=config["api_version"],
    )

    try:
        response = client.chat.completions.create(
            model=config["deployment"],
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": log_text},
            ],
            temperature=0.2,
            max_tokens=600,
        )
    except APIError as e:
        raise AzureOpenAIRequestError(f"Azure OpenAI request failed: {e}") from e

    choice = response.choices[0] if response.choices else None
    if choice is None or not choice.message or not choice.message.content:
        raise AzureOpenAIRequestError("Azure OpenAI returned an empty response")

    return choice.message.content.strip()