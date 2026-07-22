Egor is building an independent AI research lab because his son Misha has rare genetic hearing loss. Every checked result tests and advances the research workflow. One rare disease is rare. Rare diseases together are not.

# A density-one GKP theorem and exact carry distributions

This repository contains two complete, kernel-checked developments. The first
gives an exact all-depth modular sieve for the power-of-two carry condition in
the Graham--Knuth--Patashnik conjecture. The second gives the exact
distribution of

```text
ν_p ((2n choose n))
```

over each complete residue block `0 ≤ n < p ^ k`, for each odd prime `p`.

Lean proves that the exponents satisfying the GKP divisibility condition have
natural density one. The GKP conjecture remains open because a density-zero
exceptional set may be nonempty.

## Headline GKP result

At ternary prefix depth `n + 3`, powers of two have exact exponent period

```text
2 * 3^(n + 2).
```

Lean proves that exactly

```text
(n + 9) * 2^n
```

classes in that period still show fewer than two doubling carries. For each
remaining class and each exponent `k` in that congruence class, Lean proves

```text
9 ∣ centralBinom (2^k).
```

The entry theorem includes the exact count, divisibility, and carry-language
avoidance:

```lean
theorem gkp_exact_modular_sieve (n : ℕ) :
    Fintype.card (CertifiedExponentClasses n) =
        2 * 3 ^ (n + 2) - (n + 9) * 2 ^ n ∧
      ∀ exponentClass : CertifiedExponentClasses n,
        ∀ k : ℕ,
          k % (2 * 3 ^ (n + 2)) = exponentClass.val.val →
            9 ∣ Nat.centralBinom (2 ^ k) ∧
              badCarryLanguage (Nat.digits 3 (2 ^ k)) = false
```

The residual class proportion equals

```text
((n + 9) / 18) * (2 / 3)^n,
```

Lean proves that this expression tends to zero and that its complement tends
to one. At depth three, exactly nine of the eighteen exponent classes are
certified, with the explicit set
`{3, 4, 5, 7, 9, 10, 11, 15, 17}` modulo `18`.

## Density-one GKP theorem

For each bound `N`, let `GKPFailureExponentsBelow N` contain the exponents
`k < N` for which

```text
9 ∤ centralBinom (2^k).
```

The formalization embeds these possible failures into quotient blocks paired
with the residual modular classes. It proves the quantitative bound

```text
#failures below N ≤
  (N / (2 * 3^(n+2)) + 1) * ((n+9) * 2^n)
```

for every sieve depth `n`. Combining that bound with the geometric decay of
the residual class proportion gives the headline limit:

```lean
theorem tendsto_gkpFailureProportion_zero :
    Filter.Tendsto gkpFailureProportion Filter.atTop (nhds 0)

theorem tendsto_gkpSuccessProportion_one :
    Filter.Tendsto gkpSuccessProportion Filter.atTop (nhds 1)
```

These are natural-density statements about the actual exponent sequence,
rather than limits of unrelated finite samples.

## Odd-prime distribution result

Write the odd prime as `p = 2h + 1`, and put `b = h + 1`. Define

```text
A_p(k, r) = #{0 ≤ n < p^k : ν_p ((2n choose n)) = r}
F_k(X)    = Σ_r A_p(k, r) X^r.
```

The formalization proves that `F_k` is exactly the carry-count enumerator for
doubling all length-`k` base-`p` words. It proves the initial values

```text
F_0(X) = 1,
F_1(X) = b + hX,
```

and the full polynomial recurrence

```text
F_{k+2}(X) + pX F_k(X) = b(1 + X) F_{k+1}(X).
```

The entry theorem is

```lean
theorem oddPrimeValuationPolynomial_recurrence
    (half : ℕ) (hhalf : 0 < half) [Fact (oddBase half).Prime]
    (length : ℕ) :
    oddPrimeValuationPolynomial half (length + 2) +
        (oddBase half : Polynomial ℕ) * Polynomial.X *
          oddPrimeValuationPolynomial half length =
      ((half + 1 : ℕ) : Polynomial ℕ) * (1 + Polynomial.X) *
        oddPrimeValuationPolynomial half (length + 1)
```

## Rational generating function

Let `T` record block length and `X` record valuation. The development proves,
over natural coefficients, the denominator-cleared identity

```text
G + pX T²G + XT = 1 + b(1 + X)TG.
```

Equivalently, after moving terms in a coefficient ring,

```text
             1 - XT
G(X,T) = -------------------.
          1 - b(1+X)T + pXT²
```

The kernel-checked Lean declaration is
`oddPrimeValuationGeneratingSeries_identity`. The formal statement uses the
subtraction-free form so it remains valid directly in
`PowerSeries (Polynomial ℕ)`.

