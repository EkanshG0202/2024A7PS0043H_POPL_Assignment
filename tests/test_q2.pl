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

    % run_format_tests
% Verifies expr_to_string/2 and equation_to_string/3 against all canonical
% precedence, associativity, and equation examples from the assignment.
run_format_tests :-
    % 1. Single number is never parenthesized and produces a string
    expr_to_string(num(42), SNum),
    string(SNum),
    SNum == "42",

    % 2. Assignment parenthesization and associativity examples
    expr_to_string(expr(*, expr(+, num(4), num(2)), num(3)), "(4+2)*3"),
    expr_to_string(expr(+, num(4), expr(*, num(2), num(3))), "4+2*3"),
    expr_to_string(expr(*, expr(/, num(8), num(4)), num(2)), "8/4*2"),
    expr_to_string(expr(/, num(8), expr(*, num(4), num(2))), "8/(4*2)"),
    expr_to_string(expr(-, expr(-, num(1), num(2)), num(3)), "1-2-3"),
    expr_to_string(expr(-, num(1), expr(-, num(2), num(3))), "1-(2-3)"),
    expr_to_string(expr(+, num(1), expr(+, num(2), num(3))), "1+(2+3)"),
    expr_to_string(expr(+, expr(+, num(1), num(2)), num(3)), "1+2+3"),

    % 3. Additional mixed-precedence nested expressions
    expr_to_string(expr(/, expr(-, num(9), num(3)), expr(+, num(1), num(2))), "(9-3)/(1+2)"),
    expr_to_string(expr(-, expr(*, num(4), num(2)), expr(/, num(6), num(3))), "4*2-6/3"),
    expr_to_string(expr(+, expr(-, num(5), num(2)), num(1)), "5-2+1"),
    expr_to_string(expr(-, num(5), expr(+, num(2), num(1))), "5-(2+1)"),

    % 4. Complete equation examples from the assignment (must be SWI-Prolog strings)
    equation_to_string(expr(-, expr(*, num(4), num(2)), num(5)), num(3), Eq1),
    string(Eq1), Eq1 == "4*2-5=3",

    equation_to_string(expr(*, num(4), num(2)), expr(+, num(5), num(3)), Eq2),
    string(Eq2), Eq2 == "4*2=5+3",

    equation_to_string(expr(-, num(4), num(2)), expr(-, num(5), num(3)), Eq3),
    string(Eq3), Eq3 == "4-2=5-3",

    equation_to_string(expr(/, num(4), num(2)), expr(-, num(5), num(3)), Eq4),
    string(Eq4), Eq4 == "4/2=5-3",

    equation_to_string(num(4), expr(*, num(2), expr(-, num(5), num(3))), Eq5),
    string(Eq5), Eq5 == "4=2*(5-3)",

    equation_to_string(num(4), expr(+, num(2), expr(-, num(5), num(3))), Eq6),
    string(Eq6), Eq6 == "4=2+(5-3)",

    equation_to_string(num(4), expr(-, expr(+, num(2), num(5)), num(3)), Eq7),
    string(Eq7), Eq7 == "4=2+5-3",

    equation_to_string(expr(*, num(2), num(4)), num(8), Eq8),
    string(Eq8), Eq8 == "2*4=8",

    % 5. Injectivity check: all 320 distinct trees of [4,2,5,3] yield 320 distinct strings
    findall(Str, (build_expr([4, 2, 5, 3], T), expr_to_string(T, Str)), AllStrs),
    length(AllStrs, 320),
    sort(AllStrs, UniqueStrs),
    length(UniqueStrs, 320),

    writeln('PASS: Canonical expression and equation formatter verified.').

    % run_search_tests
% Tests valid_equation_tree/2 across empty/singleton lists, unsolvable inputs,
% multiple split positions, exact division filtering, and leaf order.
run_search_tests :-
    % 1. Lists of length 0 and 1 fail cleanly
    \+ valid_equation_tree([], _),
    \+ valid_equation_tree([5], _),

    % 2. Short unsolvable lists fail cleanly
    \+ valid_equation_tree([2, 3], _),
    \+ valid_equation_tree([2, 3, 4], _),

    % 3. Two-element solvable lists (single split position)
    findall(Eq, valid_equation_tree([2, 2], Eq), Eqs22),
    Eqs22 = [eq(num(2), num(2))],

    findall(Eq, valid_equation_tree([0, 0], Eq), Eqs00),
    Eqs00 = [eq(num(0), num(0))],

    % 4. Three-element lists testing different split positions:
    %    [2, 4, 8] -> split at index 2 (2*4 = 8)
    findall(Str, (
        valid_equation_tree([2, 4, 8], eq(L, R)),
        equation_to_string(L, R, Str)
    ), Strs248),
    Strs248 = ["2*4=8"],

    %    [8, 4, 2] -> split at index 1 (8 = 4*2) and index 2 (8/4 = 2)
    findall(Str, (
        valid_equation_tree([8, 4, 2], eq(L, R)),
        equation_to_string(L, R, Str)
    ), Strs842),
    sort(Strs842, ["8/4=2", "8=4*2"]),

    %    [1, 2, 1] -> split at index 1 with subtraction (1 = 2-1)
    findall(Str, (
        valid_equation_tree([1, 2, 1], eq(L, R)),
        equation_to_string(L, R, Str)
    ), Strs121),
    Strs121 = ["1=2-1"],

    % 5. Four-element list [4, 2, 5, 3] across all 3 split positions (7 equations)
    findall(eq(L, R), valid_equation_tree([4, 2, 5, 3], eq(L, R)), Trees4253),
    length(Trees4253, 7),
    forall(member(eq(L, R), Trees4253), (
        tree_leaves(L, LLeaves),
        tree_leaves(R, RLeaves),
        append(LLeaves, RLeaves, [4, 2, 5, 3])
    )),
    findall(Str, (
        member(eq(L, R), Trees4253),
        equation_to_string(L, R, Str)
    ), Strs4253),
    sort(Strs4253, [
        "4*2-5=3",
        "4*2=5+3",
        "4-2=5-3",
        "4/2=5-3",
        "4=2*(5-3)",
        "4=2+(5-3)",
        "4=2+5-3"
    ]),

    writeln('PASS: Equation tree search verified across split positions and edge cases.').

    % run_generate_equation_tests
