// ============================================================
//  EXTREMAL COMBINATORICS THESIS — TEMPLATE
// ============================================================

#import "@preview/lemmify:0.1.8": *

// ── 1. THEOREM ENVIRONMENTS ─────────────────────────────────

// Group A: Italicized Body (Theorems, Lemmas, Corollaries, Propositions)
#let (
  theorem,
  lemma,
  corollary,
  proposition,
  rules: thm-rules-a,
) = default-theorems(
  "thm-group-a",
  lang: "en",
  thm-numbering: thm-numbering-heading.with(max-heading-level: 1),
  max-reset-level: 1,
)

// Group B: Upright Body (Definitions, Remarks, Examples, Proofs)
#let (
  definition,
  remark,
  example,
  proof,
  rules: thm-rules-b,
) = default-theorems(
  "thm-group-b",
  lang: "en",
  thm-numbering: thm-numbering-heading.with(max-heading-level: 1),
  max-reset-level: 1,
)

// Custom environments
#let (claim, rules: claim-rules) = new-theorems("claim-group", ("claim": "Claim"))
#let (fact, rules: fact-rules) = new-theorems("fact-group", ("fact": "Fact"))
#let (observation, rules: obs-rules) = new-theorems("obs-group", ("observation": "Observation"))

// Export all environments
#let _all-thm-envs = (
  theorem,
  lemma,
  corollary,
  proposition,
  definition,
  remark,
  example,
  proof,
  claim,
  fact,
  observation,
)

// ── 2. MAIN TEMPLATE FUNCTION ────────────────────────────────

#let thesis(
  title: "Extremal Problems in Combinatorics",
  subtitle: none,
  author: "Author Name",
  advisor: "Prof. Lorenzo Sadun",
  institution: "The University of Texas at Austin",
  department: "Department of Mathematics",
  degree: "Bachelor of Science in Mathematics with Honors",
  date: "May 2026",
  abstract: [],
  acknowledgements: none,
  body,
) = {
  // Document Metadata
  set document(title: title, author: author)

  // Global Page & Text Setup
  set page(paper: "us-letter", margin: (top: 1.25in, bottom: 1.25in, left: 1.25in, right: 1in))
  set text(font: "New Computer Modern", size: 11pt, lang: "en")

  // Paragraph formatting (No indents, just clean block spacing)
  set par(justify: true, leading: 0.65em)
  show par: set block(spacing: 1.2em)

  // Heading Formatting
  set heading(numbering: "1.1.")

  show heading.where(level: 1): it => {
    // REMOVED: pagebreak(weak: true)
    v(2em, weak: true)
    text(size: 16pt, weight: "bold", it)
    v(1.2em, weak: true)
  }

  show heading.where(level: 2): it => {
    v(1.5em, weak: true)
    text(size: 13pt, weight: "bold", it)
    v(0.8em, weak: true)
  }

  show heading.where(level: 3): it => {
    v(1.2em, weak: true)
    text(size: 11pt, weight: "bold", it)
    v(0.6em, weak: true)
  }

  // Equation Formatting
  set math.equation(numbering: "(1)", supplement: "Equation")
  show math.equation.where(block: true): it => {
    set align(center)
    v(0.5em)
    it
    v(0.5em)
  }

  // Activate Theorem Rules
  show: thm-rules-a
  show: thm-rules-b
  show: claim-rules
  show: fact-rules
  show: obs-rules

  // Fix Italics in Definitions and Remarks
  show figure.where(kind: "thm-group-b"): set text(style: "normal")


  // ==========================================
  // FRONT MATTER (Roman Numeral Pages)
  // ==========================================
  set page(numbering: "i")
  counter(page).update(1)

  // ── 1. Title Page ──
  align(center)[
    #v(1fr)
    #text(size: 20pt, weight: "bold")[#title]

    #if subtitle != none {
      v(1.5em)
      text(size: 14pt, style: "italic")[#subtitle]
    }

    #v(2fr)
    #text(size: 12pt)[
      Submitted to the Faculty of the \
      #department \
      #institution \
      in Partial Fulfillment of the Requirements \
      for Graduation with Honors in Mathematics
    ]

    #v(2fr)
    #text(size: 14pt)[By] \
    #v(0.5em)
    #text(size: 14pt, weight: "bold")[#author]

    #v(2fr)
    #text(size: 12pt)[
      Supervising Professor: #advisor
    ]

    #v(1fr)
    #text(size: 12pt)[#date]
  ]

  // ── 2. Abstract ──
  if abstract != [] {
    pagebreak(weak: true)
    align(center)[#heading(level: 1, numbering: none)[Abstract]]
    abstract
  }

  // ── 3. Acknowledgments ──
  if acknowledgements != none {
    pagebreak(weak: true)
    align(center)[#heading(level: 1, numbering: none)[Acknowledgments]]
    acknowledgements
  }

  // ── 4. Table of Contents ──
  pagebreak(weak: true)
  align(center)[#heading(level: 1, numbering: none)[Table of Contents]]
  outline(title: none, indent: auto)


  // ==========================================
  // MAIN BODY (Arabic Numeral Pages)
  // ==========================================

  pagebreak(weak: true) // Ensures the Introduction starts on a fresh page
  set page(numbering: "1")
  counter(page).update(1)

  body
}
