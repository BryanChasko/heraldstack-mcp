#!/usr/bin/env bash
# heraldstack-project-init.sh — Bootstrap HeraldStack ProjectLayout for a work project.
#
# Usage:
#   ./heraldstack-project-init.sh <project-root> <project-name> [profile]
#
# Profiles: code (default), chrome-extension, docs, infra
#
# What this does:
#   1. Creates the full directory tree (.claude/, .kiro/, .gemini/, .goose/, .github/)
#   2. Writes template config files with project name substituted
#   3. Creates 15 GitHub labels (cli:*, agent:*, domain:*, status:*) in the repo
#
# What this does NOT do:
#   - Commit or push anything
#   - Write narrative content (CLAUDE.md, GOOSE-project.md, etc.) — do that manually
#   - Replace existing files

set -euo pipefail

# ── args ──────────────────────────────────────────────────────────────────────
if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <project-root> <project-name> [profile]"
  echo "Profiles: code (default), chrome-extension, docs, infra"
  exit 1
fi

PROJECT_ROOT="$1"
PROJECT_NAME="$2"
PROFILE="${3:-code}"
MCP_LAUNCHERS="/home/bryanchasko/code/heraldstack/heraldstack-mcp/launchers"

if [[ ! -d "$PROJECT_ROOT" ]]; then
  echo "ERROR: project-root '$PROJECT_ROOT' does not exist"
  exit 1
fi

# ── helpers ───────────────────────────────────────────────────────────────────
write_if_absent() {
  local path="$1"
  local content="$2"
  if [[ -f "$path" ]]; then
    echo "  SKIP (exists): $path"
  else
    mkdir -p "$(dirname "$path")"
    echo "$content" > "$path"
    echo "  CREATED: $path"
  fi
}

# ── directories ───────────────────────────────────────────────────────────────
echo ""
echo "heraldstack-project-init — $PROJECT_NAME ($PROFILE)"
echo "project root: $PROJECT_ROOT"
echo ""
echo "Creating directories..."

mkdir -p \
  "$PROJECT_ROOT/.claude/agents" \
  "$PROJECT_ROOT/.kiro/steering" \
  "$PROJECT_ROOT/.kiro/settings" \
  "$PROJECT_ROOT/.gemini" \
  "$PROJECT_ROOT/.goose/extensions" \
  "$PROJECT_ROOT/.github/ISSUE_TEMPLATE" \
  "$PROJECT_ROOT/.github/PULL_REQUEST_TEMPLATE"

echo "  OK"

# ── MCP scoping by profile ────────────────────────────────────────────────────
# Tier 1 — always present: github, context7
# Tier 2 — by profile

case "$PROFILE" in
  chrome-extension)
    CLAUDE_SERVERS='"github", "context7", "qdrant-shared", "chrome-devtools"'
    GOOSE_PROFILE_NAME="chrome-extension"
    ;;
  docs)
    CLAUDE_SERVERS='"github", "context7", "qdrant-writing", "qdrant-inbox"'
    GOOSE_PROFILE_NAME="docs"
    ;;
  infra)
    CLAUDE_SERVERS='"github", "context7", "qdrant-shared", "valkey"'
    GOOSE_PROFILE_NAME="full"
    ;;
  code|*)
    CLAUDE_SERVERS='"github", "context7", "qdrant-shared"'
    GOOSE_PROFILE_NAME="core"
    ;;
esac

# ── .mcp.json ─────────────────────────────────────────────────────────────────
echo ""
echo "Writing .mcp.json..."

MCP_SERVERS=$(cat <<EOF
{
  "mcpServers": {
    "github": {
      "command": "bash",
      "args": ["-c", "${MCP_LAUNCHERS}/core/github.sh"]
    },
    "context7": {
      "command": "bash",
      "args": ["-c", "${MCP_LAUNCHERS}/core/context7.sh"]
    },
    "qdrant-shared": {
      "type": "http",
      "url": "http://localhost:8102/mcp"
    }
  }
}
EOF
)

write_if_absent "$PROJECT_ROOT/.mcp.json" "$MCP_SERVERS"

# ── .claude/settings.local.json ───────────────────────────────────────────────
echo ""
echo "Writing .claude/settings.local.json..."

write_if_absent "$PROJECT_ROOT/.claude/settings.local.json" \
'{
  "enabledMcpjsonServers": ['"$CLAUDE_SERVERS"']
}'

# ── .kiro/settings/mcp.json ───────────────────────────────────────────────────
echo ""
echo "Writing .kiro/settings/mcp.json..."

write_if_absent "$PROJECT_ROOT/.kiro/settings/mcp.json" \
'{
  "mcpServers": {
    "github": {
      "command": "bash",
      "args": ["-c", "'"${MCP_LAUNCHERS}/core/github.sh"'"]
    },
    "context7": {
      "command": "bash",
      "args": ["-c", "'"${MCP_LAUNCHERS}/core/context7.sh"'"]
    }
  }
}'

