#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

lean_sources=(GKPCarry.lean GKPCarry)

for token in so""rry ad""mit ax""iom con""stant un""safe par""tial op""aque \
  native_""decide no""lint; do
  if rg --glob '*.lean' --line-number --word-regexp "$token" "${lean_sources[@]}"; then
    echo "forbidden Lean token found: $token" >&2
    exit 1
  fi
done

if rg --glob '*.lean' --line-number \
  '@\[extern\]|^[[:space:]]*set_option\b|^[[:space:]]*import[[:space:]]+Mathlib[[:space:]]*$|^[[:space:]]*#(check|print|eval|reduce)\b' \
  "${lean_sources[@]}"; then
  echo "forbidden Lean command found" >&2
  exit 1
fi

while IFS= read -r -d '' source; do
  lines="$(wc -l < "$source")"
  if (( lines > 700 )); then
    echo "Lean source exceeds 700 lines: $source ($lines)" >&2
    exit 1
  fi
done < <(find GKPCarry -type f -name '*.lean' -print0)

audit_output="$(lake env lean AxiomAudit.lean 2>&1)"
printf '%s\n' "$audit_output"

unexpected="$(
  printf '%s\n' "$audit_output" |
    sed -E "s/^'[^']+' depends on axioms: //" |
    tr -d '[],' |
    tr ' ' '\n' |
    rg -v '^(propext|Classical\.choice|Quot\.sound|)$' || true
)"
if [[ -n "$unexpected" ]]; then
  echo "unexpected dependency in theorem audit: $unexpected" >&2
  exit 1
fi

echo "audit passed"
