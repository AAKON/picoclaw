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
      "model_name": "default-model",
      "heartbeat": {
        "enabled": true,
        "interval": 60
      }
    }
  },
  "gateway": {
    "host": "0.0.0.0",
    "port": 10000
  },
  "model_list": [
    {
      "model_name": "default-model",
      "model": "${PICOCLAW_MODEL}",
      "api_key": "${OPENROUTER_API_KEY}"
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
      "allow_from": []
    }
  }
}
EOF

rm -f /root/.picoclaw/workspace/agent_*.json
rm -f /root/.picoclaw/workspace/session_*.json
rm -f /root/.picoclaw/workspace/*.state

exec picoclaw gateway
