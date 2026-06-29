"""
Wraps the call to Azure OpenAI for log analysis.

Kept isolated from main.py on purpose: this is the ONLY file that needs
real logic once Azure OpenAI credentials exist. Until then,
analyse_log_text() raises AzureOpenAIConfigError — that's intentional,
not a bug. It lets /healthz and /readyz work, while /analyse/* correctly
reports "not configured yet" instead of silently returning fake data.

Model: gpt-5-mini (a GPT-5-family reasoning model), NOT GPT-4o. This
matters because GPT-5-family models reject the older `temperature` and
`max_tokens` chat-completion parameters outright (400 error) — they use
`max_completion_tokens` instead, and don't accept `temperature` at all.
See the API call below for how this is handled.

Required env vars:
    AZURE_OPENAI_ENDPOINT     e.g. https://<resource>.openai.azure.com/
    AZURE_OPENAI_API_KEY      key from the Azure OpenAI resource
    AZURE_OPENAI_DEPLOYMENT   the deployment name you gave the model
                              (e.g. "gpt-5-mini" — this is the Azure
                              deployment name, not necessarily identical
                              to the underlying model family name)
    AZURE_OPENAI_API_VERSION  optional, defaults to a known-good version
"""

import os

DEFAULT_API_VERSION = "2025-04-01-preview"

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
            "Set these env vars once you have a deployed Azure OpenAI model."
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
            # gpt-5-mini is a reasoning model: it rejects `temperature`
            # outright (400 error) and requires `max_completion_tokens`
            # instead of the older `max_tokens`. Do not add `temperature`
            # back in if you ever switch this deployment to a GPT-5-family
            # model again — it will break the call.
            #
            # Reasoning models spend part of this budget on HIDDEN
            # reasoning tokens before writing any visible output. If the
            # budget is too small, the model can use it all on reasoning
            # and return an empty message — this is why the budget here
            # is much larger than a non-reasoning model would need for
            # the same visible output length.
            max_completion_tokens=2000,
        )
    except APIError as e:
        raise AzureOpenAIRequestError(f"Azure OpenAI request failed: {e}") from e

    choice = response.choices[0] if response.choices else None
    if choice is None or not choice.message or not choice.message.content:
        # Surface finish_reason and token usage so an empty response is
        # diagnosable instead of a bare "empty response" message. The
        # most common cause: max_completion_tokens was fully consumed by
        # hidden reasoning tokens before any visible content was written
        # (finish_reason == "length" with reasoning_tokens near the cap).
        finish_reason = choice.finish_reason if choice else "no choice returned"
        usage = response.usage
        usage_detail = ""
        if usage is not None:
            reasoning_tokens = getattr(
                getattr(usage, "completion_tokens_details", None),
                "reasoning_tokens",
                None,
            )
            usage_detail = (
                f" (completion_tokens={usage.completion_tokens}, "
                f"reasoning_tokens={reasoning_tokens})"
            )
        raise AzureOpenAIRequestError(
            f"Azure OpenAI returned an empty response "
            f"(finish_reason={finish_reason}{usage_detail})"
        )

    return choice.message.content.strip()