#!/bin/sh
set --
set -e

CONFIG_DIR="/root/.picoclaw"
CONFIG_FILE="${CONFIG_DIR}/config.json"

mkdir -p "${CONFIG_DIR}/workspace"
rm -f "${CONFIG_FILE}"

PICOCLAW_MODEL="${PICOCLAW_MODEL:-nvidia/nemotron-nano-9b-v2:free}"
TELEGRAM_ENABLED="${TELEGRAM_ENABLED:-false}"

cat > "${CONFIG_FILE}" <<EOF
{
  "agents": {
    "defaults": {
      "model": "${PICOCLAW_MODEL}"
    }
  },
  "providers": {
    "openrouter": {
      "api_key": "${OPENROUTER_API_KEY}",
      "api_base": "https://openrouter.ai/api/v1"
    }
  },
  "tools": {
    "cron": {
      "enabled": true,
      "allow_command": true
    },
    "exec": {
      "enabled": true
    }
  },
  "channels": {
    "telegram": {
      "enabled": ${TELEGRAM_ENABLED},
      "token": "${TELEGRAM_BOT_TOKEN}",
      "allow_from": []
    }
  },
  "gateway": {
    "host": "0.0.0.0",
    "port": 10000
  }
}
EOF

exec picoclaw gateway
