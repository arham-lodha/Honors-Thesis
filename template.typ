// ============================================================
//  EXTREMAL COMBINATORICS THESIS — TEMPLATE
//  Import this file from your thesis.typ via:
//    #import "template.typ": *
//    #show: thesis.with( …your metadata… )
// ============================================================

#import "@preview/lemmify:0.1.8": *

// ── 1. THEOREM ENVIRONMENTS ─────────────────────────────────

// Counters reset at every level-1 heading (chapter), numbered as "1.2"
#let (
  theorem,
  lemma,
  corollary,
  proposition,
  remark,
  proof,
  example,
  rules: thm-rules-a,
) = default-theorems(
  "thm-group-a",
  lang: "en",
  thm-numbering: thm-numbering-heading.with(
    max-heading-level: 1,
  ),
  max-reset-level: 1, // <--- THE FIX: Stops counter reset at subsections
)

#let (
  definition,
  rules: thm-rules-b,
) = default-theorems(
  "thm-group-b",
  lang: "en",
  thm-numbering: thm-numbering-heading.with(max-heading-level: 1),
  max-reset-level: 1, // <--- THE FIX: Stops counter reset at subsections
)



// Custom environments — independently numbered
#let (claim, rules: claim-rules) = new-theorems("claim-group", ("claim": "Claim"))
#let (fact, rules: fact-rules) = new-theorems("fact-group", ("fact": "Fact"))
#let (observation, rules: obs-rules) = new-theorems("obs-group", ("observation": "Observation"))

// Export every environment so `#import "template.typ": *` brings them in
#let _all-thm-envs = (
  theorem,
  lemma,
  corollary,
  proposition,
  definition,
  example,
  remark,
  proof,
  claim,
  fact,
  observation,
)





// ── 3. MAIN TEMPLATE FUNCTION ────────────────────────────────
//
//  Usage in thesis.typ:
//
//    #show: thesis.with(
//      title:    "My Thesis Title",
//      subtitle: "An Optional Subtitle",   // omit to hide
//      author:   "Your Name",
//      advisor:  "Prof. Advisor",
//      institution: "University Name",
//      department:  "Department of Mathematics",
//      degree:   "Doctor of Philosophy",
//      date:     "May 2025",
//      abstract: [Your abstract text here.],
//      acknowledgements: [Your acknowledgements here.],  // omit to hide
//    )
#let thesis(
  title: "Thesis Title",
  subtitle: none,
  author: "Author Name",
  advisor: "Advisor Name",
  institution: "University Name",
  department: "Department of Mathematics",
  degree: "Bachelor of Science with Honors",
  date: "2025",
  abstract: [],
  body,
) = {
  set document(title: title, author: author)

  set page(
    paper: "us-letter",
    margin: (top: 1.25in, bottom: 1.25in, left: 1.25in, right: 1in),
    numbering: "1",
  )

  set text(font: "New Computer Modern", size: 11pt, lang: "en")
  set par(justify: true, leading: 0.65em, first-line-indent: 1.2em)

  set heading(numbering: "1.1.")
  show heading.where(level: 1): it => {
    v(1.8em, weak: true)
    text(size: 14pt, weight: "bold", it)
    v(0.8em, weak: true)
  }
  show heading.where(level: 2): it => {
    v(1.2em, weak: true)
    text(size: 12pt, weight: "bold", it)
    v(0.6em, weak: true)
  }
  show heading.where(level: 3): it => {
    v(1em, weak: true)
    text(size: 11pt, weight: "bold", style: "italic", it)
    v(0.4em, weak: true)
  }

  set math.equation(numbering: "(1)", supplement: "Equation")
  show math.equation.where(block: true): it => {
    set align(center)
    it
  }

  show: thm-rules-a
  show: thm-rules-b
  show: claim-rules
  show: fact-rules
  show: obs-rules

  // ── Title block (page 1, no page break) ──
  align(center)[
    #v(1cm)
    #text(size: 18pt, weight: "bold")[#title]
    #if subtitle != none {
      v(0.3cm)
      text(size: 13pt, style: "italic")[#subtitle]
    }
    #v(0.25cm)
    #text(size: 12pt)[#author]
    #v(0.2cm)
    // #text(size: 11pt, style: "italic")[#advisor · #institution · #date]
    // #v(0.6cm)
  ]

  // ── Abstract (same page) ──
  pad(left: 1cm, right: 1cm)[
    *Abstract.* #abstract
  ]

  v(0.8cm)

  // ── Body follows immediately ──
  body
}


