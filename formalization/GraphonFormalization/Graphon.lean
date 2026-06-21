import Mathlib.MeasureTheory.Measure.Lebesgue.Basic
import Mathlib.MeasureTheory.Measure.AEMeasurable
import Mathlib.MeasureTheory.Measure.MeasureSpace
import Mathlib.MeasureTheory.Group.Arithmetic

/-!
# Graphons

A graphon is a symmetric measurable function W : [0,1]² → [0,1].

We work with pre-quotient representatives (not the a.e.-equivalence quotient).
The cut metric / quotient space is left for future work.
-/

namespace GraphonFormalization

open MeasureTheory

/-! ## Graphon -/

/-- A graphon: a symmetric, measurable, [0,1]-valued function on [0,1]². -/
structure Graphon where
  /-- The underlying function. -/
  toFun : ℝ → ℝ → ℝ
  /-- The uncurried function is measurable. -/
  mble : Measurable (fun p : ℝ × ℝ => toFun p.1 p.2)
  /-- Symmetry: W(x,y) = W(y,x). -/
  symm : ∀ x y, toFun x y = toFun y x
  /-- Non-negativity: W(x,y) ≥ 0. -/
  nonneg : ∀ x y, 0 ≤ toFun x y
  /-- Upper bound: W(x,y) ≤ 1. -/
  le_one : ∀ x y, toFun x y ≤ 1

namespace Graphon

/-- The constant-zero graphon (empty graph). -/
noncomputable def zero : Graphon where
  toFun _ _ := 0
  mble := measurable_const
  symm _ _ := rfl
  nonneg _ _ := le_refl 0
  le_one _ _ := zero_le_one

/-- The constant-one graphon (complete graph). -/
noncomputable def one : Graphon where
  toFun _ _ := 1
  mble := measurable_const
  symm _ _ := rfl
  nonneg _ _ := zero_le_one
  le_one _ _ := le_refl 1

end Graphon

/-! ## Multipodal Graphons -/

/-- An N-podal graphon: a step function with N measurable parts partitioning [0,1]
    and a symmetric weight matrix in [0,1]. -/
structure MultipodalGraphon (N : ℕ) where
  /-- The N measurable parts ("podes") of [0,1]. -/
  parts : Fin N → Set ℝ
  /-- Parts are measurable. -/
  parts_mble : ∀ i, MeasurableSet (parts i)
  /-- Parts are pairwise disjoint. -/
  parts_disj : ∀ i j, i ≠ j → Disjoint (parts i) (parts j)
  /-- Parts cover [0,1]. -/
  parts_cover : ⋃ i, parts i = Set.Icc 0 1
  /-- Edge weights between podes. -/
  weights : Fin N → Fin N → ℝ
  /-- Weights are symmetric. -/
  weights_symm : ∀ i j, weights i j = weights j i
  /-- Weights are non-negative. -/
  weights_nonneg : ∀ i j, 0 ≤ weights i j
  /-- Weights are at most 1. -/
  weights_le_one : ∀ i j, weights i j ≤ 1

namespace MultipodalGraphon

variable {N : ℕ} (M : MultipodalGraphon N)

private noncomputable def stepFun (x y : ℝ) : ℝ :=
  ∑ i : Fin N, ∑ j : Fin N,
    M.weights i j * Set.indicator (M.parts i) 1 x * Set.indicator (M.parts j) 1 y

/-- Convert a multipodal graphon to a Graphon. -/
noncomputable def toGraphon (M : MultipodalGraphon N) : Graphon where
  toFun := M.stepFun
  mble := by
    unfold stepFun
    apply Finset.measurable_sum Finset.univ
    intro i _
    apply Finset.measurable_sum Finset.univ
    intro j _
    apply Measurable.mul
    · apply Measurable.mul
      · exact measurable_const
      · exact (measurable_const.indicator (M.parts_mble i)).comp measurable_fst
    · exact (measurable_const.indicator (M.parts_mble j)).comp measurable_snd
  symm x y := by
    unfold stepFun
    conv_rhs => rw [Finset.sum_comm]
    congr 1; ext j
    congr 1; ext i
    rw [M.weights_symm]
    ring
  nonneg x y := by
    unfold stepFun
    apply Finset.sum_nonneg; intro i _
    apply Finset.sum_nonneg; intro j _
    apply mul_nonneg
    · apply mul_nonneg (M.weights_nonneg i j)
      exact Set.indicator_nonneg (fun _ _ => zero_le_one) x
    · exact Set.indicator_nonneg (fun _ _ => zero_le_one) y
  le_one x y := by
    sorry

end MultipodalGraphon

/-! ## Uniform Multipodal Graphons -/

/-- The uniform N-podal graphon with equal-sized podes [i/N, (i+1)/N). -/
noncomputable def uniformMultipodal (N : ℕ) (hN : 0 < N)
    (weights : Fin N → Fin N → ℝ)
    (weights_symm : ∀ i j, weights i j = weights j i)
    (weights_nonneg : ∀ i j, 0 ≤ weights i j)
    (weights_le_one : ∀ i j, weights i j ≤ 1) :
    MultipodalGraphon N where
  parts i := if (i : ℕ) + 1 < N
    then Set.Ico ((i : ℝ) / N) (((i : ℝ) + 1) / N)
    else Set.Icc ((i : ℝ) / N) (((i : ℝ) + 1) / N)
  parts_mble i := by
    split_ifs <;> [exact measurableSet_Ico; exact measurableSet_Icc]
  parts_disj := by intro i j hij; sorry
  parts_cover := by sorry
  weights := weights
  weights_symm := weights_symm
  weights_nonneg := weights_nonneg
  weights_le_one := weights_le_one

end GraphonFormalization
