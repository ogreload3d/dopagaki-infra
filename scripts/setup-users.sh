
#!/usr/bin/env bash
set -euo pipefail

APP_DIR="opt/dopagaki"

if [[ $EUID -ne 0 ]]; then
    echo "Run this script as root (sudo)."
    exit 1
fi

# Docker must already be installed.
if ! getent group docker >/dev/null; then
    echo "Docker group does not exist. Is Docker installed?"
    exit 1
fi

# Create users if they don't already exist.
if ! id longshoreman >/dev/null 2>&1; then
    useradd -m -s /bin/bash longshoreman
fi

if ! id hugo >/dev/null 2>&1; then
    useradd -m -s /bin/bash hugo
fi

# Docker operator.
usermod -aG docker longshoreman
install -d -o longshoreman -g longshoreman -m 711 "$APP_DIR"

# Hugo
install -d -o hugo -g hugo -m 755 "$APP_DIR"/site

# give hugo his ssh
mkdir -p /home/hugo/.ssh
chmod 700 /home/hugo/.ssh
chown -R hugo:hugo /home/hugo/.ssh
touch /home/hugo/.ssh/authorized_keys
chmod 600 /home/hugo/.ssh/authorized_keys
# copy the pub_key to authorized_keys later

echo "Users created!"
id longshoreman
id hugo

echo "Copying Caddyfile and compose.yaml"
cp ../Caddyfile "$APP_DIR"
cp ../compose.yaml "$APP_DIR"
ls -ld "$APP_DIR" "$APP_DIR"/site

echo "copying engima file"
mkdir -p "$APP_DIR"/enigma/{config,db,logs,filebase,art,mods,mail,site}
cp ../enigma/config.hjson "$APP_DIR"/enigma/config

echo "now giving access to users"
chown -R longshoreman:longshoreman "$APP_DIR"
chown -R hugo:hugo "$APP_DIR"/site

echo "DONE!"
echo "run longshoreman-up.sh to complete the installation"