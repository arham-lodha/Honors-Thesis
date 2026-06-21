import GraphonFormalization.Graphon
import Mathlib.MeasureTheory.Constructions.Pi
import Mathlib.MeasureTheory.Integral.Pi
import Mathlib.Combinatorics.SimpleGraph.Clique
import Mathlib.Data.Real.Basic

/-!
# Homomorphism Densities

The homomorphism density t(G, W) of a finite graph G in a graphon W is defined as
the integral over [0,1]^|V(G)| of the product of W(x_i, x_j) over all edges {i,j}.

Special cases: edge density e(W) = t(K₂, W) and triangle density t(W) = t(K₃, W).
-/

namespace GraphonFormalization

open MeasureTheory

/-! ## The unit interval measure -/

/-- Lebesgue measure restricted to [0,1]. -/
noncomputable def unitMeasure : Measure ℝ :=
  volume.restrict (Set.Icc 0 1)

/-! ## Homomorphism density -/

/-- The homomorphism density t(G, W) = ∫_{[0,1]^k} ∏_{e ∈ E(G)} W(x_{e.1}, x_{e.2}) dx.

    G has vertex type Fin k, so vertex assignments are functions Fin k → ℝ.
    The integral is taken with respect to the k-fold product of unitMeasure.

    Note: `e.out` converts a `Sym2 (Fin k)` edge to a representative pair `(Fin k × Fin k)`. -/
noncomputable def homDensity {k : ℕ} (G : SimpleGraph (Fin k))
    [DecidableRel G.Adj] (W : Graphon) : ℝ :=
  ∫ (x : Fin k → ℝ),
    ∏ e ∈ G.edgeFinset, W.toFun (x e.out.1) (x e.out.2)
  ∂(Measure.pi (fun _ : Fin k => unitMeasure))

/-! ## Basic properties -/

theorem homDensity_nonneg {k : ℕ} (G : SimpleGraph (Fin k))
    [DecidableRel G.Adj] (W : Graphon) :
    0 ≤ homDensity G W := by
  apply integral_nonneg
  intro x
  apply Finset.prod_nonneg
  intro e _
  exact W.nonneg _ _

theorem homDensity_le_one {k : ℕ} (G : SimpleGraph (Fin k))
    [DecidableRel G.Adj] (W : Graphon) :
    homDensity G W ≤ 1 := by
  sorry

/-! ## Special cases -/

/-- Edge density: e(W) = ∫∫ W(x,y) dx dy = t(K₂, W). -/
noncomputable def edgeDensity (W : Graphon) : ℝ :=
  homDensity (⊤ : SimpleGraph (Fin 2)) W

/-- Triangle density: t(W) = ∫∫∫ W(x,y)W(y,z)W(x,z) dx dy dz = t(K₃, W). -/
noncomputable def triangleDensity (W : Graphon) : ℝ :=
  homDensity (⊤ : SimpleGraph (Fin 3)) W

/-! ## Reduction formula for multipodal graphons -/

/-- For an N-podal graphon M with parts Sᵢ (measure μᵢ) and weights wᵢⱼ:
    t(G, M) = Σ_{φ : V(G) → [N]} (Π_v μ(S_{φ(v)})) · (Π_{e∈E} w_{φ(e.1), φ(e.2)}).
    This follows from Fubini and linearity of integration. -/
theorem homDensity_multipodal {k N : ℕ} (G : SimpleGraph (Fin k))
    [DecidableRel G.Adj] (M : MultipodalGraphon N) :
    homDensity G M.toGraphon =
      ∑ φ : Fin k → Fin N,
        (∏ v : Fin k, (volume.restrict (Set.Icc 0 1) (M.parts (φ v))).toReal) *
        (∏ e ∈ G.edgeFinset, M.weights (φ e.out.1) (φ e.out.2)) := by
  sorry

end GraphonFormalization
