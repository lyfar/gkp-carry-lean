Egor is building an independent AI research lab because his son Misha has rare genetic hearing loss. Every checked result tests and advances the research workflow. One rare disease is rare. Rare diseases together are not.

# A carry-language characterization of the GKP conjecture

This repository is an honest public research snapshot of a complete,
kernel-checked body of Lean theory about ternary carries and the
Graham--Knuth--Patashnik (GKP) central-binomial divisibility conjecture. It
contains an exact characterization and reduction, not a solution of the open
conjecture.

## Headline theorem

The GKP statement formalized here is

```lean
def gkpConjecture : Prop :=
  ∀ n : ℕ, 4 < n → n ≠ 64 → n ≠ 256 →
    (4 ∣ Nat.centralBinom n ∨ 9 ∣ Nat.centralBinom n)
```

The remaining deficient-carry language statement is

```lean
def gkpBadCarryLanguageExclusion : Prop :=
  ∀ k : ℕ, 2 < k → k ≠ 6 → k ≠ 8 →
    badCarryLanguage (Nat.digits 3 (2 ^ k)) = false
```

The headline result proves their exact equivalence:

```lean
theorem gkpConjecture_iff_badCarryLanguageExclusion :
    gkpConjecture ↔ gkpBadCarryLanguageExclusion
```

This is useful because `badCarryLanguage` is not an informal condition. It is
a verified four-state deterministic automaton. On valid ternary words it
accepts exactly those words for which doubling creates fewer than two carries.

## Supporting theory

The formalization proves, for every natural number `n`,

```lean
theorem nine_dvd_centralBinom_iff_two_le_ternaryDoubleCarryCount (n : ℕ) :
    9 ∣ Nat.centralBinom n ↔
      2 ≤ ternaryDoubleCarryCount (Nat.digits 3 n)
```

It also proves that the deficient-carry language consists of exactly three
little-endian ternary word shapes:

1. every digit is `0` or `1`;
2. there is one digit `2`, and it is the most significant digit;
3. there is one digit `2`, followed by a higher `0`, with all other digits
   equal to `0` or `1`.

The accepted words are counted exactly:

```lean
theorem card_badCarryWords (n : ℕ) :
    Fintype.card (BadCarryWords (n + 2)) = (n + 7) * 2 ^ n
```

The development includes the Kummer digit-sum bridge, reduction of the full
GKP statement to powers of two, arithmetic correctness of the carry automaton,
the concrete language classification, and its enumeration.

## Bounded corollary

The earlier C3 certificate remains as a secondary application:

```lean
theorem nine_dvd_centralBinom_four_pow_in_finite_range
    {m : ℕ} (hlower : 27 ≤ m) (hupper : m ≤ 6560) :
    9 ∣ Nat.centralBinom (4 ^ m)
```

Its proof checks modular residues with structurally recursive repeated
squaring, proved correct against ordinary exponentiation. Kernel-evaluated
Boolean certificates cover the finite interval in 64-value chunks.

## Not proved

**The universal Gate W statement is not proved. The universal deficient-carry
language exclusion is not proved. The GKP conjecture and Erdős Problem 406 are
not proved. No open problem is claimed solved.**

The right-hand side of
`gkpConjecture_iff_badCarryLanguageExclusion` remains open. The equivalence
identifies the exact missing theorem; it does not supply it. Likewise, the
bounded range `27 ≤ m ≤ 6560` does not imply any universal tail statement.

## Scope of the finite-state evidence

Earlier reconnaissance excluded only one literal encoding: exact residual
prefix states represented by inverse-transducer sections. Fixed-window
searches and a separate valuation search also failed to produce a uniform
certificate. Those negative experiments do **not** rule out finite-state
arguments in general, alternative compressed automata, 3-adic arguments,
valuation methods, or another uniform proof. The correct conclusion is that no
certificate was found in the tested models, not that finite-state methods were
proved impossible.

## Mathematical sources

- Ronald L. Graham, Donald E. Knuth, and Oren Patashnik, *Concrete
  Mathematics: A Foundation for Computer Science*, second edition; see the
  [authors' official book page](https://cs.stanford.edu/~knuth/gkp.html).
- The related ternary-digit conjecture is catalogued as
  [Erdős Problem 406](https://www.erdosproblems.com/406), with original-source
  references and current status.
- Jeffrey C. Lagarias,
  [“Ternary expansions of powers of 2”](https://arxiv.org/abs/math/0512006),
  gives broader dynamical and 3-adic context.
- Robert I. Saye,
  [“On Two Conjectures Concerning the Ternary Digits of Powers of Two”](https://escholarship.org/uc/item/28m2v9br),
  reports large finite computations for related conjectures. Those external
  computations are context only and are not imported as proof evidence.

## Reproduce and verify

The project pins Lean and Mathlib to `v4.32.0-rc1`. With
[elan](https://github.com/leanprover/elan) installed:

```bash
git clone https://github.com/lyfar/gkp-carry-lean.git
cd gkp-carry-lean
lake exe cache get
lake build GKPCarry
lake exe runLinter GKPCarry
lake exe lint-style GKPCarry
bash scripts/audit.sh
```

The audit rejects prohibited proof commands, custom assumptions, diagnostics
inside project modules, broad imports, proof-resource overrides, and source
files over 700 lines. It then runs `AxiomAudit.lean`. Every audited result
depends only on `propext`, `Classical.choice`, and `Quot.sound`, the standard
Lean principles documented in the
[Lean reference manual](https://lean-lang.org/doc/reference/latest/Axioms/).
There are no project-specific assumptions or compiler-trust proof
dependencies.

CI repeats the build, linter, style linter, and proof-surface audit on every
push and pull request.

## Proof provenance

Egor Lyfar specified the mathematical scope, source anchors, publication
constraints, and honesty requirements. OpenAI Codex developed the formalization
from Construct reconnaissance and the earlier bounded certificate under Egor's
direction. All accepted proof terms are checked by the pinned Lean kernel; AI
provenance is not a substitute for checking.

## Lean Pool

The maintainer-facing port is
[Vilin97/lean-pool PR 273](https://github.com/Vilin97/lean-pool/pull/273).
The upstream project card stays mathematical and source-focused; this
standalone companion records the broader MISHA research mission.

## License

Apache License 2.0. See [LICENSE](LICENSE).
