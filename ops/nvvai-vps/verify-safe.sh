#!/usr/bin/env bash
# Read-only guard: no secret content or matching lines are printed.
set -euo pipefail
root="$(git rev-parse --show-toplevel)"
cd "$root"
bad=0
while IFS= read -r -d '' file; do
  case "$file" in
    */runtime.env|*/.9router/*|*/data/*.sqlite*|*/auth/*|*/jwt-secret|*/cli-secret|*/machine-id|*/tunnel/state.json|*/cloudflared.pid)
      bad=1 ;;
  esac
done < <(git ls-files -z)
if [ "$bad" -ne 0 ]; then
  printf 'FAIL: a potentially private runtime file is tracked (path hidden)\n' >&2
  exit 1
fi
if git grep -IqE -- '(-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----|github_pat_[[:alnum:]_]{20,}|ghp_[[:alnum:]]{20,}|sk-[[:alnum:]_-]{24,})' -- ops/nvvai-vps; then
  printf 'FAIL: a possible credential occurs in ops/nvvai-vps (match hidden)\n' >&2
  exit 1
fi
printf 'PASS: common private-file and token-pattern guards; manual audit still required\n'
