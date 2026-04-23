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
