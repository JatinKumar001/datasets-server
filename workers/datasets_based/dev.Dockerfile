# build with
#   docker build -t some_tag_worker -f Dockerfile ../..
FROM python:3.9.15-slim

ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100 \
    POETRY_NO_INTERACTION=1 \
    # Versions:
    POETRY_VERSION=1.3.2 \
    POETRY_VIRTUALENVS_IN_PROJECT=true

# System deps:
RUN apt-get update \
    && apt-get install -y build-essential unzip wget python3-dev make \
    libicu-dev ffmpeg libavcodec-extra libsndfile1 llvm pkg-config \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

RUN pip install -U --no-cache-dir pip
RUN pip install --no-cache-dir "poetry==$POETRY_VERSION"

WORKDIR /src
COPY workers/datasets_based/vendors ./workers/datasets_based/vendors/
COPY workers/datasets_based/poetry.lock ./workers/datasets_based/poetry.lock
COPY workers/datasets_based/pyproject.toml ./workers/datasets_based/pyproject.toml
COPY libs/libcommon ./libs/libcommon
WORKDIR /src/workers/datasets_based/
RUN poetry install --no-cache

# FOR LOCAL DEVELOPMENT ENVIRONMENT
# No need to copy the source code since we map a volume in docker-compose-base.yaml
# Removed: COPY workers/datasets_based/src ./src
# Removed: RUN poetry install --no-cache
# However we need to install the package when the container starts
# Added: poetry install
ENTRYPOINT ["/bin/sh", "-c" , "poetry install && poetry run python src/datasets_based/main.py"]
