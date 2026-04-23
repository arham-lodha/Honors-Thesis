
#import "template.typ": *
#import "figures.typ": *


#show: thesis.with(
  title: "Extremal Problems in Combinatorics",
  author: "Your Name",
  advisor: "Prof. Advisor Name",
  institution: "University Name",
  department: "Department of Mathematics",
  degree: "Doctor of Philosophy",
  date: "May 2025",

  abstract: [
    #lorem(120)
  ],
)



#let cut = $square.stroked$
#let TG = $T^(G)_max$
#let TM = $T^(G)_(min )$
#let TD = $T^(D)_(min )$


#outline()

= Introduction
Extremal combinatorics fundamentally asks the question about how local constraints affect global behavior. Historically, such questions were asked about graphs, which intuitively are collections of points and lines between them. Work in this area has led to fundamental theorems like Mantel's Theorem, Turán's Theorem, and the Kruskal-Katona Theorem. However, the development of the theory of dense graph limits, specifically the introduction of graphons by Lovász and Szegedy, provided a powerful continuous framework for these discrete problems. Graphons act as limit objects for sequences of dense graphs, allowing us to study subgraph densities using the tools of real analysis, topology, and measure theory.

Philosophically, graphons represent the completion of the space of dense finite graphs, much as the real numbers complete the rationals. In the discrete realm, graphs are notoriously rigid. For example, how do you compare two graphs of different sizes? Does the question asking how similar two finite graphs of different sizes are even make sense? Graphons wash away this discrete noise, capturing the pure "structural essence" of a network. By mapping graphs to symmetric measurable functions, the fundamentally combinatorial act of counting subgraphs is transformed into the analytic act of integration.

This paradigm shift has revolutionized multiple areas of discrete mathematics. Graphons have provided the natural language to unify theories of quasi-randomness, formulate continuous analogues of the Szemerédi Regularity Lemma, and develop robust property testing algorithms for massive networks. Beyond pure mathematics, they serve as foundational models in network science and machine learning, offering a way to study the large-scale behavior of the internet, social networks, and biological systems where individual nodes are ephemeral, but the underlying continuous probability distributions governing their connections remain stable.

A central object of study is the Razborov Triangle $cal(R)$, which characterizes the exact region of simultaneously achievable edge and triangle densities for any graphon. While the exact boundary of $cal(R)$ is known, the behavior of other subgraph densities within this region remains a rich area of inquiry. This thesis focuses on a specific, largely unexplored extremal question: if we fix an edge density $epsilon$ and force the triangle density $tau$ to be infinitesimally small, how much of an arbitrary simple graph $G$ can survive? To make this precise, let $TG(epsilon, tau)$ denote the maximum possible homomorphism density of $G$ over all graphons with edge density $epsilon$  and triangle density at most $tau$.

To build intuition, one can view this problem through the physical lens of statistical mechanics and complex systems. If we consider vertices as individual entities or particles, the edge density ϵ measures the global frequency of simple 2-particle interactions. The triangle density $tau$, meanwhile, measures the fundamental 3-particle interactions. From this perspective, understanding $TG(epsilon, tau)$ as $tau -> 0$ is fundamentally a question about the hierarchical breakdown of complexity: if we fix the global rate of 2-particle interactions but actively suppress the 3-particle interactions, how quickly are more complex, higher-order multi-particle interactions (represented by the arbitrary graph $G$) forced to die out? The graph parameter $alpha(G)$ developed in this thesis quantifies exactly this rate of decay.

The main result of this thesis is that this decay is governed by a clean, power-law scaling, and that the exponent of this scaling is inherently tied to the structural relationship between the graph $G$ and its triangles. capture this, we introduce a novel graph parameter, denoted $alpha(G)$. This parameter is exactly calculated via a linear program whose variables correspond to the vertices and edges of $G$, and whose constraints are dictated by the triangles within $G$.

#theorem(name: [@MainTheorem])[
  For any graph $G$ containing at least 1 triangle where no edge connects a vertex to itself, and for any fixed edge density $epsilon in (0, (1)/(2)]$, the maximum homomorphism density of $G$ scales asymptotically as $ TG(epsilon, tau) = Theta(tau^(alpha(G))) $  as the triangle density $tau -> 0$.
]

To establish this result, we utilize a dual approach. The upper bound, $TG(epsilon, tau) = O(tau^(alpha(G)))$, is proven by decomposing arbitrary graphs into a collection of simpler graphs. We then apply Finner's Generalized Hölder inequality in conjunction with Strong Duality in Linear Programming. to tightly bound the homomorphism density. To prove the bound is sharp, yielding the matching lower bound, $TG(epsilon, tau) = Omega(tau^(alpha(G)))$, we explicitly construct a family of graphons. This construction is parametrically guided by the optimal solutions to the linear program, anchoring our graphons tightly to the $tau$ boundary.

The remainder of this thesis is organized as follows. @Prelims collects the necessary preliminaries, defining graphons, cut metrics, homomorphism densities, and the relevant tools from linear programming and measure theory. @TheProblem formally defines the extremal problem. @TriangleSpanningDecomp introduces the Triangle Spanning Decomposition, a structural tool necessary for our upper bounds. @alphaG formally defines the linear program that yields the graph parameter $alpha(G)$ and explores its dual properties. @TriangleSpanningGeneral proves the upper bound for triangle-spanning graphs, which is then generalized to all simple graphs in @GeneralSquared, alongside the matching lower-bound constructions to prove our main theorem. In @Examples, we exhibit example graphs, their associated values of $alpha(G)$, and graphon constructions which produce the desired behavior.   Finally, we conclude in @NextSteps by discussing the implications of these bounds, open questions regarding the implicit constants, and connections to the Szemerédi-Ruzsa Triangle Removal Lemma.

== Acknowledgments
First and foremost, I want to like to express my deepest gratitude to my advisor, Professor Lorenzo Sadun, for their unwavering support, invaluable guidance, and immense patience throughout the process of learning about and writing about graphons. Without Professor Lorenzo Sadun's encouragement to find a problem which interested me, even if it was a bit out of his area of expertise, I would not have found this problem. Furthermore, our weekly meetings where he offered his mathematical insights and advice on the problem, graphons, and problem solving in general served instrumental in the process of proving the main result of the theorem. His constant encouragement (fix this word) were instrumental in keeping motivation, even while I thought I was getting nowhere.

I would like to also thank other members of my thesis committee, Professor William Beckner and Professor Theresa Martines, for the time they dedicated to reviewing this work. Furthermore, I would like to thank all the professors who have provided me guidance throughout my undergraduate career. I specifically want to thank Professors William Beckner, Michael Starbird, Sean Keel, Lorenzo Sadun, Emmanuel Kowalski, Feng Luo, Timothy Perutz, and David Ben-Zvi for helping me fall in love with mathematics and their invaluable guidance through my undergraduate career. I especially want to highlight Professor William Beckner, whom I took my first math class as an undergraduate student with. Professor Beckner has been a wonderful mentor and someone who has given my invaluable advice throughout my undergraduate career. //Fix this

My time in the University of Texas at Austin Department of Mathematics has been profoundly shaped by the brilliant and supportive community around me. I am deeply thankful to my fellow undergraduates and friends, specifically Xinbo Li, Prajith Velicheti, Luke Lu, Amanda Yin, and Leo Wang, for the countless hours spent at the whiteboard, the late-night study sessions, and the much-needed breaks.

= Preliminaries
<Prelims>
== Graphons
We follow the notation and terminology of Chatterjee's monograph @chatterjee2017large, to which we refer the reader for proofs and further background. This section collects the definitions and facts from graphon theory that we will use throughout. Before discussing the theory, we fix our graph-theoretic terminology.

#definition[
  A *simple graph*, informally, is a collection of points together with lines connecting the points, where no line can connect a point to itself. Formally, we define a simple graph $G$ as a pair $G = (V, E)$ where $V$ is finite set, identified with ${1, #sym.dots.h, abs(V)}$, and $E$ is a set of unordered pairs of distinct elements of $V$. We call elements of $V$ vertices and elements of $E$ edges. When we need to refer to the vertex and edge sets of a particular graph $G$, we can write $V(G)$ and $E(G)$. Let the set of simple graphs be $cal(G)$.
]

Graphons were introduced by Lovász and Szegedy @lovasz2006limits as a limit object for sequences of dense simple graphs. Before giving the formal definition, we motivate the choice of object by describing how a graphon parametrizes a natural random graph model — a perspective that will make the equivalence relations in the formal definition feel inevitable rather than arbitrary.

Given a symmetric measurable function $W: [0, 1]^(2) -> [0, 1]$ and an integer $n$, the *$W$-random graph* $G(n, W)$ on a vertex set ${1, #sym.dots.h, n}$ is constructed in two steps. First, independently sample $n$ random variables $U_(1), #sym.dots.h, U_(n)$ uniformly on $[0, 1]$ and assign the label $U_(i)$ to vertex $i$. Secondly, independently on each pair $i < j$, include the edge ${i, j}$ with probability $W(U_(i), U_(j))$. The value $W(x, y)$ is then the connection probability between vertices labeled $x$ and $y$ and the uniform distribution on $[0, 1]$ is the distribution over the labels. This construction recovers the Erdös–Rényi model $G(n, p)$ when $W equiv p$ is constant, and recovers the stochastic block model when $W$ is a step function, which we will call multipodal.

With this perspective in mind, we define the space of graphons.


#definition[The space $cal(W)$ of *graphons* is the set of Borel measurable functions $W: [0, 1]^(2) -> [0, 1]$ satisfying $W(x, y) = W(y, x)$, modulo the equivalence relation identifying functions that agree almost everywhere.]
#remark[
  The almost everywhere quotient deserves comment. If $W$ and $W prime$ differ only on a set of Lebesgue measure zero in $[0, 1]^(2)$, then almost surely no sampled pair $(U_(i), U_(j))$ ever lands on the set of disagreement, and so $G(n, W)$ and $G(n, W prime)$ have identical distributions. Two graphons that agree almost everywhere are thus genuinely indistinguishable as random graph models, and the a.e. quotient reflects this equality rather than being a technical convenience (though this is true too).
]

The simplest types of graphons are multipodal graphons which are defined below.

#definition[
  $W$ is a *multipodal graphon* if there exists a natural number $N$, a partition of $[0, 1]$ by measurable sets of positive measure $I_(1), #sym.dots.h, I_(N)$, and weights $w_(i j) in [0, 1]$ with $w_(i j) = w_(j i)$  for $i, j in {1, #sym.dots.h, N}$ such that $ W = sum_(i = 1)^(N) sum_(j = 1)^(N)w_(i j) bb(1)_(I_(i) times I_(j)). $ We call $I_(i)$ the *podes* of $W$ and the values $w_(i j)$ the edge weights of $W$. When we wish to specify the number of podes, we call $W$ an *$N$-podal graphon*. Such graphons are also called step function graphons.
]

Within the family of multipodal graphons lies a particularly important subclass. This subclass demonstrates exactly how graphons serve as a continuous generalization of finite graphs.

#definition(name: "Graphon Blowup")[
  Let $G$ be a simple graph on vertex set ${1, #sym.dots.h, n}$. Partition $[0, 1]$ into intervals $I_(1), #sym.dots.h, I_(n)$ of equal length, and define the graphon $W_(G): [0, 1]^(2) -> {0, 1}$ by $ W_(G)(x, y) = cases(
    1 "if" (x, y) in I_(i) times I_(j) "and" {i, j} in E(G), 0 "otherwise"
  ). $ We call $W_(G)$ the *graphon blowup* of $G$. $W_(G)$ is also called the checkerboard graphon of $G$.
]

