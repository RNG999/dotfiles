{ pkgs, ... }:

{
  hanare.user = "thetaru";

  environment.systemPackages = with pkgs; [
    vim
    tree

    # SMT solvers
    z3
    cvc5
    # Model checkers
    tlaplus
    alloy6
    spin
    nusmv
    cbmc
    # Proof assistants / verifiers
    lean4
    coq
    why3
    dafny
  ];
}
