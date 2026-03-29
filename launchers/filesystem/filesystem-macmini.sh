#!/bin/bash
if ! mountpoint -q /mnt/mac-mini; then
  sshfs bryanchasko@Bryans-Mac-mini.local:/Users/bryanchasko /mnt/mac-mini \
    -o reconnect \
    -o ServerAliveInterval=15 \
    -o ServerAliveCountMax=3 \
    -o IdentityFile=/home/bryanchasko/.ssh/id_ed25519
fi
export PATH="/home/bryanchasko/.nvm/versions/node/v24.14.0/bin:$PATH"
exec npx -y @modelcontextprotocol/server-filesystem /mnt/mac-mini/Code
