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

% Sample complete candidate assignments used for unit testing clues 1-4.
sample_base([
    p('Alex',  design,      java,       'AI'),
    p('Ben',   development, 'c++',      web),
    p('Carla', testing,     python,     embedded),
    p('Dana',  research,    javascript, data)
]).

% run_clue_1_to_4_tests
% Tests clues 1-4 independently on satisfying and violating candidates,
% and verifies exact combinatoric counts over all 13,824 candidates.
run_clue_1_to_4_tests :-
    sample_base(ValidAll),

    % --- Clue 1: AI project -> not research, not Dana ---
    clue(1, ValidAll),
    \+ clue(1, [
        p('Alex',  research,    java,       'AI'),
        p('Ben',   development, 'c++',      web),
        p('Carla', testing,     python,     embedded),
        p('Dana',  design,      javascript, data)
    ]),
    \+ clue(1, [
        p('Alex',  design,      java,       data),
        p('Ben',   development, 'c++',      web),
        p('Carla', testing,     python,     embedded),
        p('Dana',  research,    javascript, 'AI')
    ]),

    % --- Clue 2: Alex -> Dept \= development, Lang \= 'c++' ---
    clue(2, ValidAll),
    \+ clue(2, [
        p('Alex',  development, java,       'AI'),
        p('Ben',   design,      'c++',      web),
        p('Carla', testing,     python,     embedded),
        p('Dana',  research,    javascript, data)
    ]),
    \+ clue(2, [
        p('Alex',  design,      'c++',      'AI'),
        p('Ben',   development, java,       web),
        p('Carla', testing,     python,     embedded),
        p('Dana',  research,    javascript, data)
    ]),

    % --- Clue 3: testing -> python ---
    clue(3, ValidAll),
    \+ clue(3, [
        p('Alex',  design,      python,     'AI'),
        p('Ben',   development, 'c++',      web),
        p('Carla', testing,     java,       embedded),
        p('Dana',  research,    javascript, data)
    ]),

    % --- Clue 4: Ben -> project = web, Dept \= testing ---
    clue(4, ValidAll),
    \+ clue(4, [
        p('Alex',  design,      java,       web),
        p('Ben',   development, 'c++',      'AI'),
        p('Carla', testing,     python,     embedded),
        p('Dana',  research,    javascript, data)
    ]),
    \+ clue(4, [
        p('Alex',  design,      java,       'AI'),
        p('Ben',   testing,     python,     web),
        p('Carla', development, 'c++',      embedded),
        p('Dana',  research,    javascript, data)
    ]),

    % --- Verify no hidden over-constraints via exact candidate counts ---
    findall(S, (candidate_solution(S), clue(1, S)), S1), length(S1, 7776),
    findall(S, (candidate_solution(S), clue(2, S)), S2), length(S2, 7776),
    findall(S, (candidate_solution(S), clue(3, S)), S3), length(S3, 3456),
    findall(S, (candidate_solution(S), clue(4, S)), S4), length(S4, 2592),

    writeln('PASS: Clues 1-4 passed all positive, negative, and count checks.').

    