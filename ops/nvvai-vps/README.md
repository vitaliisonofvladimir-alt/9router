# NVVAI 9router — VPS sync (sanitized)

## Snapshot: 2026-11-09

This folder captures **non-secret deployment metadata** for the 9router installation, without copying runtime state or credentials.

- Repository: `vitaliisonofvladimir-alt/9router`, default branch `master`.
- VPS source `HEAD` and GitHub `master`: `1fe586bb1cf35e1ed0cb2150a8ef7d1db040b21d` (v0.5.112). **Already identical.**
- VPS source worktree at inspection: clean (no tracked or untracked changes).
- Runtime: user systemd service `nvvai-9router.service`, enabled and running at inspection.
- Entry point: `node custom-server.js`, with `test -f custom-server.js` preflight.
- systemd behavior: `Type=simple`, `Restart=on-failure`, `RestartSec=15s`, `MemoryMax=1100M`, `CPUQuota=75%`, `NoNewPrivileges=true`, `UMask=0077`, `LimitNOFILE=8192`.
- The actual VPS unit also defines `WorkingDirectory`, `Environment`, and `EnvironmentFile`; their values are intentionally not published.
- The VPS has operational tunnel helper scripts named `9router-tunnel-enable-once.py`, `9router-tunnel-status.py` and `9router-tunnel-public-verify.py`. Their contents are deliberately **not** mirrored until independently checked for secrets and external identifiers.

## What is included

`nvvai-9router.service.example` is a portable **template**, not a copy of the active unit. `runtime.env.example` documents variable **names only**. `vps-inventory.json` is a machine-readable, redacted snapshot. `verify-safe.sh` checks for common accidentally tracked secret files and token-like strings in this deployment folder without displaying matches.

## Must stay ONLY on the VPS

Never commit, attach to PRs, or print the following: `runtime.env`, `.9router/`, `data/` (including SQLite databases, WAL and SHM), `auth/`, `jwt-secret`, `cli-secret`, `machine-id`, `cloudflared.pid`, `tunnel/state.json`, private keys, cookies, API tokens, or full contents of the active systemd unit. An example file must never contain a real credential.

## Safe reconciliation

1. Compare `git rev-parse HEAD` locally with the intended GitHub SHA.
2. Update only reviewed **source and sanitized templates** in a feature branch.
3. Run `bash ops/nvvai-vps/verify-safe.sh` and review the diff without printing or exporting live values.
4. Keep runtime secrets and databases server-local; deploy/restart only after separate explicit Owner approval.

**Scope:** GitHub-only documentation and example templates. No service changes, no VPS restart, no tunnel reconfiguration, no database export, and no live credentials copied.