The graphon $W_(G)$ is symmetric by construction and takes values in ${0, 1}$. It encodes the adjacency matrix of $G$ as a multipodal graphon with $n$ equal-sized parts.

The natural topology on $cal(W)$ is induced by the *cut norm* and the induced *cut distance*.

#definition(name: "Cut Norm and Cut Distance")[
  $cal(W)$ has a natural norm, called the *cut norm* that it inherits from bounded functions from $[0, 1]^(2)$ to $RR$. Where $W in cal(W)$, $ norm(W)_(cut) = sup_(S, T in cal(L)([0, 1])) abs(integral_(S times T)W(x, y) dif x dif y) $
  The cut norm induces a natural notion of distance on $cal(W)$, called the *cut distance*. For $W_(1), W_(2) in cal(W)$,

  $ d_(cut)(W_(1), W_(2)) = sup_(S, T subset [0, 1]) abs(integral_(S times T) (W_(1)(x, y) - W_(2)(x, y)) dif x dif y) $ where $cal(L)([0, 1])$ is the set of Lebesgue measurable subsets of $[0, 1]$.
]

The cut distance captures the idea that two graphons are close if, for every pair of label regions $S$ and $T$, they assign the same edge mass to $S times T$. However, $d_(cut)$ is too fine an equivalence for our purposes: it distinguishes graphons that ought to represent the same object. To see what additional equivalence is needed, consider the analogous issue for finite graphs.

To motivate the next quotient, recall the analogous situation for simple graphs. If $G_1$ and $G_2$ are simple graphs on the same vertex set and $G_(2)$ arises from $G_(1)$ by a permutation of vertices, that is there exists a bijection $sigma: V(G_1) -> V(G_(2))$ with ${u, v} in E(G_1) <=> {sigma(u), sigma(v)} in E(G_2)$, then we say $G_1$ is isomorphic to $G_2$. Any property of a graph that we care about is invariant under vertex relabeling.


The analogue for graphons is a *measure preserving bijection* $sigma: [0, 1] -> [0, 1]$, which serves as a permutation of labeling space. Given such a $sigma$ and $W$, define $W^(sigma)(x, y) = W(sigma(x), sigma(y))$. If $sigma(U_(1)), #sym.dots.h, sigma(U_(n))$ are obtained from i.i.d. uniform samples $U_(1), #sym.dots.h, U_(n)$, then they themselves are i.i.d. uniform on $[0, 1]$. So $W^(sigma)$ generates the exact same distribution of random graphs as $W$. Just as isomorphic simple graphs differ only in how their vertices are labeled, $W$ and $W^(sigma)$ differ only in how $[0, 1]$ is labeled.

#definition(name: "Cut Metric")[
  The functional $delta_(cut)$ is called the *cut metric*. For $W_(1), W_(2) in cal(W)$,

  $ delta_(cut)(W_(1), W_2) = inf_(sigma) d_(cut)(W_1, W_2) $ where the infimum is taken over the all measure preserving bijections $sigma: [0, 1] -> [0, 1]$.
]

One of the motivations for developing the machinery of graphons, along with the cut distance and cut metric, is to establish a unified framework for comparing finite graphs, particularly those with different numbers of vertices. This comparison is achieved by embedding the discrete graphs into the continuous space $cal(W)$  via their graphon blowups. In this continuous setting, the cut distance allows us to compare two graphs up to a fixed vertex labeling, whereas the cut metric inherently compares them up to graph isomorphism.

The functional $delta_(cut)$ is a pseudometric on $cal(W)$. It descends to a genuine metric on the quotient space defined below.

#definition(name: "Reduced Graphons")[
  $ tilde(cal(W)) = cal(W) \/ (W_(1) ~ W_(2) <=> delta_(cut)(W_1, W_2) = 0) $ is called the space of *reduced graphons*. The equivalence relation used to define $tilde(cal(W))$ is called *weak equivalence*. $(tilde(cal(W)), delta_(cut))$ is a metric space.
]
// Remark sounds weird
#remark[
  Beyond weak equivalence, another natural notion of equivalence exists. Two graphons $W_(1), W_(2) in cal(W)$ are considered *group equivalent* if they lie in the same orbit under the action of measure-preserving bijections on $[0, 1]$. However, it is possible for the orbits of two graphons to become arbitrarily close in cut distance—yielding identical structural properties for their sampled graphs—without the graphons being strictly group equivalent. Weak equivalence resolves this issue by effectively acting as the topological closure of group equivalence.
]

The central topological fact, due to Lovász and Szegedy, is the following.

#theorem(name: [Graphon Compactness Theorem @lovasz2006limits])[
  The metric space $(tilde(cal(W)), delta_(cut))$ is compact.
]<CompactnessOfGraphons>

// check phrasing of last sentence here
Throughout the remainder of the thesis, we will work implicitly in the quotient space $tilde(cal(W))$.  Furthermore, the term "graphon" will refer to the equivalence class of a reduced graphon.


// Is this just hanging here
To conclude these preliminaries, we return to the terminology of a "limit object." The terminology is justified by the fact that for any graphon $W$, the graphon blowup of $G(n, W)$ converges to $W$ in cut metric almost surely as $n -> oo$ @lovasz2006limits. Thus graphons simultaneously parametrize random graph models and arise as limits of dense graph sequences.

=== Homomorphism Densities
The primary numerical invariants of graphons are homomorphism densities, which generalize the idea of homomorphism densities of finite graphs.

// SHOULD THIS GO ABOVE TO THE DEF OF SIMPLE GRAPH
#definition[
  Let $G$ and $H$ be simple graphs where $abs(V(G)) <= abs(V(H))$. A homomorphism from $G$ to $H$ is a function $f: V(G) -> V(H)$ where if ${u, v} in E(G)$ then ${f(u), f(v)} in E(H)$. Let $hom(G, H)$ be the set of homomorphisms from $G$ to $H$.   The *homomorphism density* of $G$ into $H$ is $ t(G, H) := (abs(hom(G, H)))/(abs(V(H))^(V(G))) $ is the probability that an arbitrary function $V(G) -> V(H)$ is a homomorphism.
]

There is a similar notion for graphons.

#definition[
  For a simple graph $G$ with $k$ vertices and a graphon $W$, the *homomorphism density* of $G$ in $W$ is $ t(G, W) := integral_([0, 1]^(k)) product_({i, j} in E(G)) W(x_(i), x_(j)) dif x_(1) #sym.dots.h dif x_(k) $
]

Two special cases are central to this thesis. The *edge density* of $W$ is

$
  e(W) & = norm(W)_(1) = integral_([0, 1]^(2)) W(x, y) dif x dif y
$
and the *triangle density* is
$
  t(W) & = t(K_(3), W) = integral_([0, 1]^(3)) W(x, y) W(y, z) W(x, z) dif x dif y dif z
$

From the stochastic perspective, $t(G, W)$ has a clean interpretation. It is the limiting probability, as $n -> oo$, that a fixed map $V(G) -> V(G(n, W))$ is a graph homomorphism from $G$ into $G(n, W)$. In particular, $e(W)$ is the edge probability and $t(W)$ is the triangle probability of the associated random graph model.

//WRITE SOMETHING ABOVE THIS
#theorem[Let $G$ and $H$ be simple graphs where $abs(V(G)) <= abs(V(H))$, then
  $ t(G, H) = t(G, W_(H)) $ where $W_(H)$ is the graphon blowup of $H$.
]

A foundational property, which motivates the choice of cut topology, is that the homomorphism densities are continuous in $tilde(cal(W))$.

#theorem(name: [Continuity of Homomorphism Density @lovasz2006limits])[
  For every simple graph $G$, the map $t(G, dot)$ is continuous on $(tilde(cal(W)), delta_(cut))$.
]<ContinuityHomomorphismDensity>

But homomorphism densities aren't just continuous.

#theorem(name: [Homomorphism Density is Injective Embedding @lovasz2006limits])[
  The map $tilde(cal(W)) -> [0, 1]^(cal(G))$ defined by $ W -> (t(G, W))_(G in cal(G)) $ is an injective embedding.
]<InjectiveEmbeddingHomomorphism>

//fix this a bit
Together, these two theorems justify graphons as the proper limit objects for the problems we study. Because homomorphism densities, specifically the edge and triangle densities whose asymptotics we analyze, vary continuously under the cut topology, extremal questions over $tilde(cal(W))$ are mathematically well-posed.

=== Approximation by Finite Podal Graphons
We now return to the subclass of multipodal graphons, which will play a central role in the analysis to follow: they are often used as proxies for the full space of graphons. The following density result is what makes multipodal graphons important.

#theorem(name: [@lovasz2006limits])[
  The set of multipodal graphons is dense in $(tilde(cal(W)), delta_(cut))$. Furthermore, the set of checkerboard graphons is dense in $(tilde(cal(W)), delta_(cut))$.
]

For multipodal graphons, the homomorphism density reduces to a finite sum of vertex to pode assignments.

