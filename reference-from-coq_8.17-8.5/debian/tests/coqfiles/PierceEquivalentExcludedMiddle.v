Definition pierce := forall (p q: Prop), ((p -> q) -> p) -> p.

Definition excluded_middle := forall p, p \/ ~p.

Theorem equivalence: pierce <-> excluded_middle.

Proof.
  unfold pierce, excluded_middle.
  firstorder.
  apply H with (q := ~ (p \/ ~p)).
  firstorder.
  destruct (H p).
  assumption.
  tauto.
Qed.