#!/bin/sh
set --
set -e

CONFIG_DIR="/root/.picoclaw"
CONFIG_FILE="${CONFIG_DIR}/config.json"

if [ ! -f "${CONFIG_FILE}" ]; then
    mkdir -p "${CONFIG_DIR}"

    PICOCLAW_MODEL="${PICOCLAW_MODEL:-anthropic/claude-sonnet-4-6}"
    TELEGRAM_ENABLED="${TELEGRAM_ENABLED:-false}"

    cat > "${CONFIG_FILE}" <<EOF
{
  "gateway": {
    "host": "0.0.0.0",
    "port": 10000
  },
  "providers": {
    "openrouter": {
      "api_key": "${OPENROUTER_API_KEY}"
    }
  },
  "model_list": [
    {
      "model_name": "${PICOCLAW_MODEL}",
      "provider": "openrouter"
    }
  ],
  "telegram": {
    "enabled": ${TELEGRAM_ENABLED},
    "bot_token": "${TELEGRAM_BOT_TOKEN}",
    "user_id": "${TELEGRAM_USER_ID}"
  }
}
EOF
fi

exec picoclaw gateway start
