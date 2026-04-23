#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot

#let LPexample = canvas({
  import draw: *

  // Set-up a thin axis style
  set-style(
    axes: (stroke: .5pt, tick: (stroke: .5pt)),
    legend: (stroke: none, orientation: ttb, item: (spacing: .3), scale: 80%),
  )

  // Set up a clean axis style
  set-style(
    axes: (stroke: .5pt, tick: (stroke: .5pt)),
    legend: (stroke: none, fill: white, padding: .2),
  )

  plot.plot(
    size: (8, 8),
    axis-style: "school-book", // Draws arrow axes crossing at (0,0)
    x-min: 0,
    x-max: 3,
    y-min: 0,
    y-max: 3,
    x-tick-step: 1,
    y-tick-step: 1,
    // Add custom ticks for the optimal intersection point
    x-ticks: ((2 / 3, [$2/3$]),),
    y-ticks: ((2 / 3, [$2/3$]),),
    legend: "inner-north-east",
    {
      let domain = (0, 3)

      // 1. Define the constraint boundaries
      let f1(x) = 1 - x / 2.0
      let f2(x) = 2 - 2.0 * x

      // 2. Define the bottom of the feasible region (the maximum of the two constraints)
      let feasible-bottom(x) = calc.max(f1(x), f2(x))
      let feasible-top(x) = 3 // Top boundary for the shading

      // 3. Fill the feasible region
      plot.add-fill-between(
        feasible-bottom,
        feasible-top,
        domain: domain,
        style: (fill: rgb(0, 0, 255, 30), stroke: none), // [cite: 156, 369]
        label: "Feasible Region",
      )

      // 4. Draw the constraint lines
      plot.add(f1, domain: domain, style: (stroke: black), label: $x + 2y >= 2$)
      plot.add(f2, domain: domain, style: (stroke: black), label: $2x + y >= 2$)

      // 5. Draw the objective function level set at the optimal value (4/3)
      let obj(x) = 4 / 3 - x
      plot.add(
        obj,
        domain: (0, 4 / 3),
        style: (stroke: (paint: red, dash: "dashed")), // [cite: 149, 153]
        label: $z = 4/3$,
      )

      // 6. Mark the optimal point as a scatter plot point [cite: 213, 281]
      plot.add(
        ((2 / 3, 2 / 3),),
        mark: "o",
        style: (stroke: none, fill: black),
      )

      // 7. Add a text label next to the optimal point [cite: 27, 551]
      plot.annotate({
        content((2 / 3 + 0.1, 2 / 3 + 0.1), [$(2/3, 2/3)$], anchor: "south-west")
      })
    },
  )
})





