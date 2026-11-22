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

% run_clue_5_to_8_tests
% Tests clues 5-8 independently on satisfying and violating candidates,
% and verifies exact combinatoric counts over all 13,824 candidates.
run_clue_5_to_8_tests :-
    % --- Clue 5: favorite language = java -> department = design ---
    clue(5, [
        p('Alex',  design,      java,       'AI'),
        p('Ben',   development, 'c++',      web),
        p('Carla', testing,     python,     embedded),
        p('Dana',  research,    javascript, data)
    ]),
    \+ clue(5, [
        p('Alex',  design,      python,     'AI'),
        p('Ben',   development, java,       web),
        p('Carla', testing,     'c++',      embedded),
        p('Dana',  research,    javascript, data)
    ]),

    % --- Clue 6: Carla -> project \= embedded, department \= development ---
    clue(6, [
        p('Alex',  design,      java,       'AI'),
        p('Ben',   development, 'c++',      web),
        p('Carla', testing,     python,     data),
        p('Dana',  research,    javascript, embedded)
    ]),
    \+ clue(6, [
        p('Alex',  design,      java,       'AI'),
        p('Ben',   development, 'c++',      web),
        p('Carla', testing,     python,     embedded),
        p('Dana',  research,    javascript, data)
    ]),
    \+ clue(6, [
        p('Alex',  design,      java,       'AI'),
        p('Ben',   testing,     'c++',      web),
        p('Carla', development, python,     data),
        p('Dana',  research,    javascript, embedded)
    ]),

    % --- Clue 7: Dana -> language \= java, dept in {research, testing} ---
    clue(7, [
        p('Alex',  design,      java,       'AI'),
        p('Ben',   development, 'c++',      web),
        p('Carla', testing,     python,     embedded),
        p('Dana',  research,    javascript, data)
    ]),
    clue(7, [
        p('Alex',  design,      java,       'AI'),
        p('Ben',   development, 'c++',      web),
        p('Carla', research,    python,     embedded),
        p('Dana',  testing,     javascript, data)
    ]),
    \+ clue(7, [
        p('Alex',  design,      python,     'AI'),
        p('Ben',   development, 'c++',      web),
        p('Carla', testing,     javascript, embedded),
        p('Dana',  research,    java,       data)
    ]),
    \+ clue(7, [
        p('Alex',  research,    java,       'AI'),
        p('Ben',   testing,     'c++',      web),
        p('Carla', development, python,     embedded),
        p('Dana',  design,      javascript, data)
    ]),

    % --- Clue 8: project = data -> department = research, lang \= javascript ---
    clue(8, [
        p('Alex',  design,      java,       'AI'),
        p('Ben',   development, 'c++',      web),
        p('Carla', testing,     javascript, embedded),
        p('Dana',  research,    python,     data)
    ]),
    \+ clue(8, [
        p('Alex',  design,      java,       'AI'),
        p('Ben',   development, 'c++',      web),
        p('Carla', testing,     python,     data),
        p('Dana',  research,    javascript, embedded)
    ]),
    \+ clue(8, [
        p('Alex',  design,      java,       'AI'),
        p('Ben',   development, 'c++',      web),
        p('Carla', testing,     python,     embedded),
        p('Dana',  research,    javascript, data)
    ]),

    % --- Verify no hidden over-constraints via exact candidate counts ---
    findall(S, (candidate_solution(S), clue(5, S)), S5), length(S5, 3456),
    findall(S, (candidate_solution(S), clue(6, S)), S6), length(S6, 7776),
    findall(S, (candidate_solution(S), clue(7, S)), S7), length(S7, 5184),
    findall(S, (candidate_solution(S), clue(8, S)), S8), length(S8, 2592),

    writeln('PASS: Clues 5-8 passed all positive, negative, and count checks.').

