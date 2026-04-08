FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

RUN pip install --upgrade pip && pip install \
    fastapi \
    uvicorn \
    pydantic \
    openai

COPY . /app

EXPOSE 7860

CMD ["python", "inference.py"]