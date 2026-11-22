:- use_module(library(lists)).

% people(-People)
% Declarative reading: People is the fixed-order list of the four friends.
people(['Alex', 'Ben', 'Carla', 'Dana']).

% departments(-Departments)
% Declarative reading: Departments is the domain of valid department atoms.
departments([research, development, design, testing]).

% languages(-Languages)
% Declarative reading: Languages is the domain of valid favorite language atoms.
languages([python, java, 'c++', javascript]).

% projects(-Projects)
% Declarative reading: Projects is the domain of valid project preference atoms.
projects(['AI', web, embedded, data]).

% candidate_solution(-Solution)
% Declarative reading: Solution is a list of four p(Name, Dept, Lang, Project)
% terms ordered as Alex, Ben, Carla, Dana, where each attribute category is a
% permutation (bijection) of its domain across the four friends.
candidate_solution([
    p(N1, D1, L1, P1),
    p(N2, D2, L2, P2),
    p(N3, D3, L3, P3),
    p(N4, D4, L4, P4)
]) :-
    people([N1, N2, N3, N4]),
    departments(Depts),
    languages(Langs),
    projects(Projs),
    permutation(Depts, [D1, D2, D3, D4]),
    permutation(Langs, [L1, L2, L3, L4]),
    permutation(Projs, [P1, P2, P3, P4]).