# Hermes Bootstrap Bundle

This bundle applies a focused Hermes profile for long-horizon coding, debugging, infrastructure, and AI/model research tasks.

Goals:
- action-biased behavior
- visible progress and intermediate results
- dense technical summaries
- no automatic git/GitHub/checkpoint activity
- less hidden orchestration overhead

## Files

- `bootstrap-hermes-profile.sh`
  - patches `~/.hermes/config.yaml`
  - disables checkpoints
  - enables visible progress settings
  - clears and recreates `~/.hermes/checkpoints`
  - writes `~/.hermes/USER.md`
  - writes `~/.hermes/HERMES_OPERATOR_PROMPT.md`
- `HERMES_OPERATOR_PROMPT.md`
  - reusable operator prompt text

## Install on another server

Copy this directory to the target machine, then run:

```bash
chmod +x bootstrap-hermes-profile.sh
./bootstrap-hermes-profile.sh
```

The script uses `$HOME`, so run it as the intended operator user.

## Resulting config changes

```yaml
agent:
  max_turns: 40

checkpoints:
  enabled: false
  max_snapshots: 50

display:
  show_reasoning: true
  streaming: true
  tool_progress_command: true
```

## Notes

- Checkpoints are disabled because Hermes' hidden shadow-git snapshots can stall badly on broad directories or model-heavy trees.
- This profile assumes git/GitHub actions should only happen when explicitly requested by the operator.
- Best results come from launching Hermes inside the specific repo/task directory, not from a broad workspace root.