#lemma(name: "Reduction of Homomorphism Density")[
  Let $W$ be a $N$-podal graphon with podes ${S_(i)}_(i = 1)^(N)$ and edge weights $w_(i j)$. For any simple graph $G$, $ t(G, W) = sum_(phi: V(G) -> {1, #sym.dots.h, N})^()(product_(v in V(G)) mu(S_(phi(v))))(product_({i, j} in E(G)) w_(phi(i) phi(j))) $
]
#proof[
  Let $V(G) = {1, #sym.dots.h, k}$. Since ${S_(i)}_(i = 1)^(N)$ partitions $[0, 1]$, the product space $[0, 1]^(k)$ is partitioned into cells $product_(i = 1)^(k) S_(phi(i))$ indexed by functions $phi: V(G) -> {1, #sym.dots.h, N}$. Hence $ t(G, W) & = integral_([0, 1]^(k)) product_({i, j} in E(G)) W(x_(i), x_(j)) dif x_(1) #sym.dots.h dif x_(k) \
  & = sum_(phi: V(G) -> {1, #sym.dots.h, N})^() integral_(product_(a = 1)^(k) S_(phi(a))) product_({i, j} in E(G)) W(x_(i), x_(j)) dif x_(1) #sym.dots.h dif x_(k). $

  By the definition of $W$, $ t(G, W) &= sum_(phi: V(G) -> {1, #sym.dots.h, N})^() integral_(product_(a = 1)^(k) S_(phi(a))) product_({i, j} in E(G)) w_(phi(i) phi(j)) dif x_(1) #sym.dots.h dif x_(k) \
  &= sum_(phi: V(G) -> {1, #sym.dots.h, N})^() (product_({i, j} in E(G)) w_(phi(i) phi(j))) integral_(product_(a = 1)^(k) S_(phi(a))) dif x_(1) #sym.dots.h dif x_(k) \
  &= sum_(phi: V(G) -> {1, #sym.dots.h, N})^() (product_({i, j} in E(G)) w_(phi(i) phi(j))) (product_(v in V(G)) mu(S_(phi(v)))) \ $
]

Specializing the reduction lemma to $G = K_(2)$ and $G = K_(3)$, for which $phi: V(G) -> {1, #sym.dots.h, N}$ are ordered pairs and triples respectively, gives the following expressions for the edge and triangle densities $ e(W) & = sum_(i, j = 1)^(N) mu(S_(i)) mu(S_(j)) w_(i j) \
t(W) & = sum_(i, j, k = 1)^(N) mu(S_(i)) mu(S_(j)) mu(S_(k)) w_(i j) w_(i k) w_(j k) $

=== Razborov Triangle
The image of the function $(e, t): tilde(cal(W)) -> [0, 1]^(2)$ where $W -> (e(W), t(W))$ is called the *Razborov Triangle $cal(R)$*, after Razborov found the minimal triangle density for a given edge density in his seminal paper @razborov2008minimal.

#theorem(name: [Maximum Triangle Density])[
  For a graphon $W$ with edge density $epsilon$ $ t(W) <= epsilon^((3)/(2)). $ The bound is uniquely satisfied by $W = bb(1)_([0, sqrt(epsilon)]^(2))$.
]<TriangleMax>

#theorem(name: [Minimum Triangle Density I (Mantel's Theorem)])[
  For a graphon $W$ with edge density $epsilon in [0, (1)/(2)]$, $t(W) >= 0$. An example of a graphon which achieves this lower bound is $ W = 2 epsilon(bb(1)_([0, (1)/(2)] times [(1)/(2), 1])+ bb(1)_([(1)/(2), 1] times [0, (1)/(2)])) $
]<TriangleMin1>


#theorem(name: [Minimum Triangle Density II @razborov2008minimal])[
  For a graphon $W$ with edge density $epsilon in [1 - (1)/(k), 1 - (1)/(k + 1)]$ for $k >= 2$  $ t(W) >= (k(k-1))/(k + 1)^(2) (1 + sqrt(1 - epsilon (k + 1)/(k)) )^(2) (1 - 2 sqrt(1 - epsilon (k + 1)/(k)) ) $
]<TriangleMin2>
#remark[
  Razborov proved this using Flag Algebras, which can be thought of as a dual object to graphons by @InjectiveEmbeddingHomomorphism. Flag Algebras seek to understand how the collections of homomorphism densities behave. Furthermore, one can define an algebra over such objects to do interesting computations, which often reduce to semidefinite programming problems. See @razborov2008minimal, @razborov2013flag, @silva2016flag for further reference on this topic.
]

// TODO VERIFY this.
#theorem(name: [Minimum Triangle Density III @pikhurko2017asymptotic])[
  Let $epsilon in [1 - (1)/(k), 1 - (1)/(k + 1)]$. Let $ c = (1 + sqrt(1 - epsilon (k + 1)/(k)) )/(k + 1). $ Partition $[0, 1]$ into $k$ intervals $I_(1), #sym.dots.h, I_(k)$ where $abs(I_(i)) = c$ for $i in {1, #sym.dots.h, k - 1}$ and $abs(I_(k)) = 1 - (k - 1)c$. Define a graphon $W$ as follows. We set $W = 1$ when $I_(i) times I_(j)$ for all $i != j$. For $i < k$, $W = 0$ on $I_(i) times I_(i)$. Finally, on $I_(k) times I_(k)$ the graphon is not constrained, except to have the correct average value, and to not allow any triangles where all three vertices are in $I_(k)$. For such a graphon $t(W)$ achieves the lower bound in @TriangleMin2.
]<MinTriangle3>
#remark[
  This strategy, partitioning the graphon such that one localized region exhausts the allowed triangle density while the remainder contributes to the edge density without forming triangles, will be directly reflected in the constructions later in this thesis.
]

Putting the results of @TriangleMax, @TriangleMin1, @TriangleMin2, and @MinTriangle3 together, we see $cal(R)$ looks like the region below in @RazbTriangleVis.

#figure(
  RazbTriangle,
  caption: [    The Razborov Triangle $cal(R)$: The shaded interior represents the achievable triangle densities $t$ for a given edge density $e$.
  ],
)<RazbTriangleVis>

Our region of interest in this thesis is looking infinitesimally close to $(0, 0.5] times {0} in R$.

== Linear Programming
Lets switch gears a bit, and discuss Linear Programming. We will follow the notation and terminology of #cite(<vanderbei1998linear>, form: "prose").
A *Linear Program (LP)* is a optimization problem in which a linear function is minimized or maximized subject to finitely many linear inequality or equality constraints. The general minimization form which we will use is $ min & c^(T) x & "subject to" A x >= b, x>= 0, $
where $A in RR^(m times n)$, $c in RR^(n)$, $b in RR^(m)$ are the *input data* and $x in RR^(n)$ is the vector of *variables*. The linear function is called the *objective function*, and the conditions $A x >= b$ and $x >= 0$ (both interpreted component wise) are the *constraints*.

A vector $x in RR^(n)$ which satisfies all the constraints is a *feasible point*; the set of all feasible points is the *feasible region*, which is a polyhedron, an intersection of a collection of half spaces. An LP is *feasible* if the feasible region is nonempty, and bounded if $c^(T) x$ is bounded below on the feasible region. The *optimal value* is the infimum *$c^(T) x$* over the feasible region, and a feasible point achieving this value is an *optimal solution*.

Other standard forms (maximization, $<=$, equality constraints, or free variables) can be converted into the form above by standard transformations, and all results we state below apply equally in those forms.

Geometrically, an LP asks for the minimum of a linear function over a polyhedron. Since the objective is linear, whenever an optimal solution exists, one can be found at a vertex of the feasible region. This underlies much of the theory.

#example[
  Consider the LP $min x + y$ subject to the constraints that $ mat(1, 2; 2, 1) vec(x, y) >= vec(2, 2) $ and $x, y>=0$. The feasible region is an unbounded polyhedron in the first quadrant lying above the lines $x + 2 y = 2$ and $2 x + y = 2$. The level sets of the objective function are lines of slope $-1$. Thus starting at $x + y = 0$ and then moving the line upward, the first point we hit of the feasible region is the intersection of the two boundary lines, namely $(x, y) = ((2)/(3), (2)/(3))$, with objective value $(4)/(3)$.



  #figure(LPexample, caption: [Graphical solution to the linear program.])
]<LPExample>

Two features seen in the example will recur. First the optimum is obtained at a vertex of the feasible region. It will specifically occur at the intersection of two binding constraints. Second, although the input data are integers, the optimal solution has rational (non-integer) coordinates; this is typical of LPs arising from combinatorial problems and reflects the fact that an LP is often a relaxation of a discrete problem.

=== Existence of Solutions to an LP
Given an LP of the form above. We have 3 possibilities regarding its behavior:

1. The LP is *infeasible*: There exists no $x in RR^(n)$ satisfying the constraints
2. The LP is *feasible* but *unbounded*: For all $M in RR$, there exists $x in RR^(n)_(>=0)$ such that $c^(T) x < M$.
3. The LP is *feasible and bounded*: $c^(T) x$ has a finite infimum over the feasible region

In the third case, it is not obvious a priori that the infimum is attained. The feasible region is closed (as an intersection of finitely many closed half-spaces) but it need not be compact (see @LPExample), and a continuous function on a non-compact closed set need not attain its infimum. However a foundational result in the theory of LPs tells us that the infimum is always attained.

#theorem(
  name: "Existence of Optimal Solutions",
)[If an LP is feasible and bounded, then it has an optimal solution; moreover, one can always be chosen at a vertex of the feasible region
]

The second part of the theorem gives the intuition on why the first part holds. Although the polyhedron is unbounded, its set of vertices form a finite set, and a minimum of a linear function over the feasible region, if finite, must be attained at one of them. A full proof uses the structure of the polyhedra (every feasible point is a convex combination of the vertices plus a nonnegative combination of extreme rays) and the observation that the objective can only decrease by moving along the extreme ray if the LP is unbounded.

The LPs that occur in the thesis are of a particularly nice form. Their feasible regions are nonempty. Every LP we will consider has a feasible point obtained by setting all the variables sufficiently large. Furthermore, their objectives are bounded below by 0, since all the variables are nonnegative and the objective coefficients are nonnegative. Hence every LP we consider has an optimal solution.

=== Dual Linear Programs
For linear programs, there is a natural notion of duality, which we will define below. Dual Linear Programs and the theorems relating a LP and its dual, will be a vital tool in this thesis.
// Before defining the dual, we will motivate the definition a bit. Given an LP (which we will call the original LP)

// $ min c^(T) x & "subject to" A x >= b, x>= 0, $

// we can ask for a bound on the optimal value? In other words, how do we prove that the optimal value is at least some number $L$.

// Consider our earlier example. Can we prove the lower bound algebraically, rather than graphically? Here is a way: if we add the two constraints, we see that $3 x + 3y >= 4$ which gives $x + y >= (4)/(3)$. Since $x + y$ is the objective function, we have shown that every feasible point has an objective value of at least 4/3, which matches our optimal value.

// The move here was to take a *non-negative linear combination of the constraints* and then observe that the resulting inequality had the objective function on one side and a number on the other side. Whenever such a combination can be arranged, the right-hand side is a valid lower bound on the primal optimum. The dual LP formalizes and generalizes this idea.

// Going back to our general LP, suppose $y in RR^(m)_(>=0)$ is a vector. Multiplying the $k$-th constraint $sum_(k) A_(k i) x_(i) >= b_(k)$ by $y_(k)$ and summing gives us $ y^(T) A x >= y^(T) b. $ This inequality holds for every feasible $x$. Now, suppose further we choose $y$ such that $A^(T) y <= c$ componentwise. Then for all feasible $x >= 0$:

// $ c^(T) x >= (A^(T) y)^(T) x = y^(T) A x >= y^(T) b = b^(T) y $

// so $b^(T) y$ is a lower bound on the primal optimum. To get the best lower bound this way, we should maximize over all $y$ where $A^(T) y <= c$. So we get

// $ max b^(T) y & "subject to" A^(T) y <= c, y>= 0, $

// This LP is called the *dual* to the original, which we will now call *primal*.

#definition[
  Given the *primal* LP,

  $ min c^(T) x & "subject to" A x >= b, x>= 0, $

  its *dual* is the LP

  $ max b^(T) y & "subject to" A^(T) y <= c, y>= 0, $

  Variables of the dual are called *dual variables* and constraints of the dual are called *dual constraints*. By construction there is one dual variable per primal constraint, and one dual constraint per primal variable.
]

The dual of the dual, formed by applying this transformation again (after converting the maximization to standard minimization form), is the primal. So *primal* and *dual* are symmetric. The argument above gives us the following theorem for free.

#theorem(name: "Weak Duality")[
  Let $x$ be a feasible point of the primal LP and $y$ be a feasible point of the dual LP. Then $ c^(T)x >= b^(T) y. $ In particular, the optimal value of the dual is at most the optimal value of the primal.
]
#proof[
  $b^(T) y = y^T b <= y^(T) A x = (A^(T) y)^(T) x <= c^(T) x$, where we are using the constraints of $x$ and $y$.
]

Weak duality tells us the dual gives a lower bound on the primal. The fundamental theorem of LP duality says that this bound is in fact tight.

#theorem(name: "Strong Duality")[
  Suppose the primal and dual are both feasible. Then they have optimal solutions, and their optimal values are equal: $ min{c^(T) x : A x >= b, x >= 0} = max{b^(T) y : A^(T) y <= c, y >= 0} $
]

Strong Duality is a deep result. Its proof relies on a classical theorem of linear inequalities called Farkas' lemma. We refer to #cite(<vanderbei1998linear>, form: "prose") for full treatment. For our purposes, Strong Duality will be the key structural tool in the thesis. It allows us to prove statements about the primal optimum by reasoning about the dual, and vice versa.

