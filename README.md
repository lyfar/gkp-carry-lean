Egor is building an independent AI research lab because his son Misha has rare genetic hearing loss. Every checked result tests and advances the research workflow. One rare disease is rare. Rare diseases together are not.

# Bounded C3 carry certificate

This repository is an honest public research snapshot: a complete Lean
formalization of one bounded result arising in a carry-based attack on a
ternary-digit problem. It is not a solution of the surrounding open problem.

## Proved

Write `ternaryLength m` for the length of the ordinary base-three expansion of
`m`. Ternary digit lists are little-endian. The headline theorem is:

```lean
theorem four_pow_prefix_carry_count_ge_two_in_finite_range
    {m : ℕ} (hlower : 27 ≤ m) (hupper : m ≤ 6560) :
    2 ≤ prefixTernaryDoubleCarryCount
      (6 * ternaryLength m) (4 ^ m)
```

For every integer `m` from `27` through `6560`, doubling the first
`6 * ternaryLength m` ternary digits of `4 ^ m` therefore produces at least
two outgoing carries. The stronger digit statement is also formalized:

```lean
theorem four_pow_has_two_ternary_twos_in_finite_range
    {m : ℕ} (hlower : 27 ≤ m) (hupper : m ≤ 6560) :
    hasTwoTernaryTwosBelow (6 * ternaryLength m) (4 ^ m)
```

The upper endpoint is exact for the length-indexed finite band:
`ternaryLength m ≤ 8` and `m ≥ 27` give `27 ≤ m ≤ 3^8 - 1 = 6560`.

The proof checks modular residues with a structurally recursive repeated-squaring
function. Its correctness is proved against ordinary exponentiation. Small
Boolean certificates, evaluated by kernel reduction with `decide`, cover the
finite interval in 64-value chunks.

## Not proved

**The universal Gate W statement is not proved. The Graham–Knuth–Patashnik
problem and Erdős problem #406 are not proved. No open problem is claimed
solved.**

In the notation of this repository, the missing universal gate would require a
statement of the following shape for every larger ternary length:

```text
∀ m, 27 ≤ m → 9 ≤ ternaryLength m →
  hasTwoTernaryTwosBelow (3 * ternaryLength m + 9) (4 ^ m)
```

The checked interval stops immediately before ternary length nine. A finite
certificate cannot establish the universal statement.

## Scope of the finite-state evidence

Earlier reconnaissance excluded only one literal encoding: exact residual
prefix states represented by inverse-transducer sections. Fixed-window searches
and a separate valuation search also failed to produce a uniform certificate.
Those negative experiments do **not** rule out finite-state arguments in
general, alternative compressed automata, 3-adic arguments, valuation methods,
or another uniform proof. The correct conclusion is “no certificate was found
in those tested models,” not “finite-state methods were proved impossible.”

## Mathematical sources

- Ronald L. Graham, Donald E. Knuth, and Oren Patashnik, *Concrete Mathematics:
  A Foundation for Computer Science*, second edition; see the
  [authors' official book page](https://cs.stanford.edu/~knuth/gkp.html).
- The surrounding ternary-digit conjecture is catalogued as
  [Erdős Problem #406](https://www.erdosproblems.com/406), with original-source
  references and current status.
- Jeffrey C. Lagarias,
  [“Ternary expansions of powers of 2”](https://arxiv.org/abs/math/0512006),
  treats the broader dynamical and 3-adic setting.
- Robert I. Saye,
  [“On Two Conjectures Concerning the Ternary Digits of Powers of Two”](https://escholarship.org/uc/item/28m2v9br),
  reports large finite computations for related conjectures. Those external
  computations are context only and are not imported as proof evidence here.

## Reproduce

The project pins Lean and Mathlib to `v4.31.0-rc1`. With
[elan](https://github.com/leanprover/elan) installed:

```bash
git clone https://github.com/lyfar/gkp-carry-lean.git
cd gkp-carry-lean
lake exe cache get
lake build
bash scripts/audit.sh
```

The audit scans Lean sources for prohibited proof commands and proof-resource
overrides, then runs `AxiomAudit.lean`. At this revision, every audited headline
theorem reports only `propext`, `Classical.choice`, and `Quot.sound`, the
standard Lean principles documented in the
[Lean reference manual](https://lean-lang.org/doc/reference/latest/Axioms/).
There are no project-specific assumptions or compiler-trust proof dependencies.

CI repeats dependency-cache setup, the full project build, and the audit on
every push and pull request.

## Proof provenance

Egor Lyfar specified the mathematical scope, publication constraints, and
honesty requirements. OpenAI Codex developed the standalone Lean proof and
documentation from an earlier Construct research branch under Egor's direction.
All accepted proof terms are checked by the pinned Lean kernel; AI authorship is
provenance, not a substitute for checking.

## Future Lean Pool target

This bounded snapshot is deliberately **not** submitted to Lean Pool. A future
Lean Pool project should first add a source-anchored, self-contained body of
theory with a research-level headline result—most naturally the universal gate
above, or another comparably significant theorem. Only then should it be ported
as one clean theory branch and pull request.

## License

Apache License 2.0. See [LICENSE](LICENSE).