# ── .gemini/settings.json ─────────────────────────────────────────────────────
echo ""
echo "Writing .gemini/settings.json..."

write_if_absent "$PROJECT_ROOT/.gemini/settings.json" \
'{
  "mcpServers": {
    "github": {
      "command": "bash",
      "args": ["-c", "'"${MCP_LAUNCHERS}/core/github.sh"'"]
    },
    "context7": {
      "command": "bash",
      "args": ["-c", "'"${MCP_LAUNCHERS}/core/context7.sh"'"]
    },
    "qdrant-shared": {
      "command": "bash",
      "args": ["-c", "'"${MCP_LAUNCHERS}/bridges/qdrant-shared-knowledge-bridge.sh"'"]
    }
  }
}'

# ── .github/CODEOWNERS ────────────────────────────────────────────────────────
echo ""
echo "Writing .github/CODEOWNERS..."

write_if_absent "$PROJECT_ROOT/.github/CODEOWNERS" \
'# CODEOWNERS — HeraldStack CLI routing map
.claude/    @BryanChasko
.kiro/      @BryanChasko
.gemini/    @BryanChasko
.goose/     @BryanChasko
.github/    @BryanChasko
.mcp.json   @BryanChasko
src/        @BryanChasko'

# ── Placeholder files (narrative content — edit manually) ─────────────────────
echo ""
echo "Writing placeholder narrative files (edit content manually)..."

write_if_absent "$PROJECT_ROOT/.claude/CLAUDE.md" \
"# Shannon — ${PROJECT_NAME}

## Project Scope

<!-- Describe the project and Shannon's role -->

## Active MCP Servers

<!-- List enabled MCP servers and their purpose -->

## Shannon Constraints