Linear programs of the form considered here, minimizing a linear functional over a polyhedron defined by combinatorially-indexed constraints, arise throughout combinatorics as the natural continuous analogues to discrete optimization problems over graphs. LP duality then provides a structural link between the problem and its dual that is often surprising and powerful. In @alphaG we will define a linear program $alpha(G)$, whose constraints are indexed by the triangles of a graph $G$. Strong duality applied to $alpha(G)$ will be essential to the upper bound arguments of later sections.



// === Rationality and Computational Tractability
// Two further results about LPs that will be useful to have on hand, both concerning the "nice" behavior of LPs with rational input data.

// // TODO CITE
// #theorem(name: [Rationality])[
//   Suppose the input data $A, b, c$ of an LP are rational. If the LP has a optimal solution, then it has a optimal solution with rational coordinates, and the optimal value is rational.
// ]

// The intuition for this theorem is mentioned above: an optimal solution can be found at the vertices of the feasible region, and the vertex of a polyhedron defined by rational data is the unique solution of a rational linear system, hence rational. Furthermore, the rationality of input data can give us important information about the computational tractability of solving linear programs.


// #theorem(
//   name: [Polynomial Time Solvability @khachiyan1980polynomial],
// )[There is a algorithm, which given an LP with rational input data of total bit length $L$, computes an optimal solution (or determines that none exists) in time polynomial in $L$
// ]

// The linear program of interest in this thesis $alpha(G)$ has integer coefficients, in fact, strictly 0s and 1s. Thus it trivially has a finite total bit length bounded by the size of the graph. Thus these two theorems combine to give us the following concrete guarentee: $alpha(G)$ is rational and can be computed in polynomial time in the size of $G$.

== Finner's Generalized Holder Inequality
The following is a classical inequality in measure theory, together with a corollary that will be convenient for our application.

#theorem(name: [Finner's Generalized Hölder Inequality @finner1992generalization])[
  Let $n in NN$, and let ${(X_(i), cal(M)_(i), mu_(i))}_(i = 1)^(n)$ be a collection of measure spaces. Let $X = X_(1) times #sym.dots.h times X_(n)$ be their full product, equipped with the product measure $mu$. For any nonempty subset of indices $S subset [n]$, let $X_(S) = product_(S) X_(k)$ denote the lower-dimensional product space with the corresponding product measure $mu_(S)$. Suppose we have $m$ non-empty index subsets $S_(1), #sym.dots.h, S_(m) subset [n]$, and corresponding exponents $p_(1), #sym.dots.h, p_(m) in [1, oo)$. Assume that for every coordinate $k in {1, #sym.dots.h, n}$, the sum of $(1)/(p_(j))$ over the subsets $S_(j)$ that contain $k$ is exactly 1:

  $ sum_({j: k in S_(j)})^() (1)/(p_(j)) = 1 $

  For each $j in [m]$, let $f_(j): X_(S_(j)) -> RR$ be a measurable function such that $f_(j) in L^(p_(j))(X_(S_(j)), mu_(S_(j)))$. Then, the product $product_(i = 1)^(m) abs(f_(i))$, evaluated as a function on the full space $X$, is integrable with respect to $mu$, and the following inequality holds:

  $ integral_(X)product_(i = 1)^(m) abs(f_(i)(x_(S_(i)))) dif mu <= product_(i = 1)^(m) norm(f_(i))_(p_(i)) $
]<FinnersInequality>

#corollary[
  Let $n in NN$, and let ${(X_(i), cal(M)_(i), mu_(i))}_(i = 1)^(n)$ be a collection of probability spaces. Let $X = X_(1) times #sym.dots.h times X_(n)$ be their full product, equipped with the product measure $mu$. For any nonempty subset of indices $S subset [n]$, let $X_(S) = product_(S) X_(k)$ denote the lower-dimensional product space with the corresponding product measure $mu_(S)$. Suppose we have $m$ nonempty index subsets $S_(1), #sym.dots.h, S_(m) subset [n]$, and corresponding exponents $p_(1), #sym.dots.h, p_(m) in [1, oo)$. Assume that for every coordinate $k in {1, #sym.dots.h, n}$, the sum of $(1)/(p_(j))$ over the subsets $S_(j)$ that contain $k$ is less than or equal to 1:

  $ sum_({j: k in S_(j)})^() (1)/(p_(j)) <= 1 $

  For each $j in [m]$, let $f_(j): X_(S_(j)) -> RR$ be a measurable function such that $f_(j) in L^(p_(j))(X_(S_(j)), mu_(S_(j)))$. Then, the product $product_(i = 1)^(m) abs(f_(i))$, evaluated as a function on the full space $X$, is integrable with respect to $mu$, and the following inequality holds:

  $ integral_(X)product_(i = 1)^(m) abs(f_(i)(x_(S_(i)))) dif mu <= product_(i = 1)^(m) norm(f_(i))_(p_(i)) $
]<FinnerCorollary>
#proof[
  Let $A = {a_(1), #sym.dots.h, a_(k)}$ be the set of coordinates where $ sum_({j : a_(i) in S_(j)})^() (1)/(p_(j)) < 1. $ Let $S_(m + 1) = {a_(1)}, #sym.dots.h, S_(m + k) = {a_(k)}$. Let $ p_(m + i)^(-1) & = 1 - sum_({j : a_(i) in S_(j), j <= m})^() p_(j)^(-1), $ and let $f_(m + i) = 1$ for all $i in [k]$. Thus $ integral_(X)product_(i = 1)^(m) abs(f_(i)(x_(S_(i)))) dif mu &= integral_(X)product_(i = 1)^(m + k) abs(f_(i)(x_(S_(i)))) dif mu \
  &<= product_(i = 1)^(m + k) norm(f_(i))_(p_(i)) = product_(i = 1)^(m) norm(f_(i))_(p_(i)), $

  where the first equality comes from the fact that $f_(S_(m + i)) equiv 1$. The inequality comes from @FinnersInequality. The last inequality comes from the fact $norm(f_(m + i))_(p_(m + i)) = mu(X_(a_(i)))^((1)/(p_(a_(i))))$ (using the probability space assumption).
]


== Notation
*Sets*: For any natural number $N$, define $[N] := {1, #sym.dots.h, N}$. For a finite set $S$ and a natural number $n < abs(S)$, we write $binom(S, n)$ for the set of all $n$-element subsets of $S$. Let $RR_(>=0) := [0, oo)$, $RR_(>0) := (0 , oo)$. Let $mu$ be the Lebesgue measure on $[0, 1]$ or on $[0, 1]^(2)$, where context will make it clear whether we are talking about $[0, 1]$ or $[0, 1]^(2)$.

*Graphs*:
For a graph $G$, we will write $V(G)$ and $E(G)$ as the vertex and edge sets, respectively. An edge between vertices $u$ and $v$ is written as ${u, v}$ or sometimes $u v$ when there is no ambiguity. For a subgraph $T subset G$, we write $V(T)$ and $E(T)$ for its vertex and edge sets. We write $cal(T)(G)$ for the set of triangles in $G$. A triangle in $G$ is a 3-vertex subgraph of $G$ isomorphic to $K_(3)$. For any natural number $n$, let $K_(n)$ be a complete graph on $n$ vertices, in other words $K_(n) := ([n], binom([n], 2))$ as a vertex set and edge set pair. In particular, $K_(2)$ is an edge and $K_(3)$ is a triangle.

*Graphons:* For $(epsilon, tau)$ in the Razborov Triangle, we will define the following spaces of graphons for convenience: $               tilde(cal(W))(N) & := {W mid(|) W in tilde(cal(W)), W "is" N"-podal"} \
   tilde(cal(W))(epsilon, tau) & := {W mid(|) W in tilde(cal(W)), e(W) = epsilon, t(W) <= tau} \
tilde(cal(W))(N; epsilon, tau) & := tilde(cal(W))(N) inter tilde(cal(W))(epsilon, tau). $ Note if $(epsilon, tau)$ are not in the Razborov Triangle, $tilde(cal(W))(epsilon, tau)$ will be empty, by definition.

*Asymptotics*: For functions $f, g: D -> RR_(>0)$ and a limit point $p in D$, we write $f(x) = O(g(x))$ if there exists $C > 0$ such that $f(x) <= C g(x)$ in a punctured neighborhood of $p$. We write $f(x) = Omega(g(x))$ if there exists $c > 0$ such that $f(x) >= c g(x)$ in a punctured neighborhood of $p$. We write $f(x) = Theta(g(x))$ if $f(x) = O(g(x))$ and $f(x) = Omega(g(x))$.

= The Extremal Problem<TheProblem>
Having developed the relavent machinery, we will state the problem this thesis addresses. Fix a simple graph $G$, and a pair of edge and triangle densities in the Razborov triangle $(epsilon, tau) in "int"(cal(R))$. We ask: among all graphons with edge density $epsilon$ and triangle density at most $tau$, what is the tightest upper bound we can get for the homomorphism density of $G$? That is, we study the quantity $ T^(G)_(max)(epsilon, tau) := sup {t(G, W) mid(|) W in tilde(cal(W))(epsilon, tau)} $ and how it behaves near the boundary of the Razborov Triangle. In this thesis, we will seek to understand the asymptotics of $T_(max)^(G)$ for $tau -> 0$ and $epsilon in (0, (1)/(2)]$.

Intuitively, this is an extremal question about how much subgraph structure $G$ can survive in a graphon with a few triangles. The regime $tau -> 0$ forces the graphon toward triangle-free behavior while holding the edge density, and the question is whether (and how quickly) $G$-density must also decay.

Before turning to the asymptotics, we note that $T^(G)_(max)(epsilon, tau)$ is a genuine maximum, and not just a supremum.

#proposition[
  For every simple graph $G$, every $(epsilon, tau) in cal(R)$, there exists a graphon $W in tilde(cal(W))(epsilon, tau)$ such that $t(G, W) = T_(max)^(G)(epsilon, tau)$.
]<MaxAchieved>
#proof[
  Let $F: tilde(cal(W)) -> cal(R) subset [0, 1]^(2)$ where $F(W) = (e(W), t(W))$. By @ContinuityHomomorphismDensity, $e$ and $t$ are continuous, meaning $F$ is continuous. By definition, $tilde(cal(W))(epsilon, tau) = F^(-1)(epsilon times [0, tau])$. $epsilon times [0, tau]$ is closed, and as the preimage of a closed set $tilde(cal(W))(epsilon, tau)$ is closed. Since $(tilde(cal(W)), delta_(cut))$ is compact and all closed sets of a compact set are compact, $tilde(cal(W))(epsilon, tau)$ is compact. Finally, the map $t(G, dot)$ is continuous by @ContinuityHomomorphismDensity, and a continuous real-valued function on a nonempty compact set attains its supremum. Therefore, $T_(max)^(G)(epsilon, tau)$ is attained by some $W in tilde(cal(W))(epsilon, tau)$.
]

So we can redefine $T_(max)^(G)(epsilon, tau)$ as $ T_(max)^(G)(epsilon, tau) := max {t(G, W) mid(|) W in tilde(cal(W))(epsilon, tau)}. $

To show $T_(max)^(G)(epsilon, tau) = Theta(g(tau))$ for some function $g$, we have to show both $O(g(tau))$ and $Omega(g(tau))$. $Omega(g(tau))$ is a bit finicky but straight forward, for fixed $epsilon in (0, 0.5]$ we just have to exhibit a continuous function $W: (0, tau_(*)] -> tilde(cal(W))$ for some $tau_(*) > 0$ where $tau -> W_(tau) in tilde(cal(W))(epsilon, tau)$. We show that $t(G, W_(tau)) = g(tau)$ as $tau -> 0$. We do this in @GeneralConstructionLessHalf and @GeneralConstructionHalf for $epsilon in (0, 0.5)$ and $epsilon = 0.5$ respectively. $O(g(tau))$ requires a bit more work, which is why we look for simplifications to give us intuition, and hopefully reductions of the problem.

