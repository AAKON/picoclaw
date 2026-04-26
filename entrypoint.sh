#!/bin/sh
set --
set -e

CONFIG_DIR="/root/.picoclaw"
CONFIG_FILE="${CONFIG_DIR}/config.json"

if [ ! -f "${CONFIG_FILE}" ]; then
    mkdir -p "${CONFIG_DIR}"

    PICOCLAW_MODEL="${PICOCLAW_MODEL:-google/gemini-2.5-flash}"
    TELEGRAM_ENABLED="${TELEGRAM_ENABLED:-false}"

    cat > "${CONFIG_FILE}" <<EOF
{
  "agents": {
    "defaults": {
      "model_name": "default-model"
    }
  },
  "gateway": {
    "host": "0.0.0.0",
    "port": 10000
  },
  "model_list": [
    {
      "model_name": "default-model",
      "model": "openrouter/${PICOCLAW_MODEL}",
      "api_key": "${OPENROUTER_API_KEY}"
    }
  ],
  "channels": {
    "telegram": {
      "enabled": ${TELEGRAM_ENABLED},
      "token": "${TELEGRAM_BOT_TOKEN}",
      "allow_from": ["${TELEGRAM_USER_ID}"]
    }
  }
}
EOF
fi

exec picoclaw gateway