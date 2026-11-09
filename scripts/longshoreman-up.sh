#!/usr/bin/env bash
set -euo pipefail

cd /opt/dopagaki
sudo -u longshoreman docker compose up -d

# docker compose up -d
# docker compose down
# docker compose restart
# docker compose logs -f