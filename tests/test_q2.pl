:- use_module(library(lists)).
:- consult('../code/2024A7PS0043H_q2.pl').

% tree_leaves(+Expr, -Leaves)
% Declarative reading: Leaves is the left-to-right list of numbers appearing
% at the leaves of Expr.
tree_leaves(num(N), [N]).
tree_leaves(expr(_, Left, Right), Leaves) :-
    tree_leaves(Left, LeftLeaves),
    tree_leaves(Right, RightLeaves),
    append(LeftLeaves, RightLeaves, Leaves).

% run_expr_gen_tests
% Verifies build_expr/2 on empty, singleton, 2-, 3-, and 4-element lists,
% checking exact tree counts, distinct parenthesizations, and leaf order.
run_expr_gen_tests :-
    % 1. Empty list fails cleanly
    \+ build_expr([], _),

    % 2. Single number produces exactly one leaf tree num(N)
    findall(E, build_expr([7], E), E1),
    E1 = [num(7)],

    % 3. Two numbers produce 4 trees (one per operator)
    findall(E, build_expr([4, 2], E), E2),
    length(E2, 4),
    sort(E2, UniqueE2),
    length(UniqueE2, 4),
    member(expr(+, num(4), num(2)), E2),
    member(expr(/, num(4), num(2)), E2),

    % 4. Three numbers produce C_2 * 4^2 = 32 distinct trees, including both
    %    left-associated (1+2)+3 and right-associated 1+(2+3) parenthesizations
    findall(E, build_expr([1, 2, 3], E), E3),
    length(E3, 32),
    sort(E3, UniqueE3),
    length(UniqueE3, 32),
    member(expr(+, expr(+, num(1), num(2)), num(3)), E3),
    member(expr(+, num(1), expr(+, num(2), num(3))), E3),

    % 5. Four numbers produce C_3 * 4^3 = 320 distinct trees, all preserving
    %    the exact input sequence [4, 2, 5, 3] at their leaves
    findall(E, build_expr([4, 2, 5, 3], E), E4),
    length(E4, 320),
    sort(E4, UniqueE4),
    length(UniqueE4, 320),
    forall(member(Tree, E4), tree_leaves(Tree, [4, 2, 5, 3])),

    writeln('PASS: Expression tree generator verified across all test cases.').