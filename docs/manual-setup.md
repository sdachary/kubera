# Manual Setup Guide

If you prefer to set up Kubera without the installer, follow these steps.

## Prerequisites

- Docker 20.0+ with Compose plugin
- curl
- openssl (for key generation)

## Steps

### 1. Clone the repo

```bash
git clone https://github.com/deepakachary/kubera.git
cd kubera
```

### 2. Create your `.env`

```bash
cp .env.example .env
```

Edit `.env` and set at minimum:

```bash
# Generate a secret key
openssl rand -hex 64

# Then paste the output as:
SECRET_KEY_BASE=your_generated_key

# Set a database password
POSTGRES_PASSWORD=choose_something_strong

# Set your port (change if 3000 is in use)
PORT=3000
```

### 3. Configure AI (optional)

In `.env`, uncomment and fill in the AI section:

```bash
# OpenRouter (recommended — free models available)
OPENAI_URI_BASE=https://openrouter.ai/api/v1
OPENAI_ACCESS_TOKEN=sk-or-your-key
OPENAI_MODEL=meta-llama/llama-3.1-70b-instruct
```

See `.env.example` for all provider options.

### 4. Start

```bash
docker compose up -d
```

### 5. Open

```
http://localhost:3000
```

Create your account on the first visit.

## Useful commands

```bash
# Stop
docker compose down

# Start
docker compose up -d

# View logs
docker compose logs -f web

# Update to latest
docker compose pull && docker compose up -d

# Enable daily backups
docker compose --profile backup up -d
```

## Updating

```bash
docker compose pull
docker compose up --no-deps -d web worker
```

Your database and uploaded files are stored in Docker volumes and are preserved across updates.
