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

    % run_eval_tests
% Tests eval_expr/2 on normal arithmetic, negative intermediate results,
% exact divisions, non-exact divisions (including nested), and division by zero.
run_eval_tests :-
    % 1. Normal arithmetic expressions
    eval_expr(num(7), 7),
    eval_expr(expr(+, num(4), num(2)), 6),
    eval_expr(expr(*, expr(+, num(4), num(2)), num(3)), 18),
    eval_expr(expr(+, num(4), expr(*, num(2), num(3))), 10),

    % 2. Negative intermediate results
    eval_expr(expr(-, num(3), num(5)), -2),
    eval_expr(expr(*, num(2), expr(-, num(3), num(5))), -4),
    eval_expr(expr(+, expr(-, num(2), num(7)), num(10)), 5),

    % 3. Exact integer divisions (including zero numerator and negative operands)
    eval_expr(expr(/, num(4), num(2)), 2),
    eval_expr(expr(/, num(0), num(5)), 0),
    eval_expr(expr(*, expr(/, num(8), num(4)), num(2)), 4),
    eval_expr(expr(/, expr(-, num(3), num(9)), num(3)), -2),
    eval_expr(expr(/, num(6), expr(-, num(2), num(5))), -2),
    eval_expr(expr(/, expr(-, num(3), num(9)), expr(-, num(2), num(5))), 2),

    % 4. Non-exact divisions fail cleanly (including nested inside valid outer ops)
    \+ eval_expr(expr(/, num(5), num(2)), _),
    \+ eval_expr(expr(/, num(1), num(2)), _),
    \+ eval_expr(expr(/, expr(-, num(2), num(5)), num(2)), _),
    \+ eval_expr(expr(*, expr(/, num(3), num(2)), num(4)), _),

    % 5. Division by zero fails cleanly without throwing an exception
    \+ eval_expr(expr(/, num(5), num(0)), _),
    \+ eval_expr(expr(/, num(0), num(0)), _),
    \+ eval_expr(expr(+, num(1), expr(/, num(4), expr(-, num(3), num(3)))), _),

    % 6. Combined check with build_expr/2: [2, 4] has 3 valid evaluations (2/4 rejected)
    findall(V, (build_expr([2, 4], E), eval_expr(E, V)), Vals),
    msort(Vals, [-2, 6, 8]),

    writeln('PASS: Expression evaluator verified across all valid and invalid cases.').