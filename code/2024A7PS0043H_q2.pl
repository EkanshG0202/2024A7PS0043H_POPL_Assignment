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