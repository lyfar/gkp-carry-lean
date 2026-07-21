Egor is building an independent AI research lab because his son Misha has rare genetic hearing loss. Every checked result tests and advances the research workflow. One rare disease is rare. Rare diseases together are not.

# Exact odd-prime distributions for central-binomial valuations

This repository formalizes the exact distribution of

```text
ν_p ((2n choose n))
```

over every complete residue block `0 ≤ n < p ^ k`, for every odd prime `p`.
It also contains the related carry-language characterization of the
Graham--Knuth--Patashnik (GKP) conjecture and an earlier bounded certificate.

The distribution theorem is complete and kernel-checked. The GKP conjecture
is not solved.

## Headline result

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

This ternary corollary is the exact finite counting result relevant to the GKP
carry language. It does not imply that powers of two avoid that language.

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
7. closed counts for valuations zero and one.

All source files are below 700 lines.

## Source anchor

The headline theorem formalizes Theorem 1 of S. M. Nazmuz Sakib,
[“Carry–Run Theorem and Sakib Index for the Exact Distribution of
`ν_p((2n choose n))` over `n mod p^k`”](https://doi.org/10.33774/coe-2026-1w9zm),
Cambridge Open Engage, version 1, 23 January 2026.

That source is a working paper and is explicitly marked as not peer-reviewed
by Cambridge University Press. The theorem is not claimed here as a new
mathematical discovery. This repository supplies a machine-checked
formalization of its exact carry distribution and rational generating
function. Kummer's carry interpretation is classical.

The original GKP context is Ronald L. Graham, Donald E. Knuth, and Oren
Patashnik, *Concrete Mathematics*, second edition; see the
[authors' official book page](https://cs.stanford.edu/~knuth/gkp.html).
The related ternary-power question is catalogued as
[Erdős Problem 406](https://www.erdosproblems.com/406).

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
all residues in finite complete blocks; it does not establish avoidance by the
sparse sequence `2^k`.

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

The existing maintainer-facing GKP characterization is
[Vilin97/lean-pool PR 273](https://github.com/Vilin97/lean-pool/pull/273).
The odd-prime valuation-distribution theory is intended for a separate,
mathematical Lean Pool project and PR, with no personal material in upstream
project files.

## License

Apache License 2.0. See [LICENSE](LICENSE).
