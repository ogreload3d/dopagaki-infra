# about

This file is for noobs (like me) that will write down everything we need to know

## the platonic ideal of the infra

update me later fuck it i dont care rn

```
opt/dopagaki
├── compose.yaml
├── Caddyfile
├── .env.example
├── .gitignore
├── scripts/
│   ├── backup.sh
│   └── restore.sh
├── caddy/
│   └── ...
├── enigma/
│   └── ...
└── backups/
    └── .gitkeep
```

## vps must allow ssh keys only

put it in /etc/ssh/sshd_config.d
any `.conf` file
```
PasswordAuthentication no
KbdInteractiveAuthentication no
ChallengeResponseAuthentication no
PermitRootLogin prohibit-password
```

## we gotta create a key for hugo

```
ssh-keygen -t ed25519 -C "dopagaki-hugo-deploy" -f ~/.ssh/dopagaki_hugo
cat ~/.ssh/dopagaki_hugo.pub | ssh root@dopagaki.party 'mkdir -p /home/hugo/.ssh && chmod 700 /home/hugo/.ssh && cat >> /home/hugo/.ssh/authorized_keys && chown -R hugo:hugo /home/hugo/.ssh && chmod 600 /home/hugo/.ssh/authorized_keys'
```

## we gotta use the key for hugo

vim ~/.ssh/config

add

```
Host dopagaki-hugo
    HostName YOUR_VPS_IP
    User hugo
    IdentityFile ~/.ssh/dopagaki_hugo
    IdentitiesOnly yes
```

