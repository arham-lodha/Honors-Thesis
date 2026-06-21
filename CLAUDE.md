# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Typst-based mathematics honors thesis titled *"Asymptotic Bounds on Homomorphism Densities in Triangle-Constrained Graphons"* by Arham Rajendra Lodha (UT Austin, Department of Mathematics, May 2026). The main result proves that `T_G(ε, τ) = Θ(τ^α(G))` where `α(G)` is a novel graph parameter defined via a linear program.

## Build Commands

```bash
# Compile thesis to PDF
typst compile thesis.typ

# Watch for changes and recompile automatically
typst watch thesis.typ

# Compile to a specific output path
typst compile thesis.typ thesis.pdf
```

## File Structure

| File | Purpose |
|------|---------|
| `thesis.typ` | Main document — all mathematical content and structure |
| `template.typ` | Page layout, theorem environments, front matter (title page, abstract, ToC) |
| `figures.typ` | CeTZ/CeTZ-plot canvas figures (LP feasible region, Razborov triangle, graphon diagrams) |
| `refs.bib` | BibTeX bibliography |

## Architecture

**`template.typ`** defines the `thesis(...)` function that wraps the entire document. It uses the `lemmify` package (`@preview/lemmify:0.1.8`) for numbered theorem environments split into two groups:
- Group A (italicized body): `theorem`, `lemma`, `corollary`, `proposition`
- Group B (upright body): `definition`, `remark`, `example`, `proof`
- Custom environments: `claim`, `fact`, `observation`

All environments are imported into `thesis.typ` via `#import "template.typ": *`.

**`figures.typ`** uses `@preview/cetz:0.4.2` and `@preview/cetz-plot:0.1.3` for all diagrams. Figures are defined as named `let` bindings (e.g., `#let LPexample = canvas({...})`) and referenced by name in `thesis.typ`.

**`thesis.typ`** defines document-level math shorthand at the top:
```typst
#let cut = $square.stroked$
#let TG = $T^(G)_max$
#let TM = $T^(G)_(min )$
#let TD = $T^(D)_(min )$
```

Theorem numbering resets at each top-level section (`max-reset-level: 1`) and follows heading numbering (`thm-numbering-heading` with `max-heading-level: 1`).

## Typst Conventions Used

- Cross-references use `<LabelName>` on headings and `@LabelName` to cite them
- Citations use `@bibtex-key` syntax
- Named theorems use `#theorem(name: [@ref])[...]` to reference the label of the theorem
- Page margins: top/bottom 1.25in, left 1.25in, right 1in (US letter)
- Font: New Computer Modern, 11pt