= Triangle Spanning Decomposition<TriangleSpanningDecomp>
To establish the upper bound,we first prove the result for a simpler family of graphs: those where every edge belongs to a triangle (see @generalUpper). In this section, we demonstrate that any arbitrary graph can be decomposed into a set of these triangle-spanning subgraphs, denoted $cal(C)$, alongside a collection of isolated edges and vertices. Subsequently, in @GeneralSquared, we will show that these residual components do not asymptotically affect the homomorphism density, allowing us to cleanly reduce the general upper bound to the triangle-spanning case.

#definition[
  A simple graph $G$ is triangle spanning if every edge of $G$ lies in a triangle of $G$.
]

#definition[
  Let $G$ be a simple graph. For triangles $S, T in cal(T)(G)$, $S <-> T$ if theres a sequence $S = T_(0), T_(1), #sym.dots.h, T_(k) = T$ of triangles in $G$ where $V(T_(i)) inter V(T_(i + 1)) != emptyset$ for all $i$. Let $cal(T)_1, #sym.dots.h, cal(T)_n$ be the equivalence classes under $<->$. Define $C_(i)$ a subgraph of $G$ with vertex set $ V(C_i) := union.big_(T in cal(T)_i) V(T) $ and edge set $ E(C_i) := union.big_(T in cal(T)_(i))E(T). $ Define the *bridge edges* $B := E(G) without union.big_(i) E(C_(i))$, and the *leftover vertices* $L := V(G) without union.big_(i) V(C_(i))$.
]

#lemma[ The $C_(i)$ are vertex disjoint and edge disjoint triangle spanning subgraphs of $G$, $B$ consists of edges not lying in any triangle of $G$, and $L$ be the vertices in no triangles,${E(C_(i))}_(i = 1)^(n) union B$ is a partition of $E(G)$, and ${V(C_(i))}_(i = 1)^(n) union L$ is a partition of $V(G)$.
]<trispandecomp>
#proof[
  1. *$B$ consists of edges not in any triangle of $G$*: Let $e in E(G)$. If $e$ lies in some triangle $T in cal(T)(G)$, then $T in cal(T)_(i)$ for some $i$, so $e in E(T) subset E(C_(i))$. Hence $e in.not B$. Conversely, if $e in C_(i)$, then by definition $e in E(T)$ for some triangle $T in cal(T)_(i) subset cal(T)(G)$, so $e$ lies in some triangle of $G$. Thus $e in B$ if and only if $e$ lies in no triangle of $G$. The same argument with vertices in place of edges shows $v in L$ if and only if $v$ lies in no triangle.
  2. *${E(C_(i))}$ and ${V(C_(i))}$ are pairwise disjoint*: Suppose there exists $e in C_(i) inter C_(j)$ for some $i, j in [n]$. Then $e in E(A)$ for some $A in cal(T)_(i)$ and $B in cal(T)_(j)$. Since $A$ and $B$ share an edge $e$, hence share two vertices, so $A <-> B$ directly (chain of length 1). So $i = j$. There for $E(C_(i))$ are pairwise disjoint. The same argument works for the vertices. Combining with the definitions for $B$ and $L$, this gives us the partitions $E(G) = union.sq_(i) E(C_(i)) union.sq B$ and $V(G) = union.sq_(i) V(C_(i)) union L$.
  3. *Each $C_(i)$ is triangle spanning*: By construction, $forall e in E(C_(i))$ there exists $T in cal(T_(i))$ such that $e in E(T)$. We must show $T$ is a triangle in $C_(i)$, but this is trivial. By construction, $V(T) subset V(C_(i))$ and $E(T) subset E(C_(i))$. So $e$ is contained in a triangle $T$ in $C_(i)$.
]

#definition[
  The $C_(i)$ are the *maximal triangle-spanning components* of $G$. The triple $(cal(C), B, L)$, where $cal(C) = {C_(i)}_(i = 1)^(n)$, is the *triangle spanning decomposition* of $G$. Let $V(cal(C)) := V(G) without L$ and $E(cal(C)) := E(G) without B$.
]

Thus we will prove the desired upper bound for triangle spanning graphs first, then we will use the decomposition and reduce the general graph case to a finite number of triangle spanning subgraphs.


= The Graph Parameter $alpha(G)$
<alphaG>

In this section, we will introduce the graph parameter $alpha(G)$ that will control the asymptotics of $T_(max)^(G)(epsilon, tau)$. Before the formal definition, we will motivate it through a heuristic computation. Suppose, for a moment, that $T_(max)^(G)(epsilon, tau) = Theta(tau^(alpha))$ for some $alpha = alpha(G) >= 0$, possibly depending on $G$.

This assumption is a guess. A priori, $T_(max)^(G)$ could decay faster than any power of $tau$, slower than any power, or may not have any clean scaling. But the guess is motivated by the fact the relavent functionals are all polynomials: on a multipodal graphon with pode measure $alpha_(i)$ and edge weights $w_(i j)$, both $t(W)$ and $t(G, W)$ are polynomial in $alpha_(i)$ and edge weights $w_(i j)$. So a question about one polynomial functional constrained by other has the chance of admitting a clean power-law scaling. Not automatic, but plausible enough to pursue.

Taking logarithms and passing to the limit we see the exponent would be $ alpha = lim_(tau -> 0) (log(T^(G)_(max)(epsilon, tau)))/(log(tau)), $ if the limit exists.

Since $T_(max)^(G)$ is the maxiumum of $t(G, W)$ over $tilde(cal(W))(epsilon, tau)$, we can approximate $alpha$ by exhibiting a graphon $W_(tau) in tilde(cal(W))(epsilon, tau)$ which depends on $tau$ whose $t(G, W_(tau))$ exhibits a clean scaling. Any such construction gives a bound on the exponent; the right construction should give its value.

*Candidate Construction*: Assume $G$ is a triangle spanning graph and has a triangle. We can technically do this for all $G$, but the triangle spanning case is a lot more illuminating. Our guiding intuition is to avoid "wasted" triangles: any triangle formed in our graphon should ideally correspond to a triangle actually present in $G$. the graphon generates extraneous triangles, it exhausts our tightly constrained $tau$-budget without increasing the density of $G$.

To realize this, consider constructing a multipodal graphon with $V = abs(V(G))$ podes, where each pode corresponds to a vertex of $G$. We scale the sizes of these podes and the weights of the edges between them as powers of $tau$. Let the measure of the $v$-th pode be $tau^(x_(v))$ for some $x_(v) >= 0$, let the edge weight between pode $u$ and $v$ be roughly $tau^(y_(u v))$ (for non edges in $G$, set the edge weight to 0).

With this construction, the homomorphism density of $G$ generated by mapping each vertex of $G$ to its corresponding pode is proportional to the product product of the pode measures and edge weights:

$
  t(G, W) approx product_(v in V(G)) tau^(x_(v)) product_(e in E(G)) tau^(y_(e)) = tau^(sum_(v in V(G))^() x_(v) + sum_(e in E(G))^() y_(e))
$

Because $tau$ is small ($tau -> 0$), to _maximize_ this density, we must minimize the exponent $sum_(v in V(G))^() x_(v) + sum_(e in E(G))^() y_(e)$. However, we have a restricted total triangle budget. In this $V$-podal graphon, the triangles formed correspond exactly to $T in cal(T)(G)$. The density of any specific triangle $T$ in the graphon scales as:
$ tau^(sum_(v in V(T))^() x_(v)^(*) + sum_(e in E(T))^() y_(e)^(*)). $

To satisfy the constraint that $t(W) <= tau = tau^(1)$, every individual triangle formed in the graphon must have a density of $O(tau)$. Therefore, the exponent for each triangle must be at least 1. While this ansatz is not wholly correct, one can notice that $e(W) -> 0$ as $tau -> 0$. But there is quite an easy fix to this situation, inspired by @MinTriangle3, by adding some podes which soak up the remaining edge density while creating no triangles.

This heuristic directly translates our structural embedding problem into a Linear Program. To find the optimal power-law exponent for $T_(max)^(G)$, we must minimize the exponent of the $G$-density subject to the constraint that no triangle exceeds the $tau^(1)$ budget. This optimal exponent is exactly the graph parameter $alpha(G)$.

#definition[
  Let $alpha: cal(G) -> RR_(>0)$ where $ alpha(G) := min{sum_(v in V(G))^() x_(v) + sum_(e in E)^() y_(e)} \ $ where $x: V(G) -> RR_(>=0)$, $y: E(G) -> RR_(>=0)$ and for all triangles $tau$ in $G$, $ sum_(v in V(tau))^() x_(v) + sum_(e in E(tau))^() y_(e) >= 1. $
]

The heuristic above motivates $alpha(G)$ as the smallest exponent attainable by a construction of this type; it is not a priori clear that no other construction achieves a smaller exponent, or indeed that the scaling $Theta(tau^(alpha(G)))$ is achieved at all. Establishing both, that $alpha(G)$ is the exponent, not merely a candidate, is the the content of the main theorem of this thesis, proved in the sections that follow.

#definition[
  The dual LP to $alpha(G)$ is defined as follows:

  $ alpha^(*)(G) := max{sum_(T in cal(T)(G))^() z_(T)} $ where $z: cal(T)(G) -> RR_(>=0)$ and for all vertices $v in V(G)$ and for all $e in E(G)$ $ sum_(T in cal(T)(G) \
  T in.rev v)^() z_(T) & <= 1 \
  sum_(T in cal(T)(G) \
  T in.rev e)^() z_(T) & <= 1 \ $
]

With the primal and dual linear programs established, we prove a brief but essential structural property of the optimal primal solution $(x^(*), y^(*))$. In our lower bound, constructions later in the thesis, we will build graphons parameterized exactly by these optimal LP variables. To ensure our constructed graphon utilizes the full triangle budget, meaning it achieves a triangle density of exactly $Theta(tau)$ rather than something asymptotically smaller, we must guarentee that the primal optimal solution doesn't loosely over-satisfy all of its constraints. The following lemma guarentees that at least one triangle constraint is strictly tight, effectively anchoring our construction to the $tau$ boundary.

