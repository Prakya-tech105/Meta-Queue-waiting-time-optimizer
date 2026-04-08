from __future__ import annotations

import json
import os
from typing import Any

from openai import OpenAI

# Required env vars for runtime configuration.
# Defaults are intentionally set only for API_BASE_URL and MODEL_NAME.
API_BASE_URL = os.getenv("API_BASE_URL", "https://api.openai.com/v1")
MODEL_NAME = os.getenv("MODEL_NAME", "gpt-4o-mini")
HF_TOKEN = os.getenv("HF_TOKEN")

# Optional when using from_docker_image()-style workflows.
LOCAL_IMAGE_NAME = os.getenv("LOCAL_IMAGE_NAME")


def _log(event: str, message: str, **fields: Any) -> None:
    payload = {"message": message, **fields}
    print(f"{event} {json.dumps(payload, ensure_ascii=True)}", flush=True)


def _build_client() -> OpenAI:
    if not HF_TOKEN:
        raise RuntimeError("HF_TOKEN is required and must be set in the environment")

    return OpenAI(base_url=API_BASE_URL, api_key=HF_TOKEN)


def _run_llm_call(client: OpenAI, prompt: str) -> str:
    response = client.chat.completions.create(
        model=MODEL_NAME,
        messages=[{"role": "user", "content": prompt}]
    )
    return (response.choices[0].message.content or "").strip()


def main() -> None:
    _log(
        "START",
        "inference.start",
        api_base_url=API_BASE_URL,
        model_name=MODEL_NAME,
        local_image_name=LOCAL_IMAGE_NAME or "",
    )

    try:
        _log("STEP", "client.initialize")
        client = _build_client()

        _log("STEP", "llm.request")
        output_text = _run_llm_call(client, "Return exactly: Queue Waiting Time Optimizer ready.")

        _log("END", "inference.success", output=output_text)
    except Exception as exc:
        _log("END", "inference.error", error=str(exc))
        raise


if __name__ == "__main__":
    main()