# **calf**: A Cost-Aware Logical Framework

The **calf** language is a **c**ost-**a**ware **l**ogical **f**ramework for studying quantitative aspects of functional programs.

This repository contains the Agda implementation of **calf**, as well as some case studies of varying complexity.

## Installation

This implementation of **calf** has been tested using:
- Agda v2.6.2
- `agda-stdlib` v1.7

Installation instructions may be found in [`INSTALL.md`](./INSTALL.md).

## Language Implementation

### Cost Monoid Parameterization

**calf** is parameterized by a *cost monoid* `(ℂ, +, zero, ≤)`.
The formal definition, `CostMonoid`, is given in [`Calf.CostMonoid`](./src/Calf/CostMonoid.agda).
The definition of a *parallel cost monoid* `(ℂ, ⊕, 𝟘, ⊗, 𝟙, ≤)` is given, as well, as `ParCostMonoid`.

Some common cost monoids and parallel cost monoids are given in [`Calf.CostMonoids`](./src/Calf/CostMonoids.agda); for example, `ℕ-CostMonoid` simply tracks sequential cost.
Note that every `ParCostMonoid` induces a `CostMonoid` via the additive structure, `(ℂ, ⊕, 𝟘, ≤)`.

### Core Language

The language itself is implemented via the following files, which are given in a dependency-respecting order.

The following modules are not parameterized:
- [`Calf.Prelude`](./src/Calf/Prelude.agda) contains commonly-used definitions.
- [`Calf.Metalanguage`](./src/Calf/Metalanguage.agda) defines the basic Call-By-Push-Value (CBPV) language, using Agda `postulate`s and rewrite rules.
- [`Calf.PhaseDistinction`](./src/Calf/PhaseDistinction.agda) defines the phase distinction for extension, including the extensional open `ext`, the open modality `◯`, and the closed modality `●`.
- [`Calf.Noninterference`](./src/Calf/Noninterference.agda) gives theorems related to the phase distinction/noninterference.

The following modules are parameterized by a `CostMonoid`:
- [`Calf.Step`](./src/Calf/Step.agda) defines the `step` effect and gives the associated laws via rewrite rules.

The following modules are parameterized by a `ParCostMonoid`:
- [`Calf.ParMetalanguage`](./src/Calf/ParMetalanguage.agda) the (negative) parallel product `_&_`, whose cost is the `ParCostMonoid` product (i.e., `_⊗_`) of its components, as well as associated laws and lemmas.

### Types

In [`src/Calf/Types`](./src/Calf/Types), we provide commonly-used types.

The following modules are not parameterized:
- [`Calf.Types.Nat`](./src/Calf/Types/Nat.agda), [`Calf.Types.Unit`](./src/Calf/Types/Unit.agda), [`Calf.Types.Bool`](./src/Calf/Types/Bool.agda), [`Calf.Types.Sum`](./src/Calf/Types/Sum.agda), and [`Calf.Types.List`](./src/Calf/Types/List.agda) internalize the associated Agda types via `meta`.
  Notably, this means that their use does *not* incur cost.
- [`Calf.Types.Eq`](./src/Calf/Types/Eq.agda) defines the equality type.

The following modules are parameterized by a `CostMonoid`:
- [`Calf.Types.Bounded`](./src/Calf/Types/Bounded.agda) defines a record `IsBounded A e c` that contains a proof that the cost of `e` (of type `A`) is bounded by `c : ℂ`.
  Additionally, it provides lemmas for proving the boundedness of common forms of computations.
- [`Calf.Types.BoundedFunction`](./src/Calf/Types/BoundedFunction.agda) defines cost-bounded functions using `IsBounded`.
- [`Calf.Types.BigO`](./src/Calf/Types/BoundedFunction.agda) gives a definition of "big-O" asymptic bounds as a relaxation of `IsBounded`.

## Examples

We provide a variety of case studies in [`src/Examples`](./src/Examples).

## Sequential

### [`Id`](./src/Examples/Id.agda)
- The identity function on natural numbers, trivially (`Easy`) and via recursion (`Hard`).
- Upper bound and big-O proofs about `Easy.id` and `Hard.id`.
- A proof that `Easy.id` and `Hard.id` are extensionally equivalent, `easy≡hard : ◯ (Easy.id ≡ Hard.id)`.

### [`Gcd`](./src/Examples/Gcd.agda)
todo

### [`Queue`](./src/Examples/Queue.agda)
- An implementation of [front-back queues](https://en.wikipedia.org/wiki/Queue_(abstract_data_type)#Amortized_queue).
- Upper bounds on the cost of individual enqueue and dequeue operations.
- Amortized analysis of sequences of enqueue and dequeue operations.

## Parallel

### [`TreeSum`](./src/Examples/TreeSum.agda)
- A simple algorithm to sum the elements of a tree, incurring unit cost when performing each addition operation.
  At each node, the recursive calls are computed in parallel.
- Upper bounds on the cost of summing the elements of a tree, sequentially and in parallel (`size t` and `depth t`, respectively).

### [`Exp2`](./src/Examples/Exp2.agda)
- Two implementations of exponentiation by two: one which performs two identical recursive calls, and one which performs a single recursive call.
- Proofs of correctness of each implementation.
- Upper bounds on the sequential and parallel costs of each implementation.
  While the sequential cost is severely affected in the version with two recursive calls, the parallel cost is the same.

## Hybrid

### [`Sorting`](./src/Examples/Sorting.agda)
- In [`Examples.Sorting.Sequential`](./src/Examples/Sorting/Sequential.agda), we provide sequential implementations of insertion sort (`InsertionSort`) and merge sort (`MergeSort`), as well as a proof that they are equivalent, `isort≡msort : ◯ (ISort.sort ≡ MSort.sort)`.
- In [`Examples.Sorting.Parallel`](./src/Examples/Sorting/Parallel.agda), we provide three sorting algorithms: insertion sort (`InsertionSort`), a naïve parallelization of merge sort (`MergeSort`), and a sublinear parallel merge sort algorithm (`MergeSortPar`).
- In both cases, we give formal cost analyses `sort≤sort/cost/closed` which verify the expected (asymptotically tight) upper bounds on cost. These are relaxed to the more readable asymptotic bounds, `sort/asymptotic`.

## Miscellaneous

### [`CostEffect`](./src/Examples/CostEffect.agda)
todo?
