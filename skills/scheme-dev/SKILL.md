---
name: scheme-dev
description: Guidance for implementing and reviewing this PPL assignment's Racket/Scheme tasks in racket/base, with strict built-in restrictions, recursion, exact output, and robust tests.
---

# Scheme Development Skill

## Language and environment
- Target Racket 8.x, using `#lang racket/base`.
- Assignment files are `id_q3.rkt` and `id_q4.rkt`, with `id` replaced by the group ID.
- Run files using `racket id_q3.rkt` and `racket id_q4.rkt`.
- Submitted files must contain definitions only: do not invoke functions at top level and do not print anything merely when the file is loaded. The grader appends its own calls.


## Allowed built-ins
Use only the functions permitted by the assignment. The common permitted set includes `define`, `lambda`, `let`, `let*`, `letrec`, named `let`, `if`, `cond` (with `else`), `and`, `or`, `not`, `begin`, `quote`, `cons`, `car`, `cdr`, `list`, permitted compositions of `car`/`cdr`, `null?`, `pair?`, `eq?`, `assq`, `assoc`, arithmetic and comparison operators, `max`, `display`, and `newline`. Q4 additionally permits `read`.

Do not use other Racket facilities. In particular, avoid mutation (`set!` and related forms), vectors, hash tables, strings, loops, and forbidden list helpers such as `length`, `append`, `reverse`, `map`, `filter`, `member`, `memq`, `list-ref`, and `list-tail`. If needed, implement a helper recursively using allowed primitives.

## Coding conventions and reasoning
- Use structural recursion that follows the input tree/list shape.
- Keep each helper focused and give it a descriptive name. Explain non-obvious recursive cases in comments.
- Pass state explicitly through arguments; do not rely on mutation or global state.
- Prefer tail recursion where it naturally helps with long lists, but do not sacrifice correctness or clarity.
- Keep traversal logic reusable where appropriate, avoiding redundant implementations.
- Separate computation from printing. Public assignment functions should print exactly the requested result and newline, with no extra prompts or diagnostics.
- Do not add test calls or demonstrations to submitted files; place tests in separate test files or run them interactively.

## Assignment-specific guidance
### Q3: Binary trees
- A tree is `()` or `(value left right)`.
- Visit the left subtree before the right subtree.
- Inorder: left, value, right. Preorder: value, left, right. Postorder: left, right, value.
- Empty-tree height is 0; node height is one plus the maximum child height. A leaf has two empty children; an empty tree has zero leaves.
- Print the exact requested list(s), each followed by a newline.

### Q4: Nested lists
- Every list, including the outermost list and empty lists, is considered for insertion.
- Measure each list's length as its number of top-level elements in the original list, before inserting anything.
- Recursively process nested lists and insert `x` at the front when the predicate on that list's length succeeds.
- `insert-if-short` must ultimately use `make-inserter`; the final source must have exactly one definition of `insert-if-short`.
- `print-insert-result` reads `x`, `lst`, and `n` in that order and prints only the result plus newline.
- Hidden cases include nesting depth 100 and lists of 10,000 elements; consider recursion depth and avoid needless repeated traversal.

## Running and testing
- Use Racket 8.x. Run the submitted files with `racket id_q3.rkt` and `racket id_q4.rkt` to check load behavior.
- Keep tests outside the solution files. Run supplied examples and your own edge cases, checking exact printed output including newlines.
- Q3: test empty, single-node, balanced, skewed, and unequal-height trees; verify all three traversal orders, height, and leaf count.
- Q4: test empty input lists, nested empty lists, lengths below/equal/above the threshold, custom predicates for `make-inserter`, supplied examples, and stress cases with depth 100 and 10,000 elements.
- Only report tests actually executed and their outcomes.

## Self-review checklist
Before presenting Scheme/Racket code:
- [ ] File starts with `#lang racket/base` and contains definitions only.
- [ ] No top-level calls, load-time output, mutation, loops, or disallowed built-ins.
- [ ] Every helper uses only allowed primitives and handles its base case.
- [ ] Q3 traversal order and exact output line count/newlines are correct.
- [ ] Q3 empty-tree height and leaf count are both zero; leaf definition is exact.
- [ ] Q4 uses original list lengths and strictly checks the requested predicate/threshold.
- [ ] Q4 processes the outermost list and empty lists consistently.
- [ ] `make-inserter` is genuinely higher-order and `insert-if-short` uses it.
- [ ] Q4 has only one final definition of `insert-if-short`.
- [ ] Supplied examples and edge/stress tests have actually run.

## Common AI failure modes to watch for
- Using a convenient Racket built-in that the assignment forbids.
- Forgetting that the grader loads the file and adds calls, so top-level test code or output breaks grading.
- Returning a value instead of printing it, or printing extra diagnostic text.
- Reversing or misordering tree traversal visits.
- Counting an empty tree as a leaf or giving it height 1.
- Measuring nested-list length recursively instead of counting top-level elements.
- Testing list length after insertion rather than before.
- Skipping the outermost list or treating empty lists as a special exception.
- Implementing `make-inserter` but leaving the final `insert-if-short` independent of it, or leaving duplicate definitions.
- Making recursive list transformations unnecessarily quadratic or brittle on deep/large test inputs.
- Providing plausible test results without running the tests.
