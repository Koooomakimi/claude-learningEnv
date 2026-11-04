#!/usr/bin/env bash
set -euo pipefail

# Refresh skills from the image, so a rebuild always takes effect
rm -rf "$CLAUDE_CONFIG_DIR/skills"
cp -r /opt/claude-leer/skills "$CLAUDE_CONFIG_DIR/skills"

# Start Claude with whatever arguments were passed
exec claude "$@"
