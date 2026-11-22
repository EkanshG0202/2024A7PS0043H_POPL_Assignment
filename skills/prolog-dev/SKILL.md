---
name: prolog-dev
description: Guidance for solving and reviewing this PPL assignment's Prolog tasks using SWI-Prolog, with constraint-based/declarative reasoning, careful predicate design, and compliant testing.
---

# Prolog Development Skill

## Language and environment
- Target SWI-Prolog 9.x.
- Assignment files use the group-ID naming convention: `id_q1.pl` and `id_q2.pl`.
- Run Q1's entry point with `swipl -q -f id_q1.pl -g main -t halt`.
- Run other predicates with `swipl -q -f <file> -g "<goal>" -t halt`.
- Do not call `halt/0` from submitted code and do not use initialization directives. Submitted files should contain definitions only.


## Coding conventions and reasoning
- Prefer declarative relations and logical constraints over procedural enumeration where practical.
- Give predicates clear, descriptive names; use helper predicates to keep each predicate focused on one responsibility.
- Make predicate arguments and data representations explicit. Keep the representation consistent throughout the program.
- Write each clue or requirement as a distinct predicate when the assignment asks for separately testable clauses.
- Use recursion and Prolog's relational patterns rather than unnecessary manual control flow.
- Keep output formatting isolated from solving logic. Only print what the assignment explicitly requires.
- Comment non-obvious reasoning, constraint interactions, and representation decisions; avoid comments that merely restate code.
- Avoid hard-coded final answers. Derive results from the stated constraints.

## Assignment constraints
- Do not use `assert`, `retract`, global variables, or their prohibited equivalents.
- Use only the libraries permitted by the specific problem (assignment allows `lists`, `apply`, `yall`, and `aggregate` where specified).
- For Q1, preserve the specified solution representation, friend order, atom spellings, and clue numbering. Each clue predicate must succeed exactly when that clue is true for a fully instantiated solution. `count_solutions/2` must honor only the requested active clues. The ninth clue must be documented immediately above its predicate using the required `% CLUE 9:` comment and must not name a friend.
- For Q2, preserve number order, use every number once, place exactly one equality at a valid split, and ensure each expression operation obeys the exact-integer division and zero-divisor rules. Do not parse a rendered equation string back to evaluate it. Canonical output must be an SWI-Prolog string with no spaces and correct precedence/associativity parentheses.

## Running and testing
- Run the exact assignment command for Q1 and verify its four output lines and format.
- Test predicates directly from the command line or a separate test file. Do not add test calls to submitted solution files.
- For Q1, test each clue, active clue subsets, counts for clues 1–8, and uniqueness after clue 9.
- For Q2, test all supplied examples, failure/no-solution cases (including lists of length 0 or 1), multiple solutions, operator precedence, associativity, parentheses, exact division, non-exact division, and division by zero.
- Capture actual command output and exit status. Never claim tests passed unless they were run.

## Self-review checklist
Before presenting Prolog code:
- [ ] Predicate names, arities, and output interfaces match the assignment exactly.
- [ ] No prohibited libraries, mutation, global state, initialization directives, or `halt/0` calls.
- [ ] Search/constraint predicates are not accidentally committed to a hard-coded answer.
- [ ] Clues are independent and numbered correctly; clue-counting ignores inactive clues.
- [ ] Equation generation respects input order and uses all numbers once.
- [ ] Arithmetic is safe: division is exact, divisor nonzero, intermediate results valid.
- [ ] Canonical equation strings obey precedence and associativity and contain no spaces.
- [ ] Output is limited to required output; submitted files contain definitions only.
- [ ] Edge cases and supplied examples have been run, not merely reasoned about.

## Common AI failure modes to watch for
- Treating Prolog as imperative code and overusing cuts or procedural ordering.
- Accidentally constraining inactive clues during solution counting.
- Reusing a clue in the main solver but implementing its standalone predicate differently.
- Hard-coding a puzzle solution or count rather than deriving it.
- Confusing atoms, strings, and character/code lists in equation output.
- Evaluating division using floating point or allowing non-exact division.
- Incorrect operator precedence or parentheses in equation rendering, especially right operands and equal-precedence operators.
- Generating duplicate equation strings or sorting with the wrong term type.
- Overlooking empty and single-element input lists, which must fail cleanly for Q2 generation.
- Claiming a test passed without executing it or testing only the happy path.