#lemma[
  Let $G$ be a simple graph where $cal(T)(G) != emptyset$. Let $x^*$ and $y^*$ be the vertex and edge weight functions which are the solutions to $alpha(G)$. There exists a $T in cal(T)(G)$ such that $ sum_(v in V(T))^() x_(v)^(*) + sum_(e in E(T))^() y_(e)^(*) = 1 $
]<TriangleTightness>
#proof[
  Assume the contrary that for all $T in cal(T)(G)$

  $ sum_(v in V(T))^() x_(v)^(*) + sum_(e in E(T))^() y_(e)^(*) > 1. $ Thus there exists a $delta > 0$ such that for all $T in cal(T)(G)$ $ sum_(v in V(T))^() x_(v)^(*) + sum_(e in E(T))^() y_(e)^(*) >= 1 + delta. $

  // Let $delta_(0)$ be the maximum such $delta$. Thus there exists some $T_(0) in cal(T)(G)$ such that $ sum_(v in V(T_(0)))^() x_(v)^(*) + sum_(e in E(T_(0)))^() y_(e) = 1 + delta_(0). $

  Fix some $T_(0) in cal(T)(G)$. Let $S = {x_(v)^(*) mid(|) v in V(T_(0))} union {y_(e)^(*) mid(|) e in E(T_(0))}$. Let $z = max S$ and $f$ be the object which gives $z$ (ie if $f$ is a vertex $z = x_(f)$ and if its an edge $z = y_(f)$).

  $ (abs(V(G)) + abs(E(G)))z & >= sum_(v in V(T_(0)))^() x_(v)^(*) + sum_(e in E(T_(0)))^() y_(e)^(*) >= 1 + delta. $ Thus $ z >= (1 + delta)/(abs(V(G)) + abs(E(G))) > 0 $

  Let $delta prime = min(z, delta)$. Let $(tilde(x), tilde(y))$ be identical to $(x^(*), y^*)$ except at $f$ where $tilde(z)_(f) = z_(f) - delta prime$. The only sums which change are the sums which $f$ is a part of. For all $T in cal(T)(G)$ such that $f in V(T)$ or $f in E(T)$ ,

  $
    sum_(i in V(T))^() tilde(x_(i)) + sum_(e in E(T))^() y_(e)^(*) &= sum_(i in V(T))^() x_(i)^(*) + sum_(e in E(T))^() y_(e)^(*) - delta prime \
    &>= 1 + delta - delta prime >= 1
  $

  because $delta >= delta prime$ by definition. Finally,
  $
    sum_(v in V(G))^() tilde(x)_(v) + sum_(e in E(G))^() y_(e)^(*) &= sum_(v in V(G))^() x_(v)^(*) + sum_(e in E(G))^() y_(e)^(*) - delta prime \
    &= alpha(G) - delta prime < alpha(G)
  $

  contradicting optimality.
]

We conclude this section by bridging our algebraic parameter with our graph-theoretic decomposition. Because the bridge edges $B$  and leftover vertices $L$  of our triangle-spanning decomposition do not participate in any triangles of G, their corresponding variables $x_(v)$
and $y_(e)$
do not appear in any constraints of the primal LP for $alpha(G)$

#proposition[
  Let $G$ be a simple graph. Let $(cal(C), B, L)$ be its triangle spanning decomposition. Then
  $ alpha(G) = sum_(C in cal(C)) alpha(C) $
]<DecomposeLP>
#proof[
  Recall $alpha(G)$ is the optimal value of

  $ sum_(v in V(G))^() x_(v) + sum_(e in E)^() y_(e) $ subject to $x_(v), y_(e) >= 0$ and for all triangles $T in cal(T)(G),$ $ sum_(v in V(T))^() x_(v) + sum_(e in E(T))^() y_(e) >= 1. $
  By @trispandecomp, no vertex of $L$ lies in triangle, so for every $v in L$, $x_(v)$ appears in no constraint. Hence at the optimum we may take $x_(v) = 0$. By a symmetric argument, $y_(e) = 0$ for all $e in B$ at the optimum. Thus $alpha(G)$ equals the optimal value of

  $ sum_(v in V(cal(C)))^() x_(v) + sum_(e in E(cal(C)))^() y_(e) $

  subject to the same constraints. By @trispandecomp, because $V(cal(C))$ and $E(cal(C))$ can be partitioned into ${V(C)}_(C in cal(C))$ and ${E(C)}_(C in cal(C))$,

  $
    sum_(v in V(cal(C)))^() x_(v) + sum_(e in E(cal(C)))^() y_(e) = sum_(C in cal(C))(sum_(v in V(C))^() x_(v) + sum_(e in E(C))^() y_(e)).
  $

  Moreover, every triangle $T in cal(T)(G)$ lives entirely within a unique $C in cal(C)$. Conversely for all $C in cal(C)$, every triangle in $C$ is a triangle in $G$. So the constraint set decouples: the constraints involving variables from a fixed $C in cal(C)$ are exactly the triangle constraints of $cal(T)(C)$, and no constraint mixes variables from different components. Hence the LP seperates into a sum of $n$ independent sub-LPs, one per component, and $ alpha(G) &= sum_(C in cal(C)) min{sum_(v in V(C))^() x_(v) + sum_(e in E(C))^() y_(e) mid(|) x, y >= 0, (x, y) "feasible"}\
  &= sum_(C in cal(C)) alpha(C) $
]


= Upper Bound for Triangle Spanning Graphs
<TriangleSpanningGeneral>

In this section, we will prove the upper bound holds for triangle spanning graphs.

#proposition[
  Let $G$ be a triangle spanning graph, and let $V = abs(V(G))$. Then for all $(e, tau) in cal(R)$, $ T_(max)^(G)(epsilon, tau) <= tau^(alpha(G)). $
  Furthermore, for $T_(max)^(G)(epsilon, tau) = O(tau^(alpha(G)))$ for fixed $epsilon in (0, (1)/(2)]$ and $tau -> 0$.
]<infiniteUpper>
#proof[
  Fix any $W in tilde(cal(W))(epsilon, tau)$ where $(epsilon, tau) in R$.
  Let ${z_(tau)^(*)}_(tau in cal(T)(G))$ be optimal solution to the dual LP to $alpha(G)$. By Strong Duality, $alpha(G) = sum_(tau in cal(T)(G))^() z_(tau)^(*).$ For $x in [0, 1]^(V)$ and for all $T = {i, j, k} in cal(T)(G)$, let $ x_(T) := vec(x_(i), x_(j), x_(j)). $

  Let $W_(triangle): [0, 1]^(3) -> [0, 1]$ where $ W_(triangle)(x_(1), x_(2), x_(3)) = W(x_(1), x_(2)) W(x_(2), x_(3)) W(x_(1), x_(3)). $ By the Dual LP, $sum_(T in.rev e)^() z_(e)^(*) in [0, 1]$ for all edges $e in E(G)$. Since $W <= 1$, raising $W$ to a exponent in $[0, 1]$ can only increase the value. Thus $ product_(i j in E(G)) W(x_(i), x_(j)) <= product_(i j in E(G)) W(x_(i), x_(j))^(sum_(T in.rev i j) z_(T)^(*)) = product_(T in cal(T)(G)) W_(triangle)(x_(T))^(z_(T)^(*)), $

  where the last equality comes from grouping all the edges into their respective triangles. Thus,

  $
    t(G, W) <= integral_([0, 1]^(V)) product_(T in cal(T)(G))W_(triangle)(x_(T))^(z_(T)^(*)) dif arrow(x)
  $

  For all $T = {i, j, k} in cal(T)(G)$, let $S_(T) = T$, $p_(T) = (z_(T)^(*))^(-1)$, and $f_(T) = W_(triangle)(x_(T))^(z_(T))$. Thus by the #link(<FinnerCorollary>)[Corollary to Finner's Inequality],

  $
    t(G, W) & <= integral_([0, 1]^(V)) product_(T in cal(T)(G)) f_(T)(x_(T)) dif arrow(x) \
    & <=product_(T in cal(T)(G)) norm(f_(T))_(p_(T)) \
    & = product_(T in cal(T)(G)) (integral_([0, 1]^(3)) (W_(triangle)(x_(1), x_(2), x_(3))^(z_(T)^(*)))^(p_(T)) dif arrow(x))^(p_(T)) \
    & = product_(T in cal(T)(G)) (integral_([0, 1]^(3)) W_(triangle)(x_(1), x_(2), x_(3)) dif arrow(x))^(z_(T)^(*)) \
    &= product_(T in cal(T)(G)) t(W)^(z_(T)^*) \
    & = t(W)^(sum_(T in cal(T)(G))^() z_(T)^(*)) \
    & = t(W)^(alpha(G)) <= tau^(alpha(G))
  $


  Since $t(G, W) <= tau^(alpha(G))$ is true for all $W in tilde(cal(W))(epsilon, tau)$, $ T_(max)^(G)(epsilon, tau) <= tau^(alpha(G)). $

  This implies, by definition, $T_(max)^(G)(epsilon, tau) = O(tau^(alpha(G)))$ for fixed $epsilon in (0, (1)/(2)]$ and $tau -> 0$.
]


= Main Result
<GeneralSquared>

Putting all the results together of the last few sections, we can finally prove that the upper bound holds for all simple graphs.

#proposition[
  Let $G$ be simple graph, where $V = abs(V(G))$, and $(cal(C), B, L)$ is its triangle spanning decomposition. Then for all $(e, tau) in cal(R)$, $ T_(max)^(G)(epsilon, tau) <= tau^(alpha(G)). $
  Furthermore, for $T_(max)^(G)(epsilon, tau) = O(tau^(alpha(G)))$ for fixed $epsilon in (0, (1)/(2)]$ and $tau -> 0$.
]<generalUpper>
#proof[
  Let $W$ be a graphon where $e(W) = e$ and $t(W) = tau$. By definition $W <= 1$, so we have the following for $arrow(x) in [0, 1]^(V)$

  $
    product_({i, j} in E(G)) W(x_(i), x_(j)) & <= product_({i, j} in E(cal(C))) W(x_(i), x_(j)) \
                                             & = product_(C in cal(C)) product_({i, j} in E(C)) W(x_(i), x_(j)),
  $

  where the last equality comes from @trispandecomp. Thus $ t(G, W)<= integral_([0, 1]^(V)) product_(C in cal(C)) product_({i, j} in E(C)) W(x_(i), x_(j)) dif arrow(x). $

  Again note by @trispandecomp, for all $v in L$ their corresponding variable $x_(v)$ occurs nowhere in the integrand. By the same lemma, since $cal(C)$ forms a partition of $V(cal(C))$ each vertex in $V(cal(C))$ appears in one and only one maximal triangle spanning component. Thus,

  $ t(G, W) & <= integral_([0, 1]^(V - abs(L))) product_(C in cal(C)) product_({i, j} in E(C)) W(x_(i), x_(j)) dif arrow(x) \
          & = product_(C in cal(C)) integral_([0, 1]^(abs(V(C)) )) product_({i, j} in E(C)) W(x_(i), x_(j)) dif arrow(x) \
          & = product_(C in cal(C)) t(C, W) \
          & <= product_(C in cal(C)) T_(max)^(C)(epsilon, tau) <= product_(C in cal(C)) tau^(alpha(C_(i))) $ where the last inequality comes from @infiniteUpper. Thus
  $ t(G, W) <= tau^(sum_(C in cal(C))^() alpha(C)) = tau^(alpha(G)) $
  where the equality $alpha(G) = sum_(C in cal(C))^() alpha(C)$  comes from @DecomposeLP. Thus, if for all valid graphons $W$, $t(G, W) <= tau^(alpha(G))$ then $ T_(max)^(G)(epsilon, tau) <= tau^(alpha(G)) $
  and $ T_(max)^(G)(epsilon, tau) = O(tau^(alpha(G))) $
  for fixed $epsilon in (0, (1)/(2)]$ and $tau -> 0$.
]

Having established the upper bound, it remains to show that this bound is tight. We demonstrate this by explicitly constructing a family of graphons $W_(tau) in tilde(cal(W))(epsilon, tau)$ that saturates the upper bound as $tau -> 0$. We achieve this through a multipodal graphon construction  parameterized by the optimal primal LP solutions. @GeneralConstructionLessHalf does it for $epsilon in (0, (1)/(2))$, while @GeneralConstructionHalf addresses the boundary case $epsilon = (1)/(2)$.

#definition[
  $ T_(max, N)^(G) := max{t(G, W) mid(|) W in tilde(cal(W))(N; epsilon, tau)} $
]