#let RazbTriangle = canvas({
  import draw: *

  // Set up a clean axis and legend style
  set-style(
    axes: (stroke: .5pt, tick: (stroke: .5pt)),
    legend: (stroke: .5pt, fill: white, padding: .2),
  )

  plot.plot(
    size: (10, 6),
    axis-style: "scientific-auto",
    x-min: 0,
    x-max: 1.05,
    y-min: 0,
    y-max: 1.05,
    x-label: [Edge density $epsilon$],
    y-label: [Triangle density $tau$],
    // Add custom fractions matching the scallop intersections
    x-tick-step: none,
    x-ticks: (0, (1 / 2, $1/2$), (2 / 3, $2/3$), (3 / 4, $3/4$), (4 / 5, $4/5$), 1),
    y-tick-step: 0.2,
    legend: "inner-north-west",
    {
      let domain = (0, 1)

      // 1. Define Upper Bound & Erdos-Renyi
      let upper-bound(x) = calc.pow(x, 1.5)
      let er-curve(x) = calc.pow(x, 3)

      // 2. Define the piecewise Lower Bound (Razborov's Scallops)
      let lower-bound(x) = {
        if x <= 0.5 { return 0.0 }
        if x >= 0.999 { return 1.0 }

        // Determine k based on the interval x falls into
        let k = float(calc.floor(1.0 / (1.0 - x)))

        let inner = 1.0 - x * (k + 1.0) / k
        if inner < 0.0 { inner = 0.0 } // Protect against float precision issues

        let sq = calc.sqrt(inner)
        return (k * (k - 1.0)) / calc.pow(k + 1.0, 2) * calc.pow(1.0 + sq, 2) * (1.0 - 2.0 * sq)
      }

      // 3. Shade the interior (Razborov Triangle)
      plot.add-fill-between(
        lower-bound,
        upper-bound,
        domain: domain,
        samples: 500, // High sample rate for smooth scallops
        style: (fill: rgb(100, 150, 255, 50), stroke: none),
      )

      // 4. Add vertical guide lines for the scallop boundaries
      plot.add-vline(
        1 / 2,
        2 / 3,
        3 / 4,
        4 / 5,
        style: (stroke: (paint: gray.lighten(50%), thickness: 0.5pt)),
      )

      // 5. Draw the bound lines
      plot.add(
        upper-bound,
        domain: domain,
        samples: 200,
        style: (stroke: (paint: blue, thickness: 1.5pt)),
        label: [Upper bound $t = e^{3/2}$],
      )
      plot.add(
        er-curve,
        domain: domain,
        samples: 200,
        style: (stroke: (paint: purple, dash: "dash-dotted", thickness: 1.2pt)),
        label: [Erdos-Renyi $t = e^3$],
      )
      plot.add(
        lower-bound,
        domain: domain,
        samples: 500,
        style: (stroke: (paint: red, thickness: 1.5pt)),
        label: [Lower bound with scallops],
      )
    },
  )
})


// Defines the W-random Graph Sampling Process canvas as a reusable variable
#let w-random-graph-canvas = canvas({
  import draw: *

  // ==========================================
  // LEFT SIDE: The Graphon Space [0, 1]^2
  // ==========================================
  group(name: "graphon", {
    // The Graphon "Surface" (represented by a gradient box)
    rect(
      (0, 0),
      (4, 4),
      fill: gradient.linear(blue.lighten(70%), red.lighten(30%), angle: 45deg),
      stroke: none,
    )

    // Axes setup
    line((0, 0), (4.5, 0), mark: (end: ">")) // X axis
    line((0, 0), (0, 4.5), mark: (end: ">")) // Y axis
    content((4.5, -0.4), $x$)
    content((-0.4, 4.5), $y$)

    // Axis Bounds
    content((0, -0.4), $0$)
    content((4, -0.4), $1$)
    content((-0.4, 4), $1$)

    // Sample points U_1 and U_2 on the axes
    let u1 = 1.5
    let u2 = 3.0
    let u3 = 2.2

    // Mark U_1 and U_2 on X axis
    line((u1, 0.1), (u1, -0.1))
    content((u1, -0.5), $U_1$)
    line((u2, 0.1), (u2, -0.1))
    content((u2, -0.5), $U_2$)

    // Mark U_1 and U_2 on Y axis
    line((0.1, u1), (-0.1, u1))
    content((-0.5, u1), $U_1$)
    line((0.1, u2), (-0.1, u2))
    content((-0.5, u2), $U_2$)

    // Intersection lines pointing to W(U_1, U_2)
    line((u1, 0), (u1, u2), stroke: (dash: "dashed", paint: luma(100)))
    line((0, u2), (u1, u2), stroke: (dash: "dashed", paint: luma(100)))

    // The intersection point
    circle((u1, u2), radius: 0.08, fill: black)
    content((u1 + 1.2, u2 + 0.3), $W(U_1, U_2)$)
  })

  // ==========================================
  // MIDDLE: The Stochastic Mapping Arrow
  // ==========================================
  line((5, 2), (7, 2), mark: (end: ">"), stroke: (thickness: 1.5pt))
  content((6, 2.6), [Sample edge])
  content((6, 1.4), [with prob $W$])

  // ==========================================
  // RIGHT SIDE: The Sampled Graph G(n, W)
  // ==========================================
  group(name: "graph", {
    // Vertex coordinates
    let v1 = (8.5, 3)
    let v2 = (11, 2.5)
    let v3 = (9.5, 0.5)

    // Realized Edge (1 to 2)
    line(v1, v2, stroke: (thickness: 1.5pt, paint: blue.darken(20%)))

    // Potential/Unrealized Edges (dashed)
    line(v1, v3, stroke: (dash: "dotted", paint: gray))
    line(v2, v3, stroke: (dash: "dotted", paint: gray))

    // Draw Vertices
    circle(v1, radius: 0.25, fill: white, stroke: black)
    content(v1, $1$)

    circle(v2, radius: 0.25, fill: white, stroke: black)
    content(v2, $2$)

    circle(v3, radius: 0.25, fill: white, stroke: black)
    content(v3, $3$)
  })
})