% Tests generate_equation/2 on assignment examples, length 0/1 lists,
% unsolvable sequences, and SWI-Prolog string type requirements.
run_generate_equation_tests :-
    % 1. Lists of length 0 and 1 must fail cleanly without error or looping
    \+ generate_equation([], _),
    \+ generate_equation([0], _),
    \+ generate_equation([42], _),

    % 2. Assignment unsolvable example fails cleanly
    \+ generate_equation([2, 3, 4], _),

    % 3. Assignment example: [4, 2, 5, 3] yields a canonical string from the 7 valid equations
    generate_equation([4, 2, 5, 3], Eq1),
    string(Eq1),
    \+ atom(Eq1),
    member(Eq1, [
        "4*2-5=3",
        "4*2=5+3",
        "4-2=5-3",
        "4/2=5-3",
        "4=2*(5-3)",
        "4=2+(5-3)",
        "4=2+5-3"
    ]),

    % 4. Assignment example: [2, 4, 8] yields "2*4=8" as a string
    generate_equation([2, 4, 8], Eq2),
    string(Eq2),
    Eq2 == "2*4=8",

    % 5. Additional cases: zeros (testing non-zero divisor guard) and negative intermediates
    generate_equation([0, 5, 0], Eq3),
    string(Eq3),
    member(Eq3, ["0*5=0", "0/5=0", "0=5*0"]),

   generate_equation([1, 2, 3, 2], Eq4),
    string(Eq4),
    member(Eq4, ["1-2+3=2", "1=2-3+2", "1=2-(3-2)"]),

    writeln('PASS: generate_equation/2 verified across all examples and edge cases.').

    % run_all_equations_tests
% Verifies all_equations/2 and count_equations/2 on assignment examples,
% empty/singleton inputs, zero-divisor cases, and sorted term ordering.
run_all_equations_tests :-
    % 1. Lists of length 0 and 1 return [] and count 0
    all_equations([], []),
    count_equations([], 0),
    all_equations([7], []),
    count_equations([7], 0),

    % 2. Assignment unsolvable example: [2, 3, 4] -> [] and 0
    all_equations([2, 3, 4], []),
    count_equations([2, 3, 4], 0),

    % 3. Assignment example: [2, 4, 8] -> ["2*4=8"] and 1
    all_equations([2, 4, 8], Eqs248),
    Eqs248 == ["2*4=8"],
    forall(member(E, Eqs248), string(E)),
    count_equations([2, 4, 8], 1),

    % 4. Assignment example: [4, 2, 5, 3] -> exact 7 strings in sort/2 order
    all_equations([4, 2, 5, 3], Eqs4253),
    Eqs4253 == [
        "4*2-5=3",
        "4*2=5+3",
        "4-2=5-3",
        "4/2=5-3",
        "4=2*(5-3)",
        "4=2+(5-3)",
        "4=2+5-3"
    ],
    forall(member(E, Eqs4253), string(E)),
    count_equations([4, 2, 5, 3], 7),

    % 5. Additional cases: zeros and negative intermediates
    all_equations([0, 5, 0], Eqs050),
    Eqs050 == ["0*5=0", "0/5=0", "0=5*0"],
    count_equations([0, 5, 0], 3),

    all_equations([1, 2, 3, 2], Eqs1232),
    Eqs1232 == ["1-(2-3)=2", "1-2+3=2", "1=2-(3-2)", "1=2-3+2"],
    count_equations([1, 2, 3, 2], 4),

    % 6. Repeated numbers: [1, 1, 1, 1] -> 30 distinct canonical trees/strings
    all_equations([1, 1, 1, 1], Eqs1111),
    sort(Eqs1111, Sorted1111),
    Eqs1111 == Sorted1111,
    count_equations([1, 1, 1, 1], 30),

    writeln('PASS: all_equations/2 and count_equations/2 verified.').

% run_all_q2_tests
% Runs the complete Q2 verification suite.
run_all_q2_tests :-
    run_expr_gen_tests,
    run_eval_tests,
    run_format_tests,
    run_search_tests,
    run_generate_equation_tests,
    run_all_equations_tests,
    writeln('ALL Q2 TESTS PASSED.').