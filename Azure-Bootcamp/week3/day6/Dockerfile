# ==================================================
# Azure Bootcamp - Week 3 Day 6
# Dockerfile for ai-log-analyser (FastAPI)
# (adapted from Week 2 Day 4 — that one ran Flask's
#  app.py directly; this app is FastAPI and needs
#  uvicorn as the process that actually serves it)
# ==================================================

FROM python:3.11-slim

WORKDIR /app

COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

EXPOSE 8000

# main:app -> main.py's "app" object (FastAPI instance).
# --host 0.0.0.0 is required inside a container, otherwise
# uvicorn only listens on localhost INSIDE the container and
# the Service/Ingress in front of it can never reach it.
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]