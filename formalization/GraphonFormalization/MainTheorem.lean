import GraphonFormalization.HomDensity
import GraphonFormalization.Alpha
import GraphonFormalization.UpperBound
import GraphonFormalization.LowerBound
import Mathlib.Analysis.Asymptotics.Theta

/-!
# Main Theorem: T_G(ε, τ) = Θ(τ^α(G))

The main result of the thesis: for any graph G with at least one triangle and
fixed ε ∈ (0, 1/2], the maximum homomorphism density over graphons with edge
density ε and triangle density ≤ τ satisfies

    T_G(ε, τ) = Θ(τ^α(G))   as τ → 0⁺.

This assembles the upper bound (UpperBound.lean) and lower bound (LowerBound.lean).
-/

namespace GraphonFormalization

open MeasureTheory Asymptotics

/-! ## The Extremal Problem T_max -/

/-- T_max^G(ε, τ): the supremum of t(G, W) over all graphons W with
    edge density ε and triangle density at most τ. -/
noncomputable def TMax {k : ℕ} (G : SimpleGraph (Fin k)) [DecidableRel G.Adj]
    (ε τ : ℝ) : ℝ :=
  sSup { s | ∃ W : Graphon, edgeDensity W = ε ∧ triangleDensity W ≤ τ ∧
      s = homDensity G W }

/-! ## Deferred Compactness Results -/

-- The graphon space with the cut metric is compact.
-- Needed to show the supremum in TMax is actually attained (is a max, not just sup).
-- Requires formalizing the cut metric and Lovász-Szegedy compactness theorem.
theorem graphonSpace_compact : True := trivial

-- Homomorphism density is continuous in the cut metric.
theorem homDensity_continuous_cutMetric {k : ℕ}
    (G : SimpleGraph (Fin k)) [DecidableRel G.Adj] : True := trivial

/-! ## Main Theorem -/

/-- **Main Theorem**: T_G(ε, τ) = Θ(τ^α(G)) as τ → 0⁺.

    For any graph G with at least one triangle and fixed ε ∈ (0, 1/2]:
    there exist constants 0 < c ≤ C (depending only on G and ε) such that

        c · τ^α(G) ≤ T_max^G(ε, τ) ≤ C · τ^α(G)

    for all sufficiently small τ > 0.

    Proof:
    - Upper bound: for any W with e(W) = ε and t(W) ≤ τ,
      t(G,W) ≤ t(W)^α(G) ≤ τ^α(G)  (Finner's inequality + LP duality).
    - Lower bound: the explicit multipodal W_τ satisfies e(W_τ) = ε,
      t(W_τ) ≤ τ, and t(G,W_τ) ≥ C·τ^α(G). -/
theorem main_theorem {k : ℕ} (G : SimpleGraph (Fin k)) [DecidableRel G.Adj]
    (hT : (G.cliqueFinset 3).Nonempty)
    (ε : ℝ) (hε : ε ∈ Set.Ioc 0 (1/2)) :
    (fun τ => TMax G ε τ) =Θ[nhdsWithin 0 (Set.Ioi 0)]
    (fun τ => τ ^ alphaG G) := by
  constructor
  · exact tMax_upperBound_isBigO G hT ε hε
  · exact tMax_lowerBound_isBigO G hT ε hε

/-! ## Example Computations -/

-- K₃: α(K₃) = 1, so T_{K₃}(ε, τ) = Θ(τ)
theorem main_K3 (ε : ℝ) (hε : ε ∈ Set.Ioc 0 (1/2)) :
    (fun τ => TMax (⊤ : SimpleGraph (Fin 3)) ε τ) =Θ[nhdsWithin 0 (Set.Ioi 0)]
    (fun τ => τ ^ (1 : ℝ)) := by
  have hT : ((⊤ : SimpleGraph (Fin 3)).cliqueFinset 3).Nonempty := by sorry
  have h := main_theorem (⊤ : SimpleGraph (Fin 3)) hT ε hε
  have hα : alphaG (⊤ : SimpleGraph (Fin 3)) = 1 := by sorry
  rwa [hα] at h

-- K₄: α(K₄) = 4/3, so T_{K₄}(ε, τ) = Θ(τ^{4/3})
theorem main_K4 (ε : ℝ) (hε : ε ∈ Set.Ioc 0 (1/2)) :
    (fun τ => TMax (⊤ : SimpleGraph (Fin 4)) ε τ) =Θ[nhdsWithin 0 (Set.Ioi 0)]
    (fun τ => τ ^ (4 / 3 : ℝ)) := by
  have hT : ((⊤ : SimpleGraph (Fin 4)).cliqueFinset 3).Nonempty := by sorry
  have h := main_theorem (⊤ : SimpleGraph (Fin 4)) hT ε hε
  have hα : alphaG (⊤ : SimpleGraph (Fin 4)) = 4 / 3 := by sorry
  rwa [hα] at h

end GraphonFormalization
