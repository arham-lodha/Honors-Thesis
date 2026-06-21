import Mathlib.Combinatorics.SimpleGraph.Clique

/-!
# Graph Combinatorics Layer

Definitions and lemmas about triangles, triangle-spanning structure, and the
triangle-spanning decomposition of a graph. All measure theory is isolated to
other files; everything here is purely combinatorial over finite types.
-/

namespace GraphonFormalization

variable {V : Type*} [DecidableEq V] [Fintype V]

/-! ## Triangles -/

/-- An ordered triple (a, b, c) of distinct vertices that form a triangle in G. -/
def IsTriangle (G : SimpleGraph V) (a b c : V) : Prop :=
  a ≠ b ∧ b ≠ c ∧ a ≠ c ∧ G.Adj a b ∧ G.Adj b c ∧ G.Adj a c

/-- The set of all triangles of G, represented as 3-element Finsets. -/
noncomputable def triangleSet (G : SimpleGraph V) [DecidableRel G.Adj] :
    Finset (Finset V) :=
  G.cliqueFinset 3

/-- Vertices u and v have a common neighbor in G (i.e., {u, v} lies in a triangle). -/
def edgeInTriangle (G : SimpleGraph V) (u v : V) : Prop :=
  ∃ w : V, w ≠ u ∧ w ≠ v ∧ G.Adj u w ∧ G.Adj v w

/-! ## Triangle-Spanning Graphs -/

/-- G is triangle-spanning if every edge lies in at least one triangle. -/
def IsTriangleSpanning (G : SimpleGraph V) [DecidableRel G.Adj] : Prop :=
  ∀ u v : V, G.Adj u v → edgeInTriangle G u v

/-! ## Triangle-Spanning Decomposition

Each component is represented by its vertex set (`Finset V`). The property
"every G-edge between component vertices lies in a G-triangle" captures the
triangle-spanning condition without needing to work with subgraph coercions. -/

/-- The triangle-spanning decomposition of G. -/
structure TriSpanDecomp (G : SimpleGraph V) [DecidableRel G.Adj] where
  /-- Vertex sets of the triangle-spanning components (pairwise disjoint). -/
  compVerts : Finset (Finset V)
  /-- Bridge edges: edges of G lying in no triangle. -/
  bridges : Finset (Sym2 V)
  /-- Leftover vertices: vertices not in any component. -/
  leftoverVerts : Finset V
  /-- Component vertex sets are pairwise disjoint. -/
  compVerts_disjoint :
    ∀ S ∈ compVerts, ∀ T ∈ compVerts, S ≠ T → Disjoint S T
  /-- Within each component, every G-edge lies in a G-triangle. -/
  compVerts_triangleSpanning :
    ∀ S ∈ compVerts, ∀ u v : V, u ∈ S → v ∈ S → G.Adj u v →
      edgeInTriangle G u v
  /-- Bridges are exactly the edges of G not covered by any component. -/
  bridges_spec :
    ∀ e ∈ G.edgeFinset,
      e ∈ bridges ↔ ¬edgeInTriangle G e.out.1 e.out.2
  /-- Every vertex is in some component or in leftoverVerts. -/
  coverage :
    ∀ v : V, (∃ S ∈ compVerts, v ∈ S) ∨ v ∈ leftoverVerts

theorem triSpanDecomp_exists (G : SimpleGraph V) [DecidableRel G.Adj] :
    ∃ _ : TriSpanDecomp G, True := by
  sorry

end GraphonFormalization
