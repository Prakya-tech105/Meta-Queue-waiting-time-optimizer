from __future__ import annotations

import json
import os
import uuid
from typing import Any

from fastapi import FastAPI, HTTPException
from openai import OpenAI
from pydantic import BaseModel

# Defaults are intentionally only for API_BASE_URL and MODEL_NAME.
API_BASE_URL = os.getenv("API_BASE_URL", "https://api.openai.com/v1")
MODEL_NAME = os.getenv("MODEL_NAME", "gpt-4o-mini")
HF_TOKEN = os.getenv("HF_TOKEN")

# Optional for from_docker_image() style runners.
LOCAL_IMAGE_NAME = os.getenv("LOCAL_IMAGE_NAME")

app = FastAPI(title="Queue Waiting Time Optimizer Inference API")

_sessions: dict[str, dict[str, Any]] = {}


def _log(event: str, message: str, **fields: Any) -> None:
    payload = {"message": message, **fields}
    print(f"{event} {json.dumps(payload, ensure_ascii=True)}", flush=True)


def _build_client() -> OpenAI:
    if not HF_TOKEN:
        raise RuntimeError("HF_TOKEN is required and must be set in the environment")
    return OpenAI(base_url=API_BASE_URL, api_key=HF_TOKEN)


def _extract_prompt(payload: dict[str, Any]) -> str:
    for key in ("input", "prompt", "message", "query"):
        value = payload.get(key)
        if isinstance(value, str) and value.strip():
            return value.strip()
    raise HTTPException(status_code=400, detail="Missing prompt. Use one of: input, prompt, message, query")


class ResetRequest(BaseModel):
    session_id: str | None = None
    metadata: dict[str, Any] | None = None


@app.get("/")
def root() -> dict[str, Any]:
    return {"status": "ok", "service": "queue-waiting-time-optimizer", "local_image_name": LOCAL_IMAGE_NAME or ""}


@app.post("/reset")
def reset(req: ResetRequest) -> dict[str, Any]:
    _log("START", "reset.start", provided_session_id=req.session_id or "")
    sid = req.session_id or str(uuid.uuid4())
    _sessions[sid] = {"history": [], "metadata": req.metadata or {}}
    _log("END", "reset.success", session_id=sid)
    return {"status": "ok", "session_id": sid}


@app.post("/post")
def post(payload: dict[str, Any]) -> dict[str, Any]:
    _log("START", "post.start")
    sid = str(payload.get("session_id") or "")
    if sid and sid not in _sessions:
        _sessions[sid] = {"history": [], "metadata": {}}

    prompt = _extract_prompt(payload)
    _log("STEP", "client.initialize", api_base_url=API_BASE_URL, model_name=MODEL_NAME)
    client = _build_client()

    _log("STEP", "llm.request")
    response = client.responses.create(model=MODEL_NAME, input=prompt)
    output_text = (response.output_text or "").strip()

    if sid:
        _sessions[sid]["history"].append({"user": prompt, "assistant": output_text})

    _log("END", "post.success", session_id=sid)
    return {"status": "ok", "session_id": sid, "output": output_text}


if __name__ == "__main__":
    import uvicorn

    _log(
        "START",
        "service.boot",
        api_base_url=API_BASE_URL,
        model_name=MODEL_NAME,
        local_image_name=LOCAL_IMAGE_NAME or "",
    )
    uvicorn.run(app, host="0.0.0.0", port=int(os.getenv("PORT", "7860")))