// Defines the Graphon Blowup (Checkerboard) canvas as a reusable variable
#let graphon-blowup-canvas = canvas({
  import draw: *

  // ==========================================
  // LEFT SIDE: The Discrete Graph G (P_3)
  // ==========================================
  group(name: "discrete", {
    let v1 = (0, 3)
    let v2 = (1.5, 1.5)
    let v3 = (0, 0)

    // Edges
    line(v1, v2, stroke: 1.5pt)
    line(v2, v3, stroke: 1.5pt)

    // Vertices
    circle(v1, radius: 0.3, fill: white, stroke: black)
    content(v1, [1])
    circle(v2, radius: 0.3, fill: white, stroke: black)
    content(v2, [2])
    circle(v3, radius: 0.3, fill: white, stroke: black)
    content(v3, [3])

    content((0.75, -0.8), [Graph $G$ ($P_3$)])
  })

  // Transformation Arrow
  line((2.5, 1.5), (4.5, 1.5), mark: (end: ">"), stroke: 1.5pt)
  content((3.5, 2), [Blowup])

  // ==========================================
  // RIGHT SIDE: The Checkerboard Graphon W_G
  // ==========================================
  group(name: "checkerboard", {
    let origin = (6, 0)
    let size = 4
    let n = 3
    let step = size / n

    // Draw the unit square grid
    rect(origin, (6 + size, size), stroke: 0.5pt)

    // Fill edges (1,2) and (2,3) and their symmetries
    // Indices: 0 -> I_1, 1 -> I_2, 2 -> I_3
    // Note: y-axis in CeTZ grows upward

    let fill-cell(i, j) = {
      rect((6 + i * step, j * step), (6 + (i + 1) * step, (j + 1) * step), fill: blue.lighten(60%), stroke: 0.5pt)
    }

    fill-cell(0, 1) // (I_1, I_2)
    fill-cell(1, 0) // (I_2, I_1)
    fill-cell(1, 2) // (I_2, I_3)
    fill-cell(2, 1) // (I_3, I_2)

    // Grid lines for clarity
    line((6 + step, 0), (6 + step, size), stroke: (dash: "dotted", paint: gray))
    line((6 + 2 * step, 0), (6 + 2 * step, size), stroke: (dash: "dotted", paint: gray))
    line((6, step), (6 + size, step), stroke: (dash: "dotted", paint: gray))
    line((6, 2 * step), (6 + size, 2 * step), stroke: (dash: "dotted", paint: gray))

    // Labels
    content((6 + step / 2, -0.4), $I_1$)
    content((6 + 1.5 * step, -0.4), $I_2$)
    content((6 + 2.5 * step, -0.4), $I_3$)

    content((5.6, step / 2), $I_1$)
    content((5.6, 1.5 * step), $I_2$)
    content((5.6, 2.5 * step), $I_3$)

    content((6 + size / 2, -1), [$G$ graphon blowup $W_G$])
  })
})


