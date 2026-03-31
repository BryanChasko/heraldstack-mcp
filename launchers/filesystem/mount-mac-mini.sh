#!/bin/bash
sshfs bryanchasko@Bryans-Mac-mini.local:/Users/bryanchasko /mnt/mac-mini \
  -o reconnect \
  -o ServerAliveInterval=15 \
  -o ServerAliveCountMax=3 \
  -o IdentityFile=/home/bryanchasko/.ssh/id_ed25519
