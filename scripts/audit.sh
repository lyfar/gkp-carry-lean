#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$project_root"

for token in so""rry ad""mit ax""iom un""safe par""tial op""aque native_""decide; do
  if rg --glob '*.lean' --line-number --word-regexp "$token" .; then
    echo "forbidden Lean token found: $token" >&2
    exit 1
  fi
done

if rg --glob '*.lean' --line-number 'set_option[[:space:]]+(maxHeartbeats|maxRecDepth|exponentiation\.threshold)' .; then
  echo "proof resource override found" >&2
  exit 1
fi

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
