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

% clue_1(+Solution)
% Declarative reading: In Solution, the friend whose project is 'AI'
% does not work in research and is not 'Dana'.
clue_1(Solution) :-
    member(p(Name, Dept, _, 'AI'), Solution),
    Name \= 'Dana',
    Dept \= research.

% clue_2(+Solution)
% Declarative reading: In Solution, 'Alex' does not work in development
% and does not have 'c++' as favorite language.
clue_2(Solution) :-
    member(p('Alex', Dept, Lang, _), Solution),
    Dept \= development,
    Lang \= 'c++'.

% clue_3(+Solution)
% Declarative reading: In Solution, the friend working in the testing
% department has python as favorite language.
clue_3(Solution) :-
    member(p(_, testing, python, _), Solution).

% clue_4(+Solution)
% Declarative reading: In Solution, 'Ben' has web as project preference
% and does not work in testing.
clue_4(Solution) :-
    member(p('Ben', Dept, _, web), Solution),
    Dept \= testing.



% clue(?N, +Solution)
% Declarative reading: Clue number N holds in the complete assignment Solution.
clue(1, Solution) :- clue_1(Solution).
clue(2, Solution) :- clue_2(Solution).
clue(3, Solution) :- clue_3(Solution).
clue(4, Solution) :- clue_4(Solution).

