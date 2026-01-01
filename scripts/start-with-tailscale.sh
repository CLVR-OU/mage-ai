#!/bin/bash
set -e

# Start Tailscale daemon (userspace networking for containers)
/usr/sbin/tailscaled --tun=userspace-networking --state=/var/lib/tailscale/tailscaled.state &

# Wait for daemon to be ready
sleep 5

# Connect to Tailnet (only if authkey is provided)
if [ -n "$TAILSCALE_AUTHKEY" ]; then
  /usr/bin/tailscale up --authkey=$TAILSCALE_AUTHKEY --hostname=${TAILSCALE_HOSTNAME:-mage-railway}
  sleep 3
  echo "Tailscale connected:"
  /usr/bin/tailscale status
else
  echo "TAILSCALE_AUTHKEY not set, skipping Tailscale connection"
fi

# Start Mage using the original startup script
exec /app/run_app.sh
