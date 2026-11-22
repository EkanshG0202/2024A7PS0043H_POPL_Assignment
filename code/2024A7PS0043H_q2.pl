:- use_module(library(lists)).

% operator(?Op)
% Declarative reading: Op is one of the four allowed binary arithmetic operators.
operator(+).
operator(-).
operator(*).
operator(/).

% split_nonempty(+List, -Left, -Right)
% Declarative reading: Left and Right are two non-empty contiguous sublists
% whose concatenation is List, preserving element order.
split_nonempty(List, [LHead | LTail], [RHead | RTail]) :-
    append([LHead | LTail], [RHead | RTail], List).

% build_expr(+Numbers, -Expr)
% Declarative reading: Expr is a valid binary arithmetic expression tree built
% from the non-empty list Numbers in their exact original order.
build_expr([N], num(N)).
build_expr(Numbers, expr(Op, Left, Right)) :-
    split_nonempty(Numbers, LeftNums, RightNums),
    build_expr(LeftNums, Left),
    build_expr(RightNums, Right),
    operator(Op).

% eval_expr(+Expr, -Value)
% Declarative reading: Value is the exact integer value of expression tree Expr,
% where every division has a non-zero divisor and zero remainder.
eval_expr(num(N), N).
eval_expr(expr(+, Left, Right), Value) :-
    eval_expr(Left, VL),
    eval_expr(Right, VR),
    Value is VL + VR.
eval_expr(expr(-, Left, Right), Value) :-
    eval_expr(Left, VL),
    eval_expr(Right, VR),
    Value is VL - VR.
eval_expr(expr(*, Left, Right), Value) :-
    eval_expr(Left, VL),
    eval_expr(Right, VR),
    Value is VL * VR.
eval_expr(expr(/, Left, Right), Value) :-
    eval_expr(Left, VL),
    eval_expr(Right, VR),
    VR =\= 0,
    VL mod VR =:= 0,
    Value is VL // VR.

% precedence(?Op, ?Level)
% Declarative reading: Operator Op has precedence Level (higher binds tighter).
precedence(+, 1).
precedence(-, 1).
precedence(*, 2).
precedence(/, 2).

% expr_to_string(+Expr, -Str)
% Declarative reading: Str is the canonical space-free SWI-Prolog string
% representation of expression tree Expr.
expr_to_string(num(N), Str) :-
    number_string(N, Str).
expr_to_string(expr(Op, Left, Right), Str) :-
    precedence(Op, ParentPrec),
    format_left(Left, ParentPrec, LeftStr),
    format_right(Right, ParentPrec, RightStr),
    atom_string(Op, OpStr),
    atomics_to_string([LeftStr, OpStr, RightStr], Str).

% format_left(+LeftExpr, +ParentPrec, -Str)
% Declarative reading: Str is the rendered left operand of a parent operator
% with precedence ParentPrec; parenthesized only when LeftExpr is a compound
% expression whose top operator has strictly lower precedence (<).
format_left(num(N), _, Str) :-
    number_string(N, Str).
format_left(expr(ChildOp, L, R), ParentPrec, Str) :-
    expr_to_string(expr(ChildOp, L, R), RawStr),
    precedence(ChildOp, ChildPrec),
    (   ChildPrec < ParentPrec
    ->  atomics_to_string(["(", RawStr, ")"], Str)
    ;   Str = RawStr
    ).

% format_right(+RightExpr, +ParentPrec, -Str)
% Declarative reading: Str is the rendered right operand of a parent operator
% with precedence ParentPrec; parenthesized when RightExpr is a compound
% expression whose top operator has equal or lower precedence (=<), preserving
% left-associativity.
format_right(num(N), _, Str) :-
    number_string(N, Str).
format_right(expr(ChildOp, L, R), ParentPrec, Str) :-
    expr_to_string(expr(ChildOp, L, R), RawStr),
    precedence(ChildOp, ChildPrec),
    (   ChildPrec =< ParentPrec
    ->  atomics_to_string(["(", RawStr, ")"], Str)
    ;   Str = RawStr
    ).

% equation_to_string(+LeftExpr, +RightExpr, -EqStr)
% Declarative reading: EqStr is the canonical SWI-Prolog string "Left=Right"
% with no spaces.
equation_to_string(LeftExpr, RightExpr, EqStr) :-
    expr_to_string(LeftExpr, LeftStr),
    expr_to_string(RightExpr, RightStr),
    atomics_to_string([LeftStr, "=", RightStr], EqStr).