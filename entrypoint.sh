#!/bin/sh
set --
set -e

CONFIG_DIR="/root/.picoclaw"
CONFIG_FILE="${CONFIG_DIR}/config.json"

mkdir -p "${CONFIG_DIR}/workspace"
rm -f "${CONFIG_FILE}"

TELEGRAM_ENABLED="${TELEGRAM_ENABLED:-false}"

cat > "${CONFIG_FILE}" <<EOF
{
  "agents": {
    "defaults": {
      "model_name": "default-model"
    }
  },
  "model_list": [
    {
      "model_name": "default-model",
      "model": "gemini-2.5-flash",
      "api_key": "${GEMINI_API_KEY}",
      "api_base": "https://generativelanguage.googleapis.com/v1beta/openai/"
    }
  ],
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
      "allow_from": [],
      "default_chat_id": "${TELEGRAM_USER_ID}"
    }
  },
  "gateway": {
    "host": "0.0.0.0",
    "port": 10000
  }
}
EOF

exec picoclaw gateway
