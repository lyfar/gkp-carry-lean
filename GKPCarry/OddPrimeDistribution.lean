/-
Copyright (c) 2026 Egor Lyfar. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Egor Lyfar
-/
import GKPCarry.OddPrimeDistribution.LowValuations

/-!
# Exact odd-prime distributions for central-binomial valuations

This is the entry module for the complete formalization.  Its headline results
are `oddPrimeValuationGeneratingSeries_identity`, the exact bivariate rational
generating-function identity for every odd prime, and
`oddPrimeValuationPolynomial_recurrence`, its coefficient-polynomial form.

Source: S. M. Nazmuz Sakib, *Carry–Run Theorem and Sakib Index for the Exact
Distribution of ν_p((2n choose n)) over n mod p^k*, Cambridge Open Engage,
version 1 (2026), doi:10.33774/coe-2026-1w9zm.  The source is a working paper
and was not peer-reviewed by Cambridge University Press.

Authors: Egor Lyfar
Status: verified
Main declarations: `oddPrimeValuationGeneratingSeries_identity`,
`oddPrimeValuationPolynomial_recurrence`
Tags: number-theory, central-binomial-coefficients, p-adic-valuations,
generating-functions
-/