#proposition[
  Let $G$ simple graph with $cal(T)(G) != emptyset$. Let $V = abs(V(G))$ and $(cal(C), B, L)$ is its triangle spanning decomposition.

  $ T_(max, N)^(G)(epsilon, tau) = Omega(tau^(alpha(G))) $
  for fixed $epsilon in (0, 0.5)$ and fixed $N >= V + 2$ and $tau ->0$.
]<GeneralConstructionLessHalf>
#proof[
  Let $epsilon in (0, 0.5)$ be fixed and let $tau >0$ be the parameter in $T_(max, N )^(G)(epsilon, tau)$. Let $gamma = tau \/ 6abs(cal(T)(G))$.
  Let $n = abs(cal(C))$, thus $cal(C) = {C_(1), #sym.dots.h, C_(n)}$ through a bijection with $[n]$. Let $V_(C) = abs(V(cal(C)))$ and $V_(L) = abs(L)$.

  Let $B_(0), B_(1), B_(2)$ be a partition of $B$ where $B_(0)$ is the $L$-to-$L$ edges, $B_(1)$ are the $L"-to-"V(cal(C))$ edges, and $B_(2)$ are the $V(cal(C))"-to-"V(cal(C))$ edges.

  Let $(x^* , y^*)$ be optimal for $alpha(G)$, with the convention that $x^(*)(L) = {0}$ and $y^(*)(B) = {0}$ (optimal, since these variables appear in no triangle constraint).

  Fix any $a_(0) in (sqrt(epsilon \/ 2), 0.5 )$; this interval is nonempty because $epsilon < 0.5$.

  Let $nu in (0, nu_(max )]$ where  $ nu_(max) := min((1 - 2 a_(0))/(V_(L)), sqrt((epsilon)/(2 abs(B_(0)) + 1 ))). $

  Let $ sigma(gamma) := sum_(v in V(cal(C)))^() gamma^(x_(i)^(*)). $ Note as $gamma -> 0$, $sigma(gamma) -> 0$.

  Let ${S_(i)}_(i = 1)^(N)$ be pairwise disjoint measurable sets in $[0, 1]$ where:

  $
    mu(S_i) = cases(gamma^(x^*_(i)) "if" i in V(cal(C)), nu "if" i in L, a(N) "if" i in {V + 1, V + 2}, b(gamma) "otherwise")
  $

  where $     a(N) & := cases(a_(0) + (1)/(2)(1 - 2a_(0) - sigma(gamma) - V_(L) nu) "if" N = V + 2, a_(0) "otherwise") \
  b(gamma) & := (1 - 2 a_(0) - sigma(gamma) - V_(L) nu)/(N - V - 2) "when" (N >= V + 2) $

  Since $gamma -> 0 => sigma(gamma) -> 0$ and $2 a_(0) + V_(L) nu > 1$, there exists a $gamma_(0) > 0$ such that $b(gamma) > 0$ for all $gamma in (0, gamma_(0)]$, and thus a valid measure.
  Furthermore, by construction $ sum_(i = 1)^(N)mu(S_(i)) & = 1 $


  So ${S_(i)}_(i = 1)^(N)$ is a partition of $[0, 1]$.

  Let $     R(gamma) & := 2 sum_(i j in E(cal(C)))^() gamma^(x_(i)^(*) + x_(j)^(*) + y_(i j)^(*)), \
         Q_(0) & := 2 sum_(e in B_(0))^() nu^(2) = 2 abs(B_(0)) nu^(2), \
  Q_(1)(gamma) & := 2 sum_({i, j} in B_(1))^() nu gamma^(x^*_("non"-V_(0))) \
  Q_(2)(gamma) & := 2sum_({i, j} in B_(2))^() gamma^(y_(i j)^(*)) \
   beta(gamma) & = (epsilon - R(gamma) - Q_(0) - Q_(1)(gamma) - Q_(2)(gamma))/(2 mu(S_(V + 1)) mu(S_(V+2))) \ $

  Let $w: [N]^(2) -> [0, 1]$ where $ w_(i j) = cases(
    gamma^(y_(i j)^(*)) "if" {i, j} in E(cal(C)),
    1 "if" {i, j} in B,
    beta(gamma) "if" {i, j} = {V + 1, V + 2},
    0 "otherwise"
  ). $


  As $gamma -> 0$, $ beta(gamma) -> (epsilon - Q_(0))/(2 a_(0)^2) = (epsilon - 2 abs(B_(0)) nu^(2))/(2 a_(0)^2) > 0. $ Since $a_(0)^(2) > epsilon \/ 2$, the limit is less than 1. Hence there exists a $gamma_(1) in (0, gamma_(0)]$ such that $beta(gamma) in (0, 1)$ for all $gamma in (0, gamma_(1))$.

  Let $W$ be an N-podal graphon with parts ${S_(i)}_(i= 1)^(N)$ and edge weights $w_(i j)$.

  $
    e(W) & = sum_(i, j in [N])^() mu(S_(i)) mu(S_(j)) w_(i j) \
         & = 2 beta(gamma) mu(S_(V + 1)) mu(S_(V + 2)) + R(gamma) + Q_(0) + Q_(1)(gamma) + Q_(2)(gamma) \
         & = epsilon
  $

  Thus $W$ has the correct edge density. For the triangle density,


  $ t(W_(0)) & = sum_(i, j, k in [N])^() mu(S_(i)) mu(S_(j)) mu(S_(k)) w_(i j) w_(i k) w_(j k). $

  The only way that $w_(i j), w_(i k), w_(j k)$ are all nonzero is if ${i, j, k} in cal(T)(G)$. Triangles of $G$ are contained in components $C_(l) in cal(C)$, so all three edges must be in $E(C_(l)) subset E(cal(C)) subset$. No edge in $B$ may participate. Thus

  $
    t(W_(0)) & = 6 sum_({i, j, k} in cal(T)(G))^() mu(S_(i)) mu(S_(j)) mu(S_(k)) w_(i j) w_(i k) w_(j k) \
             & = 6 sum_({i, j, k} in cal(T)(G))^() gamma^(x_(i) + x_(j) + x_(k)) gamma^(y_(i j) + y_(j k) + y_(i k)) \
             & = 6 sum_(T in cal(T)(G))^() gamma^(sum_(i in V(T))^() x_(i) + sum_(e in E(T))^() y_(e)) \
             & = 6 sum_(T in cal(T)(G))^() gamma^(sum_(i in V(T))^() x_(i) + sum_(e in E(T))^() y_(e)) \
  $

  By the feasibility constraint on $alpha(G)$, $forall T in cal(T)$ $ sum_(i in V(T))^() x_(i)^(*) + sum_(e in E(T))^() y_(e)^(*) >= 1. $ Since $gamma -> 0 => gamma < 1$, that means for all $T in cal(T)$, $ gamma^(sum_(i in V(T))^() x_(i) + sum_(e in E(T))^() y_(e)) <= gamma^(1) $

  Thus $ t(W_(0)) <= 6 abs(cal(T)(G)) gamma = tau. $
  Furthermore by @TriangleTightness, there exists a $T_(0) in cal(T)(G)$ such that $ sum_(v in V(T_(0)))^() x_(v) + sum_(e in E(T_(0)))^() y_(e) = 1. $ Since all terms in the sum of $t(W)$ are positive, $t(W) >= 6 tau = abs(cal(T)(G))^(-1) tau$. Thus $t(W) = Theta(tau)$.

  Now for $t(G, W)$:

  $
     t(G, W) & = sum_(phi: V(G) -> [N])^() Pi_(phi) \
    Pi_(phi) & = (product_(v in V(G))^() mu(S_(phi(v))))(product_(e in E(G)) w_(phi(e)))
  $

  For $Pi_(phi)$ to be nonzero, every edge $e in E(G)$ must satisfy $w_(phi(e)) != 0$, meaning $phi(e) in E(G)$ or $phi(e) in {V + 1, V+ 2}$.

  Suppose for contradiction some $e = {u, v} in E(G)$ has $phi(e) = {V + 1, V+ 2}$. Without loss of generality, $phi(u) = V + 1$. Since $G$ is triangle spanning, $u$ lies in some triangle $T = {u, v, w} in cal(T)(G)$ with edges $e$, $f = {u, w}$, and $g = {v, w}$ in $E(G)$. For $Pi_(phi) != 0$, we need $w_(phi(f)) != 0$. Since $phi(u) = V + 1$ and the only $k$ such that $w_(V + 1, k) != 0$ is $k = V + 2$, we must have $phi(w) = V + 2$. Symmetrically, $w_(phi(g)) != 0$ forces $phi(w) = V + 1$. These are incompatible, so $Pi_(phi) != 0$.

  Hence every $phi$ where $Pi_(phi)$ satisfies $phi(E(G)) subset E(G)$, $phi(V(G)) subset [V]$. So,

  $
    t(G, W_(0)) & = sum_(phi: V(G) -> [V])^() Pi_(phi)
  $

  Take $phi = id$: The identity map satisfies $id(E(G)) subset E(G)$ so it contributes a nonzero term.

  $
    Pi_(id) & = (product_(v in V(G)) mu(S_(v))) (product_(e in E(G)) w_(e)) \
            & = (product_(v in V(G)) gamma^(x^(*)_(v))) (product_(e in E(G)) gamma^(y_(e)^(*))) \
            & = gamma^(sum_(v in V(G))^() x^(*)_(v) + sum_(e in E(G))^() y^(*)_(e)) = gamma^(alpha(G))
  $


  Since all $Pi_(phi) >= 0$, $ t(G, W) >= Pi_(id) = gamma^(alpha(G)) = ((tau)/(6 abs(cal(T)(G)) ))^(alpha(G)) = (1)/((6abs(cal(T)(G)))^(alpha(G)) ) tau^(alpha(G)) $



  Since $W$ is a valid $N$-podal graphon with $e(W) = epsilon$ and $t(W) <= tau$, so $W$ is feasible in the definition of $T^(G)_(max, N)(epsilon, tau)$. Therefore,
  $
    T_(max, N)^(G)(e, tau) >= t(G, W) >= (1)/((6abs(cal(T)(G)))^(alpha(G)) ) tau^(alpha(G)),
  $

  giving $T^(G)_(max, N)(epsilon, tau) = Omega(tau^(alpha(G)))$ as $tau -> 0$.
]