// Defines the Graph Homomorphism mapping canvas
#let graph-homomorphism-canvas = canvas({
  import draw: *

  // ==========================================
  // LEFT SIDE: Source Graph G (An Edge)
  // ==========================================
  group(name: "graph-g", {
    let u = (0, 2)
    let v = (0, 0)

    // Edge
    line(u, v, stroke: 1.5pt, name: "edge-g")

    // Vertices
    circle(u, radius: 0.25, fill: white, stroke: black)
    content(u, $u$)
    circle(v, radius: 0.25, fill: white, stroke: black)
    content(v, $v$)

    content((0, -0.8), [Graph $G$])
  })

  // ==========================================
  // RIGHT SIDE: Target Graph H (A Triangle)
  // ==========================================
  group(name: "graph-h", {
    let a = (5, 2.5)
    let b = (5, -0.5)
    let c = (7, 1)

    // Edges of H
    line(a, b, stroke: 1.5pt, name: "edge-h-target")
    line(b, c, stroke: 1pt, paint: gray)
    line(a, c, stroke: 1pt, paint: gray)

    // Vertices
    circle(a, radius: 0.25, fill: white, stroke: black)
    content(a, $f(u)$)
    circle(b, radius: 0.25, fill: white, stroke: black)
    content(b, $f(v)$)
    circle(c, radius: 0.25, fill: white, stroke: black)
    content(c, [?])

    content((6, -1.3), [Graph $H$])
  })

  // ==========================================
  // MAPPING ARROWS (f: G -> H)
  // ==========================================
  // Curved mapping arrows
  line((0.3, 2), (4.6, 2.5), mark: (end: ">"), stroke: (paint: blue, dash: "dashed"), bend: 15deg)
  line((0.3, 0), (4.6, -0.5), mark: (end: ">"), stroke: (paint: blue, dash: "dashed"), bend: -15deg)

  content((2.5, 1.8), $f$, fill: white)
})


// Defines the Minimum Triangle Density Block Structure
#let min-triangle-block-canvas = canvas({
  import draw: *

  let size = 5
  let c = 1.6 // Represents the width of the regular podes
  let ik_w = size - (2 * c) // The "Special" last pode I_k

  group(name: "graphon-rect", {
    // ── Grid Lines and Intervals ──
    // Vertical lines
    line((c, 0), (c, size), stroke: (dash: "dotted", paint: gray))
    line((2 * c, 0), (2 * c, size), stroke: (dash: "dotted", paint: gray))

    // Horizontal lines
    line((0, c), (size, c), stroke: (dash: "dotted", paint: gray))
    line((0, 2 * c), (size, 2 * c), stroke: (dash: "dotted", paint: gray))

    // ── Filling the Blocks ──
    // Off-diagonal blocks (W = 1)
    let fill-one(x, y, w, h) = {
      rect((x, y), (x + w, y + h), fill: blue.darken(30%), stroke: 0.5pt)
      content((x + w / 2, y + h / 2), [1], fill: white)
    }

    // Diagonal blocks for i < k (W = 0)
    let fill-zero(x, y, w, h) = {
      rect((x, y), (x + w, y + h), fill: white, stroke: 0.5pt)
      content((x + w / 2, y + h / 2), [0])
    }

    // I_1 x I_2, I_1 x I_3, I_2 x I_3 (and transposes)
    fill-one(0, c, c, c) // (1,2)
    fill-one(c, 0, c, c) // (2,1)
    fill-one(0, 2 * c, c, ik_w) // (1,3)
    fill-one(2 * c, 0, ik_w, c) // (3,1)
    fill-one(c, 2 * c, c, ik_w) // (2,3)
    fill-one(2 * c, c, ik_w, c) // (3,2)

    // Diagonals
    fill-zero(0, 0, c, c) // I_1 x I_1
    fill-zero(c, c, c, c) // I_2 x I_2

    // ── The Special Corner I_k x I_k ──
    rect((2 * c, 2 * c), (size, size), fill: gradient.radial(gray.lighten(80%), gray.lighten(50%)), stroke: 0.5pt)
    content((2 * c + ik_w / 2, 2 * c + ik_w / 2), [$W_(T F)$ ], size: 8pt)

    // Outer border
    rect((0, 0), (size, size), stroke: 1pt)

    // Labels
    content((c / 2, -0.4), $I_1$)
    content((1.5 * c, -0.4), $I_2$)
    content((2 * c + ik_w / 2, -0.4), $I_k$)

    content((-0.4, c / 2), $I_1$)
    content((-0.4, 1.5 * c), $I_2$)
    content((-0.4, 2 * c + ik_w / 2), $I_k$)
  })
})