% run_solver_tests
% Verifies that solve/1 derives all 3 valid solutions satisfying clues 1 to 8
% without stopping prematurely, and that main/0 prints the exact expected format.
run_solver_tests :-
    % 1. Verify solve/1 backtracks across all 3 valid solutions
    findall(S, solve(S), Solutions),
    length(Solutions, 3),
    forall(member(Sol, Solutions), (
        valid_candidate(Sol),
        forall(member(N, [1, 2, 3, 4, 5, 6, 7, 8]), clue(N, Sol))
    )),

    % 2. Verify main/0 output format (4 friend blocks, unquoted atoms)
    with_output_to(string(Output), main),
    split_string(Output, "\n", "", Lines),
    Lines = [
        "Alex",    AlexInfo,
        "Ben",     BenInfo,
        "Carla",   CarlaInfo,
        "Dana",    DanaInfo,
        ""
    ],
    forall(member(Line, [AlexInfo, BenInfo, CarlaInfo, DanaInfo]), (
        sub_string(Line, 0, 1, _, "["),
        sub_string(Line, _, 1, 0, "]"),
        \+ sub_string(Line, _, _, _, "'")
    )),

    writeln('PASS: Solver and main/0 output format verified end-to-end.').

% run_count_tests
% Verifies count_solutions/2 across empty, single-clue, subset, reordered,
% and full clue lists to ensure all solutions are counted and unselected clues
% are ignored.
run_count_tests :-
    % Empty active-clue list -> all 13,824 candidate assignments
    count_solutions([], 13824),

    % Single clues
    count_solutions([1], 7776),
    count_solutions([2], 7776),
    count_solutions([3], 3456),
    count_solutions([4], 2592),
    count_solutions([5], 3456),
    count_solutions([6], 7776),
    count_solutions([7], 5184),
    count_solutions([8], 2592),

    % Subsets of clues (unselected clues remain unenforced)
    count_solutions([1, 2], 4320),
    count_solutions([3, 5], 1152),
    count_solutions([1, 2, 3, 4], 208),
    count_solutions([5, 6, 7, 8], 144),
    count_solutions([1, 2, 3, 4, 5, 6, 7], 16),

    % Full set of clues 1 to 8 (in forward and reverse order)
    count_solutions([1, 2, 3, 4, 5, 6, 7, 8], 3),
    count_solutions([8, 7, 6, 5, 4, 3, 2, 1], 3),

    writeln('PASS: count_solutions/2 verified across all clue combinations.').

% run_clue_9_tests
% Verifies clue(9, Solution) independently and confirms that adding Clue 9
% to Clues 1-8 reduces the solution count from 3 to 1.
run_clue_9_tests :-
    % Positive case (Solution 2: python paired with 'AI')
    ExpectedUnique = [
        p('Alex',  design,      java,       embedded),
        p('Ben',   development, javascript, web),
        p('Carla', testing,     python,     'AI'),
        p('Dana',  research,    'c++',      data)
    ],
    clue(9, ExpectedUnique),

    % Negative cases (Solutions 1 and 3: python paired with embedded)
    \+ clue(9, [
        p('Alex',  design,      java,       'AI'),
        p('Ben',   development, javascript, web),
        p('Carla', research,    'c++',      data),
        p('Dana',  testing,     python,     embedded)
    ]),
    \+ clue(9, [
        p('Alex',  testing,     python,     embedded),
        p('Ben',   development, javascript, web),
        p('Carla', design,      java,       'AI'),
        p('Dana',  research,    'c++',      data)
    ]),

    % Unbiased count check on Clue 9 alone
    count_solutions([9], 3456),

    % P1.c requirement: Clues 1..9 leave N = 1 unique solution
    count_solutions([1, 2, 3, 4, 5, 6, 7, 8, 9], 1),
    solve_clues([1, 2, 3, 4, 5, 6, 7, 8, 9], ExpectedUnique),

    writeln('PASS: Clue 9 verified; clues 1-9 yield N = 1 unique solution.').

% run_all_tests
% Runs the complete Q1 verification suite.
run_all_tests :-
    run_generator_tests,
    run_clue_1_to_4_tests,
    run_clue_5_to_8_tests,
    run_solver_tests,
    run_count_tests,
    run_clue_9_tests,
    writeln('ALL Q1 TESTS PASSED.').