## Exact low-valuation counts

The same development derives closed formulas rather than only a recurrence:

```text
A_p(k, 0) = b^k,

A_p(m+2, 1) = h b^(m+1) + (m+1) h² b^m.
```

At `p = 3`, the two deficient strata therefore satisfy

```text
A_3(m+2, 0) + A_3(m+2, 1) = (m+7) 2^m.
```

This ternary corollary supplies the automaton count used by the all-depth GKP
sieve. By itself it does not imply universal avoidance by powers of two.

## What the proof builds

The formalization includes:

1. a two-state doubling transducer in every odd base `2h + 1`;
2. arithmetic correctness for padded base-`p` words;
3. a Kummer bridge identifying carries with
   `ν_p (Nat.centralBinom n)` for odd prime `p`;
4. a positional-notation equivalence between length-`k` words and
   `Fin (p ^ k)`;
5. the transfer-polynomial recurrence;
6. its exact coefficient recurrence and rational bivariate generating
   function;
7. closed counts for valuations zero and one;
8. the exact order of `2` modulo every positive power of `3`;
9. an equivalence between exponent periods and fixed-length ternary unit
   words; and
10. exact residual and certified GKP class counts at every prefix depth,
    together with their limiting proportions; and
11. a quantitative initial-interval bound and the density-zero theorem for
    possible GKP failures.

All source files are below 700 lines.

## Source anchor

The headline theorem formalizes Theorem 1 of S. M. Nazmuz Sakib,
[“Carry–Run Theorem and Sakib Index for the Exact Distribution of
`ν_p((2n choose n))` over `n mod p^k`”](https://doi.org/10.33774/coe-2026-1w9zm),
Cambridge Open Engage, version 1, 23 January 2026.

Cambridge University Press marks that working paper as not peer-reviewed. We
do not claim its theorem as a new mathematical discovery. This repository
supplies a machine-checked formalization of the exact carry distribution and
rational generating function. Kummer's carry interpretation is classical.

The original GKP context is Ronald L. Graham, Donald E. Knuth, and Oren
Patashnik, *Concrete Mathematics*, second edition; see the
[authors' official book page](https://cs.stanford.edu/~knuth/gkp.html).
The related ternary-power question is catalogued as
[Erdős Problem 406](https://www.erdosproblems.com/406).

We derived the all-depth modular sieve from the GKP problem and Kummer's
classical carry theorem. The book does not state this sieve, and we make no
claim of literature priority for it.

## Not proved

**The universal Gate W statement is not proved. The universal deficient-carry
language exclusion is not proved. The GKP conjecture and Erdős Problem 406 are
not proved. No open problem is claimed solved.**

The repository still proves the exact equivalence

```lean
theorem gkpConjecture_iff_badCarryLanguageExclusion :
    gkpConjecture ↔ gkpBadCarryLanguageExclusion
```

but its right-hand side remains open. The new distribution theorem describes
all residues in finite complete blocks. The modular sieve uses those finite
states and certifies a class proportion tending to one. The checked bounds do
prove that possible failures have natural density zero. They do not prove the
failure set empty. A GKP proof must exclude each residual nonexceptional
exponent. The current results leave open whether finite-state methods can make
further progress.

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

The audit rejects `sorry`, `admit`, custom axioms or constants, `unsafe`,
`partial`, `opaque`, `native_decide`, linter waivers, diagnostic commands,
broad imports, proof-resource overrides, and source files over 700 lines. It
then checks the axioms of the named results. The accepted proof terms depend
only on standard Lean/Mathlib principles reported by the audit; there are no
project-specific assumptions or compiler-trust proof shortcuts.

CI repeats the build, declaration linter, style linter, and proof-surface audit
on every push and pull request.

## Proof provenance

Egor Lyfar specified the mathematical scope, source anchor, publication
constraints, and honesty requirements. OpenAI Codex developed the Lean
formalization under Egor's direction. Every accepted proof term is checked by
the pinned Lean kernel; AI provenance is not a substitute for checking.

## Lean Pool

The density-one GKP theorem, exact all-depth sieve, and carry-language
characterization are submitted together in
[Vilin97/lean-pool PR 273](https://github.com/Vilin97/lean-pool/pull/273).
The odd-prime valuation-distribution theory is submitted separately as
[Vilin97/lean-pool PR 276](https://github.com/Vilin97/lean-pool/pull/276),
with no personal material in upstream project files.
The upstream project card is mathematical and maintainer-facing; the personal
mission statement remains confined to this companion repository.

## License

Apache License 2.0. See [LICENSE](LICENSE).