#proposition[
  Let $G$ simple graph with $cal(T)(G) != emptyset$. Let $V = abs(V(G))$ and $(cal(C), B, L)$ is its triangle spanning decomposition.

  $ T_(max, V + 2)^(G)((1)/(2), tau) = Omega(tau^(alpha(G))) $
  for $tau ->0$.
]<GeneralConstructionHalf>
#proof[
  Let $tau >0$ be the parameter in $T_(max, N )^(G)((1)/(2), tau)$. Let $gamma = tau \/ 6abs(cal(T)(G))$.
  Let $n = abs(cal(C))$, thus $cal(C) = {C_(1), #sym.dots.h, C_(n)}$ through a bijection with $[n]$. Let $V_(C) = abs(V(cal(C)))$ and $V_(L) = abs(L)$.

  Let $B_(0), B_(1), B_(2)$ be a partition of $B$ where $B_(0)$ is the $L$-to-$L$ edges, $B_(1)$ are the $L"-to-"V(cal(C))$ edges, and $B_(2)$ are the $V(cal(C))"-to-"V(cal(C))$ edges.

  Let $(x^* , y^*)$ be optimal for $alpha(G)$, with the convention that $x^(*)(L) = {0}$ and $y^(*)(B) = {0}$ (optimal, since these variables appear in no triangle constraint).

  Let $nu in (0, nu_(max )]$ where  $ nu_(max) := min((1)/(V_(L) + 1), sqrt((1)/(4 abs(B_(0)) + 1 ))). $

  Let $ sigma(gamma) := sum_(v in V(cal(C)))^() gamma^(x_(i)^(*)). $ Note as $gamma -> 0$, $sigma(gamma) -> 0$.

  Let ${S_(i)}_(i = 1)^(N)$ be pairwise disjoint measurable sets in $[0, 1]$ where:

  $
    mu(S_i) = cases(gamma^(x^*_(i)) "if" i in V(cal(C)), nu "if" i in L, a(gamma) "if" i in {V + 1, V + 2})
  $

  where $ a(gamma) & := (1)/(2)(1 - V_(L) nu - sigma(gamma)) $

  Since $gamma -> 0 => sigma(gamma) -> 0$ and $1 - V_(L) nu > 0$, there exists a $gamma_(0) > 0$ such that $b(gamma) > 0$ for all $gamma in (0, gamma_(0)]$, and thus a valid measure.
  Furthermore, by construction $ sum_(i = 1)^(N)mu(S_(i)) & = 1 $


  So ${S_(i)}_(i = 1)^(N)$ is a partition of $[0, 1]$. Let $     R(gamma) & := 2 sum_(i j in E(cal(C)))^() gamma^(x_(i)^(*) + x_(j)^(*) + y_(i j)^(*)), \
         Q_(0) & := 2 sum_(e in B_(0))^() nu^(2) = 2 abs(B_(0)) nu^(2), \
  Q_(1)(gamma) & := 2 sum_({i, j} in B_(1))^() nu gamma^(x^*_("non"-V_(0))) \
  Q_(2)(gamma) & := 2sum_({i, j} in B_(2))^() gamma^(y_(i j)^(*)) \
   beta(gamma) & = (0.5 - R(gamma) - Q_(0) - Q_(1)(gamma) - Q_(2)(gamma))/(2 mu(S_(V + 1)) mu(S_(V+2))) \ $

  Let $w: [N]^(2) -> [0, 1]$ where $ w_(i j) = cases(
    gamma^(y_(i j)^(*)) "if" {i, j} in E(cal(C)),
    1 "if" {i, j} in B,
    beta(gamma) "if" {i, j} = {V + 1, V + 2},
  ). $


  As $gamma -> 0$, $ beta(gamma) -> (0.5 - Q_(0))/(2 a_(0)^2) = (0.5 - 2 abs(B_(0)) nu^(2))/(2 a_(0)^2) > 0. $ Since $a_(0)^(2) > epsilon \/ 2$, the limit is less than 1. Hence there exists a $gamma_(1) in (0, gamma_(0)]$ such that $beta(gamma) in (0, 1)$ for all $gamma in (0, gamma_(1))$.

  Let $W$ be an N-podal graphon with parts ${S_(i)}_(i= 1)^(N)$ and edge weights $w_(i j)$.

  $
    e(W) & = sum_(i, j in [N])^() mu(S_(i)) mu(S_(j)) w_(i j) \
         & = 2 beta(gamma) mu(S_(V + 1)) mu(S_(V + 2)) + R(gamma) + Q_(0) + Q_(1)(gamma) + Q_(2)(gamma) \
         & = 0.5
  $

  Thus $W$ has the correct edge density. For $t(W) <= tau$ and $ t(G, W) >= (1)/((6 abs(cal(T)(G)) )^(alpha(G))) tau^(alpha(G)), $ the proof follows identically to @GeneralConstructionLessHalf.
  Since $W$ is a valid $(V + 2)$-podal graphon with $e(W) = 0.5$ and $t(W) <= tau$, so $W$ is feasible in the definition of $T^(G)_(max, V + 2)(epsilon, tau)$. Therefore,
  $
    T_(max, V + 2)^(G)((1)/(2), tau) >= t(G, W) >= (1)/((6abs(cal(T)(G)))^(alpha(G)) ) tau^(alpha(G)),
  $

  giving $T^(G)_(max, V + 2)((1)/(2), tau) = Omega(tau^(alpha(G)))$ as $tau -> 0$.
]


#theorem[
  $G$ be a simple graph where $cal(T)(G) != 0$. $ T_(max)^(G)(e, tau) = Theta(tau^(alpha(G))) $ for $.e in (0, 1/2]$ and $tau -> 0$.
]<MainTheorem>
#proof[
  By @GeneralConstructionLessHalf and @GeneralConstructionHalf, for $V = abs(V(G))$  $ T^(G)_(max, V + 2)(epsilon, tau) >= c_(1) tau^(alpha(G)). $ Since $ T^(G)_(max, V + 2)(epsilon, tau) <= T_(max)^(G)(epsilon, tau) => c_(1) tau^(alpha(G)) <= T_(max)^(G)(epsilon, tau). $

  Combining this with @generalUpper, we have $ T_(max)^(G)(epsilon, tau) = Theta(tau^(alpha(G))) $
]

= Examples
<Examples>


= Conclusion and Future Directions
<NextSteps>
This thesis identifies the exponent governing the asymptotic behavior of $T_(max)^(G)(epsilon, tau)$ as $tau -> 0$ for $epsilon in (0, (1)/(2)]$: for every simple graph $G$, $T_(max)^(G)(epsilon, tau) = Theta(tau^(alpha(G)))$, where $alpha(G)$ is the optimal value of an explicit linear program indexed by the triangles of $G$. The upper bound is obtained by combining Finner's generalized Hölder inequality with strong duality applied $alpha(G)$. The lower bound is  obtained by an explicit step-graphon construction guided by the LP optimizer. Several natural questions remain open, and we conclude by describing three directions in which the present work suggests further investigation.

== Sharpening the constants
The bounds in this thesis determine the constant $alpha(G)$ exactly, but leave a room between the upper and lower implicit constants. The upper bound, obtained by Finner's Inequality, gives $T^(G)_(max)(epsilon, tau) <= tau^(alpha(G))$. The lower bound construction gives $T^(G)_(max)(epsilon, tau) >= (6 abs(cal(T)(G)) )^(-alpha(G)) tau^(alpha(G))$. The $(6 abs(cal(T)(G)) )^(alpha(G))$ is already significant for small graphs and quickly grows as the complexity of the graph grows, so there is a significant gap between the upper and lower bound constants.

The quantity of interest is the true asymptotic constant,

$ C(G, epsilon) := lim_(tau -> 0)(T_(max)^(G)(epsilon, tau))/(tau^(alpha(G))), $ when the limit exists, or the associated lim sup or lim inf otherwise. Identifying $C(G, epsilon)$ (or even showing the limit exists) would involve solving a variational problem to find the extremizing family of graphons as $tau -> 0$, not merely identifying the scaling exponent. Neither bound in this thesis is likely tight:
- Upper Bound: Finner's Inequality only achieves equality when each factor decomposes into a product of single variable functions, which fails for nontrivial graphons.
- Lower Bound: The multipodal construction is specific enough that a more refined family of extremizers likely exists.
One also suspects that $C(G, epsilon)$ has a interesting dependence on the edge density, which the current bounds don't detect.

== Behavior in other regimes of the Razborov triangle.
The results of this thesis pin down the asymptotic exponent of $T^(G)_max (epsilon, tau)$ only on the lower boundary of the Razborov triangle, namely as $tau -> 0$ and $epsilon in (0, (1)/(2)]$ fixed. Elsewhere in the feasible region, the scaling is less well understood. By @generalUpper, we know that $TG(epsilon, tau) <= tau^(alpha(G))$ for all $(epsilon, tau) in cal(R)$. The matching lower bound, however, is only proven for $epsilon in (0, (1)/(2)]$ as $tau -> 0$. In other regimes of the Razborov triangle, the exponent governing $TG$ is not understood. Furthermore, in some cases, it is almost certainly not $alpha(G)$.

=== Near the Upper Boundary $tau = epsilon^((3)/(2))$
The extremizer of the triangle density is the unique graphon $W = bb(1)_([0, sqrt(epsilon)]^(2))$ (@TriangleMax), for which $t(G, W) = epsilon^(abs(E(G)))$. Hence $TG(epsilon, epsilon^((3)/(2))) = epsilon^(abs(E(G)) )$, which can be compared to the upper bound $epsilon^(3 alpha(G) \/ 2)$ evaluated at the boundary. For most $G$ the two values differ, and since the upper bound is not tight at this corner, the true scaling $TG(epsilon, tau)$ as $tau -> epsilon^((3)/(2))$ from below is governed by a different exponent than $alpha(G)$. For this purpose the better function to study is $ T_("gap")^(G)(epsilon, eta) = TG(epsilon, epsilon^((3)/(2)) - eta) - epsilon^(abs(E(G))). $

=== Near lower boundary of $cal(R)$ as $epsilon > (1)/(2)$
Here the triangle free region disappears: for edge density above $(1)/(2)$, every graphon has strictly positive triangle density, with minimum given by @TriangleMin1, achieved by the constructions of @TriangleMin2. The construction resemble blow-ups of complete $k$-partite graphs with one of the parts, which will be called the special part, also having a triangle free internal structure. Starting from such a minimum-triangle graphon, adding an infinitesimal amount of extra triangle density cooresponds to adding edges to the special part to form triangles. This doesn't just cause $G$ to pop out from within the special part, but we may get the lions share of the $G$-density from the interactions of the special part with the rest of the $k - 1$ parts. Thus for every triangle we create we may create many copies of $G$. Again like the case with the upper boundary, the $TG(epsilon, t_(min)(epsilon))$ term will dominate $TG(epsilon, tau)$. Thus the function to study is,

$ T_("gap")^(G)(epsilon, eta) = TG(epsilon, t_(min)(epsilon) + eta) - TG(epsilon, t_(min)(epsilon)). $

== The opposite problem $TM$ and the Triangle Removal Lemma

A natural companion to the problem studied in this thesis is the opposite extremal question:
$ TM(epsilon, tau) := min{t(G, W) mid(|) W in tilde(cal(W))(epsilon, tau)} $
This is well-posed by the same compactness argument used for $TG$, and understanding its behavior as $tau -> 0$ is open.

For the case $G = D$ (the diamond graph or $K_(4)$ with one edge removed), $TD$ is of particular interest because of its connection to the Szemerédi-Ruzsa Triangle Removal Lemma. This lemma asserts that any graph with few triangles can be made triangle-free by removing a correspondingly small fraction of edges. In the language of the graphons, this is governed by the function: $ c(tau) = sup_(W: t(W) <= tau)(inf_(U <= W \ t(U) = 0) norm(W - U)_(1) ), $
intuitively this function quantifies the maximum edge mass we have to remove from a graphon with triangle density at most $tau$ to guarentee triangle-freeness. Historically, proofs relying on Szemerédi's Regularity Lemma yield bounds for $c(tau)$ that decay at an inverse tower-exponential rate as $tau -> 0$ @conlon2013graph.

A simple variational argument based on Cauchy-Schwarz applied to functional derivatives of $t(D, dot)$ and $t(dot)$ on triangle free graphons, connects understanding $c(tau)$ to the problem of understanding $TD$, and we get the following inequality

$ t(D, W) >= t(W)^(2)/(9c(t(W))) "near" tau = 0. $

Thus $ TD(epsilon, tau) >= (tau^(2))/(9c(tau)) => c(tau) >= (tau^(2))/(9TD(epsilon, tau)) $

Thus understanding the order of $TD(epsilon, tau)$ for fixed $epsilon$ and $tau -> 0$, will give us information on the asymptotics of $c(tau)$. Understanding the asymptotics of $c(tau)$ is major a topic of study in extremal combinatorics currently.



#bibliography("refs.bib", style: { "springer-mathphys" }, title: "References")
