
#!/usr/bin/env bash
set -euo pipefail

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
install -d -o longshoreman -g longshoreman -m 711 /opt/dopagaki

# Hugo
install -d -o hugo -g hugo -m 755 /opt/dopagaki/site
# dont forget that it creates the folder, 
# but all the subfolders etc. need to be granted separately
chown -R hugo:hugo /opt/dopagaki/site

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
cp ../Caddyfile /opt/dopagaki
cp ../compose.yaml /opt/dopagaki
ls -ld /opt/dopagaki /opt/dopagaki/site

echo
echo "Files & directories created!"

echo "DONE!"