- Do not push to \`main\` directly
- Check \`PROJECT-STATUS.md\` before starting any work session

## Key Files

<!-- List important files Shannon should know about -->
"

write_if_absent "$PROJECT_ROOT/.kiro/steering/project-context.md" \
"---
title: Project Context
created: $(date +%Y-%m-%d)
updated: $(date +%Y-%m-%d)
status: active
scope: project
applies_to: all
---

# Project Context — ${PROJECT_NAME}

## Summary

<!-- Describe the project -->

## Current State

<!-- Current sprint or development status -->

## Agent Assignments

<!-- Which CLI/agent owns which domain -->

## Active Constraints

<!-- Key constraints all agents must respect -->
"

write_if_absent "$PROJECT_ROOT/.gemini/GEMINI.md" \
"# Ibeji — ${PROJECT_NAME}

## Project Scope

<!-- Describe ibeji's role in this project -->

## Active MCP Servers

- github
- context7
- qdrant-shared (bridge)

## Constraints

- Do not push to \`main\` directly
- Read \`PROJECT-STATUS.md\` at session start
"

write_if_absent "$PROJECT_ROOT/.goose/GOOSE-project.md" \
"## Project Context — ${PROJECT_NAME}

<!-- Describe gander's role and key context for this project -->

At session start: run \`gh issue list --label \"cli:gander\" --label \"status:ready\"\` to see queued tasks.
"

write_if_absent "$PROJECT_ROOT/.goose/extensions/${GOOSE_PROFILE_NAME}.yaml" \
"# ${GOOSE_PROFILE_NAME}.yaml — Project-scoped goose extension profile for ${PROJECT_NAME}.

extensions:

  developer:
    enabled: true
    type: builtin
    name: developer
    timeout: 600

  summon:
    enabled: true
    type: builtin
    name: summon
    timeout: 300

  github:
    enabled: true
    type: stdio
    name: github
    cmd: ${MCP_LAUNCHERS}/core/github.sh
    args: []
    timeout: 300

  context7:
    enabled: true
    type: stdio
    name: context7
    cmd: ${MCP_LAUNCHERS}/core/context7.sh
    args: []
    timeout: 300

  qdrant-shared:
    enabled: true
    type: stdio
    name: qdrant-shared
    cmd: ${MCP_LAUNCHERS}/bridges/qdrant-shared-knowledge-bridge.sh
    args: []
    timeout: 300
"

# ── .github templates ─────────────────────────────────────────────────────────
echo ""
echo "Writing .github templates..."

write_if_absent "$PROJECT_ROOT/.github/copilot-instructions.md" \
"# GitHub Copilot Instructions — ${PROJECT_NAME}

## Project

<!-- Short project description for Copilot context -->

## Code Style

<!-- Language, framework, patterns to follow -->

## Constraints

- No direct commits to \`main\`
- Do not modify \`.kiro/\`, \`.claude/\`, \`.gemini/\`, or \`.goose/\` directories

## HeraldStack Context

Agent tasks coordinated via GitHub issues. Labels: \`cli:shannon\`, \`cli:haunting\`, \`cli:gander\`, \`cli:ibeji\`, \`cli:squad\`.
"

write_if_absent "$PROJECT_ROOT/.github/ISSUE_TEMPLATE/agent-task.yml" \
'name: Agent Task
description: Structured task template for HeraldStack CLI agent work
title: "[<CLI>] <short objective>"
labels: ["agent:task", "status:ready"]
body:
  - type: dropdown
    id: assigned-cli
    attributes:
      label: Assigned CLI
      options:
        - cli:shannon
        - cli:haunting
        - cli:gander
        - cli:ibeji
        - cli:squad
    validations:
      required: true
  - type: dropdown
    id: domain
    attributes:
      label: Domain
      options:
        - domain:code
        - domain:config
        - domain:docs
        - domain:test
        - domain:infra
    validations:
      required: true
  - type: textarea
    id: objective
    attributes:
      label: Objective
    validations:
      required: true
  - type: textarea
    id: acceptance-criteria
    attributes:
      label: Acceptance Criteria
    validations:
      required: true
  - type: textarea
    id: context
    attributes:
      label: Context (optional)
    validations:
      required: false'

write_if_absent "$PROJECT_ROOT/.github/PULL_REQUEST_TEMPLATE/agent-pr.md" \
'## Authored by

- **CLI:** <!-- shannon | haunting | gander | ibeji | squad -->
- **Agent slug:** <!-- e.g. entropy-harold-core-anchor -->

## Objective

Closes #<!-- issue number -->

## Changes

-

## Validation performed

- [ ] Tests run
- [ ] No secrets in committed files
- [ ] CI checks passed

🤖 Generated with [Claude Code](https://claude.ai/code) via HeraldStack shannon'

# ── GitHub labels ─────────────────────────────────────────────────────────────
echo ""
echo "Creating GitHub labels (15 total)..."
echo "Working from: $PROJECT_ROOT"

cd "$PROJECT_ROOT"

# Check gh is available and repo is detected
if ! command -v gh >/dev/null 2>&1; then
  echo "  SKIP: gh CLI not found — create labels manually"
else
  create_label() {
    local name="$1" color="$2" desc="$3"
    gh label create "$name" --color "$color" --description "$desc" --force 2>/dev/null \
      && echo "  OK: $name" \
      || echo "  FAIL: $name (check gh auth)"
  }

  # CLI assignment (blue family)
  create_label "cli:shannon"  "0075ca" "Assigned to Shannon (Claude Code)"
  create_label "cli:haunting" "0075ca" "Assigned to Haunting (kiro)"
  create_label "cli:gander"   "0075ca" "Assigned to Gander (goose)"
  create_label "cli:ibeji"    "0075ca" "Assigned to Ibeji (Gemini CLI)"
  create_label "cli:squad"    "0075ca" "Assigned to Squad (GitHub Copilot)"

  # Work type (purple family)
  create_label "agent:task"         "d93f0b" "Discrete agent task"
  create_label "agent:blocked"      "e4e669" "Blocked — needs human or cross-CLI input"
  create_label "agent:review-needed" "d4c5f9" "Needs review before merge"
  create_label "agent:handoff"      "d4c5f9" "Handoff between CLI agents"

  # Domain (green family)
  create_label "domain:code"   "0e8a16" "Source code changes"
  create_label "domain:config" "0e8a16" "Config or tooling changes"
  create_label "domain:docs"   "0e8a16" "Documentation"
  create_label "domain:test"   "0e8a16" "Test additions or fixes"
  create_label "domain:infra"  "0e8a16" "Infrastructure or CI changes"

  # Status (grey family)
  create_label "status:ready"       "ededed" "Ready for agent pickup"
  create_label "status:in-progress" "ededed" "Agent actively working"
  create_label "status:done"        "ededed" "Complete"
  create_label "status:stale"       "ededed" "No recent activity — needs triage"
fi

# ── summary ───────────────────────────────────────────────────────────────────
echo ""
echo "heraldstack-project-init complete."
echo ""
echo "Checklist:"
echo "  [ ] Edit .claude/CLAUDE.md — project scope and constraints"
echo "  [ ] Edit .kiro/steering/project-context.md — agent assignments and constraints"
echo "  [ ] Edit .gemini/GEMINI.md — ibeji role description"
echo "  [ ] Edit .goose/GOOSE-project.md — gander context"
echo "  [ ] Edit .github/copilot-instructions.md — Copilot context"
echo "  [ ] Verify .mcp.json server list matches project needs"
echo "  [ ] Open Shannon session in project dir — confirm MCP servers load"
echo "  [ ] Run: gh issue list — confirm labels exist"
echo ""
