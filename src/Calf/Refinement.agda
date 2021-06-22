{-# OPTIONS --prop --rewriting #-}

open import Calf.CostMonoid

module Calf.Refinement (costMonoid : CostMonoid) where

open CostMonoid costMonoid

open import Calf.Prelude
open import Calf.Metalanguage
open import Calf.Step (OrderedMonoid.monoid orderedMonoid)
open import Calf.PhaseDistinction orderedMonoid
open import Calf.Upper orderedMonoid
open import Calf.Eq
open import Calf.BoundedFunction orderedMonoid

open import Calf.Types.Sum

open import Relation.Binary.PropositionalEquality as P
open import Function using (const)

open iso

ub/ret : ∀ {A a} → ub A (ret {A} a) zero
ub/ret {A} {a} = ub/intro {q = zero} a ≤-refl (ret {eq _ _ _} (eq/intro refl))

ub/step : ∀ {A e} (p q : ℂ) →
  ub A e q →
  ub A (step' (F A) p e) (p + q)
ub/step p q (ub/intro {q = q1} a h1 h2) with eq/ref h2
...                                              | refl =
   ub/intro {q = p + q1} a (+-monoʳ-≤ p h1) (ret {eq _ _ _} (eq/intro refl))

ub/bind : ∀ {A B : tp pos} {e : cmp (F A)} {f : val A → cmp (F B)}
  (p : ℂ) (q : val A → ℂ) →
  ub A e p →
  ((a : val A) → ub B (f a) (q a)) →
  ub B (bind {A} (F B) e f)
       (bind {A} (meta ℂ) e (λ a → p + q a))
ub/bind {f = f} p q (ub/intro {q = q1} a h1 h2) h3 with eq/ref h2
... | refl with h3 a
... | ub/intro {q = q2} b h4 h5 with (f a) | eq/ref h5
... | _ | refl =
  ub/intro {q = q1 + q2} b (+-mono-≤ h1 h4) (ret {eq _ _ _} (eq/intro refl))

ub/bind/const : ∀ {A B : tp pos} {e : cmp (F A)} {f : val A → cmp (F B)}
  (p q : ℂ) →
  ub A e p →
  ((a : val A) → ub B (f a) q) →
  ub B (bind {A} (F B) e f) (p + q)
ub/bind/const {f = f} p q (ub/intro {q = q1} a h1 h2) h3 with eq/ref h2
... | refl with h3 a
... | ub/intro {q = q2} b h4 h5 with (f a) | eq/ref h5
... | _ | refl =
  ub/intro {q = q1 + q2} b (+-mono-≤ h1 h4) (ret {eq _ _ _} (eq/intro refl))

ub/bind/const' : ∀ {A B : tp pos} {e : cmp (F A)} {f : val A → cmp (F B)}
  (p q : ℂ) → {r : ℂ} →
  p + q ≡ r →
  ub A e p →
  ((a : val A) → ub B (f a) q) →
  ub B (bind {A} (F B) e f) r
ub/bind/const' p q refl h₁ h₂ = ub/bind/const p q h₁ h₂

ub/sum/case/const/const : ∀ A B (C : val (sum A B) → tp pos) →
  (s : val (sum A B)) →
  (e0 : (a : val A) → cmp (F (C (inj₁ a)))) →
  (e1 : (b : val B) → cmp (F (C (inj₂ b)))) →
  (p : ℂ) →
  ((a : val A) → ub (C (inj₁ a)) (e0 a) p) →
  ((b : val B) → ub (C (inj₂ b)) (e1 b) p) →
  ub (C s) (sum/case A B (λ s → F (C s)) s e0 e1) p
ub/sum/case/const/const A B C s e0 e1 p h1 h2 = sum/case A B
  (λ s → meta (ub (C s) (sum/case A B (λ s₁ → F (C s₁)) s e0 e1) p)) s h1 h2
