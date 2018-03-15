\begin{code}

{-# OPTIONS --without-K #-}

module Lecture3 where

import Lecture2
open Lecture2

data unit : U where
  star : unit
𝟙 = unit
ind-unit : {i : Level} {P : unit → UU i} → P star → ((x : unit) → P x)
ind-unit p star = p

data empty : U where
𝟘 = empty
ind-empty : {i : Level} {P : empty → UU i} → ((x : empty) → P x)
ind-empty ()

¬ : Type → Type
¬ A = A → empty

data coprod {i j : Level} (A : UU i) (B : UU j) : UU (i ⊔ j)  where
  inl : A → coprod A B
  inr : B → coprod A B

data Sigma {i j : Level} (A : UU i) (B : A → UU j) : UU (i ⊔ j) where
  dpair : (x : A) → (B x → Sigma A B)

Σ = Sigma

pr1 : {i j : Level} {A : UU i} {B : A → UU j} → Sigma A B → A
pr1 (dpair a b) = a

pr2 : {i j : Level} {A : UU i} {B : A → UU j} → (t : Sigma A B) → B (pr1 t)
pr2 (dpair a b) = b

prod : {i j : Level} (A : UU i) (B : UU j) → UU (i ⊔ j)
prod A B = Sigma A (λ a → B)

_×_ :  {i j : Level} (A : UU i) (B : UU j) → UU (i ⊔ j)
A × B = prod A B

pair : {i j : Level} {A : UU i} {B : UU j} → A → (B → prod A B)
pair a b = dpair a b

Fin : ℕ → U
Fin Nzero = empty
Fin (Nsucc n) = coprod (Fin n) unit

EqN : ℕ → (ℕ → U)
EqN Nzero Nzero = 𝟙
EqN Nzero (Nsucc n) = 𝟘
EqN (Nsucc m) Nzero = 𝟘
EqN (Nsucc m) (Nsucc n) = EqN m n

reflexive-EqN : (n : ℕ) → EqN n n
reflexive-EqN Nzero = star
reflexive-EqN (Nsucc n) = reflexive-EqN n

symmetric-EqN : (m n : ℕ) → EqN m n → EqN n m
symmetric-EqN Nzero Nzero t = t
symmetric-EqN Nzero (Nsucc n) t = t
symmetric-EqN (Nsucc n) Nzero t = t
symmetric-EqN (Nsucc m) (Nsucc n) t = symmetric-EqN m n t

transitive-EqN : (l m n : ℕ) → EqN l m → EqN m n → EqN l n
transitive-EqN Nzero Nzero Nzero s t = star
transitive-EqN (Nsucc n) Nzero Nzero s t = ind-empty s
transitive-EqN Nzero (Nsucc n) Nzero s t = ind-empty s
transitive-EqN Nzero Nzero (Nsucc n) s t = ind-empty t
transitive-EqN (Nsucc l) (Nsucc m) Nzero s t = ind-empty t
transitive-EqN (Nsucc l) Nzero (Nsucc n) s t = ind-empty s
transitive-EqN Nzero (Nsucc m) (Nsucc n) s t = ind-empty s
transitive-EqN (Nsucc l) (Nsucc m) (Nsucc n) s t = transitive-EqN l m n s t

-- Exercise 3.4
least-reflexive-EqN' : {i : Level} (n m : ℕ) (R : ℕ → ℕ → UU i) (ρ : (n : ℕ) → R n n) → EqN n m → R n m
least-reflexive-EqN' Nzero Nzero R ρ p = ρ Nzero
least-reflexive-EqN' Nzero (Nsucc m) R ρ = ind-empty
least-reflexive-EqN' (Nsucc n) Nzero R ρ = ind-empty
least-reflexive-EqN' (Nsucc n) (Nsucc m) R ρ = least-reflexive-EqN' n m (λ x y → R (Nsucc x) (Nsucc y)) (λ x → ρ (Nsucc x))

least-reflexive-EqN : {i : Level} {R : ℕ → ℕ → UU i} (ρ : (n : ℕ) → R n n) → (n m : ℕ) → EqN n m → R n m
least-reflexive-EqN ρ n m p = least-reflexive-EqN' n m _ ρ p

-- Exercise 3.5
preserve_EqN : (f : ℕ → ℕ) (n m : ℕ) → (EqN n m) → (EqN (f n) (f m))
preserve_EqN f = least-reflexive-EqN {_} {λ x y → EqN (f x) (f y)} (λ x → reflexive-EqN (f x))

-- Exercise 3.6(a)
leqN : ℕ → ℕ → U
leqN Nzero Nzero = unit
leqN Nzero (Nsucc m) = unit
leqN (Nsucc n) Nzero = empty
leqN (Nsucc n) (Nsucc m) = leqN n m

leN : ℕ → ℕ → U
leN Nzero Nzero = empty
leN Nzero (Nsucc m) = unit
leN (Nsucc n) Nzero = empty
leN (Nsucc n) (Nsucc m) = leN n m

\end{code}
