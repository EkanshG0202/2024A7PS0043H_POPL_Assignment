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

% clue_5(+Solution)
% Declarative reading: In Solution, the friend whose favorite language is java
% works in the design department.
clue_5(Solution) :-
    member(p(_, design, java, _), Solution).

% clue_6(+Solution)
% Declarative reading: In Solution, 'Carla' does not prefer embedded projects
% and does not work in development.
clue_6(Solution) :-
    member(p('Carla', Dept, _, Project), Solution),
    Project \= embedded,
    Dept \= development.

% clue_7(+Solution)
% Declarative reading: In Solution, 'Dana' does not have java as favorite
% language, and works in either research or testing.
clue_7(Solution) :-
    member(p('Dana', Dept, Lang, _), Solution),
    Lang \= java,
    member(Dept, [research, testing]).

% clue_8(+Solution)
% Declarative reading: In Solution, the friend who prefers data projects
% works in research and does not use javascript.
clue_8(Solution) :-
    member(p(_, research, Lang, data), Solution),
    Lang \= javascript.

% clue(?N, +Solution)
% Declarative reading: Clue number N holds in the complete assignment Solution.
clue(1, Solution) :- clue_1(Solution).
clue(2, Solution) :- clue_2(Solution).
clue(3, Solution) :- clue_3(Solution).
clue(4, Solution) :- clue_4(Solution).
clue(5, Solution) :- clue_5(Solution).
clue(6, Solution) :- clue_6(Solution).
clue(7, Solution) :- clue_7(Solution).
clue(8, Solution) :- clue_8(Solution).

% satisfies_clues(+ClueIds, +Solution)
% Declarative reading: Every clue number in ClueIds holds in Solution.
satisfies_clues([], _).
satisfies_clues([N | Rest], Solution) :-
    clue(N, Solution),
    satisfies_clues(Rest, Solution).

% solve_clues(+ClueIds, -Solution)
% Declarative reading: Solution is a valid candidate assignment that satisfies
% all clues listed in ClueIds. Generates candidates before testing clues so all
% variables are ground when negative constraints are evaluated.
solve_clues(ClueIds, Solution) :-
    candidate_solution(Solution),
    satisfies_clues(ClueIds, Solution).

% solve(-Solution)
% Declarative reading: Solution is a valid assignment satisfying clues 1 to 8.
solve(Solution) :-
    solve_clues([1, 2, 3, 4, 5, 6, 7, 8], Solution).

% print_solution(+Solution)
% Declarative reading: Prints each friend's name followed by [Dept, Lang, Project]
% with unquoted atoms in the required layout.
print_solution([]).
print_solution([p(Name, Dept, Lang, Project) | Rest]) :-
    format('~w~n[~w, ~w, ~w]~n', [Name, Dept, Lang, Project]),
    print_solution(Rest).

% main
% Declarative reading: Derives one valid solution for clues 1 to 8 and prints it
% in the required format.
main :-
    once(solve(Solution)),
    print_solution(Solution).

% count_solutions(+Active, -N)
% Declarative reading: N is the number of valid candidate assignments that
% satisfy every clue in Active while ignoring all clues not in Active.
count_solutions(Active, N) :-
    findall(Solution, solve_clues(Active, Solution), Solutions),
    length(Solutions, N).