FROM node:24-trixie
RUN npm install -g @anthropic-ai/claude-code
RUN git config --system --add safe.directory '*'
RUN apt-get update && apt-get install -y gh && rm -rf /var/lib/apt/lists/*

COPY profile/settings.json /etc/claude-code/managed-settings.json
COPY profile/CLAUDE.md /etc/claude-code/CLAUDE.md
COPY profile/LABELS.md /etc/claude-code/LABELS.md
COPY profile/CODING_STANDARDS.md /etc/claude-code/CODING_STANDARDS.md
COPY profile/Skills /opt/claude-leer/skills
COPY --chmod=755 entrypoint.sh /opt/claude-leer/entrypoint.sh

USER node
RUN mkdir -p /home/node/.claude
ENV CLAUDE_CONFIG_DIR=/home/node/.claude
ENV DISABLE_AUTOUPDATER=1
WORKDIR /workspace
ENTRYPOINT ["/opt/claude-leer/entrypoint.sh"]
