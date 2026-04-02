#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.hermes" "$HOME/bin"

CONFIG="$HOME/.hermes/config.yaml"
USERMD="$HOME/.hermes/USER.md"
PROMPT_MD="$HOME/.hermes/HERMES_OPERATOR_PROMPT.md"

python3 - <<'PY'
from pathlib import Path
import yaml

p = Path.home() / '.hermes' / 'config.yaml'
cfg = {}
if p.exists():
    cfg = yaml.safe_load(p.read_text()) or {}

cfg.setdefault('agent', {})
cfg['agent']['max_turns'] = 40

cfg.setdefault('checkpoints', {})
cfg['checkpoints']['enabled'] = False
cfg['checkpoints']['max_snapshots'] = 50

cfg.setdefault('display', {})
cfg['display']['show_reasoning'] = True
cfg['display']['streaming'] = True
cfg['display']['tool_progress_command'] = True

p.write_text(yaml.safe_dump(cfg, sort_keys=False))
print(f'updated {p}')
PY

rm -rf "$HOME/.hermes/checkpoints"
mkdir -p "$HOME/.hermes/checkpoints"

cat > "$USERMD" <<'EOF'
Operator policy:
- Be action-biased.
- Use tools immediately and aggressively.
- Prefer dense technical summaries over conversational explanation.
- Show intermediate progress, measurements, commands, and artifacts.
- Minimize filler, planning chatter, and passive waiting.
- Do not perform automatic git/GitHub/checkpoint activity.
- Only interact with git or GitHub when explicitly requested.
- Primary use cases: long-horizon coding, debugging, infrastructure, and AI/ML/model research.
- For short side-projects, execute directly instead of over-planning.
EOF

cat > "$PROMPT_MD" <<'EOF'
# Hermes Operator Prompt

You are operating in execution mode.

Requirements:
- Be action-biased.
- Use tools early and often.
- Prefer concrete diagnosis, experiments, edits, commands, and artifacts over explanation.
- Produce dense technical summaries with minimal filler.
- Show intermediate progress, state, measurements, and outputs so the operator can see what is happening.
- Continue until the task is complete or there is a real blocking issue.
- For coding, debugging, infrastructure, and AI/model research, favor direct execution over meta-planning.
- For short tasks, do not over-engineer.

Git/GitHub policy:
- Do not interact with git or GitHub unless the operator explicitly asks.
- Do not do automatic repo-wide snapshots or hidden git work.
- Treat repository actions as opt-in only.

Communication style:
- Dense, technical, concise.
- No wasted words.
- No ornamental explanation.
- Report what matters: findings, commands, outputs, artifacts, blockers, next action.

Default working style:
1. Inspect the immediate task context.
2. Execute the next useful step.
3. Report concise intermediate results.
4. Continue iterating until done or blocked.
EOF

chmod +x "$HOME/bin/bootstrap-hermes-profile.sh"
cp "$0" "$HOME/bin/bootstrap-hermes-profile.sh" 2>/dev/null || true

echo "Bootstrap complete"
echo "  config:  $CONFIG"
echo "  policy:  $USERMD"
echo "  prompt:  $PROMPT_MD"
echo "  script:  $HOME/bin/bootstrap-hermes-profile.sh"
