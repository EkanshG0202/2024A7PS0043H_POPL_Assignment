:- use_module(library(lists)).
:- consult('../code/2024A7PS0043H_q1.pl').

% valid_candidate(+Solution)
% Declarative reading: Solution has the four friends in canonical order and
% uses every value from each attribute domain exactly once.
valid_candidate([
    p('Alex',  D1, L1, P1),
    p('Ben',   D2, L2, P2),
    p('Carla', D3, L3, P3),
    p('Dana',  D4, L4, P4)
]) :-
    departments(Depts),
    languages(Langs),
    projects(Projs),
    permutation(Depts, [D1, D2, D3, D4]),
    permutation(Langs, [L1, L2, L3, L4]),
    permutation(Projs, [P1, P2, P3, P4]).

% run_generator_tests
% Verifies that candidate_solution/1 yields 13,824 distinct candidates (4!^3)
% and that every candidate satisfies the domain and uniqueness constraints.
run_generator_tests :-
    findall(S, candidate_solution(S), Sols),
    length(Sols, 13824),
    sort(Sols, UniqueSols),
    length(UniqueSols, 13824),
    forall(member(Cand, Sols), valid_candidate(Cand)),
    writeln('PASS: 13,824 unique, domain-valid candidates generated.').