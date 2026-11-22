# P1 Report: Department Assignment Puzzle, Reloaded

## 1. Solution Count for Clues 1 to 8 (`P1.b`)

Running `count_solutions([1, 2, 3, 4, 5, 6, 7, 8], N)` produces:

$$N = 3$$

### Breakdown of Counts Across Clue Subsets

All counts below were produced directly by `count_solutions/2` over the full bijective search space of $4! \times 4! \times 4! = 13,824$ candidate assignments:

| Active Clues | Solution Count ($N$) | Notes |
| :--- | :---: | :--- |
| `[]` | $13,824$ | Full search space (all unique permutations per attribute) |
| `[1]` | $7,776$ | `'AI'` project is not in `research` and not `'Dana'` |
| `[2]` | $7,776$ | `'Alex'` is not in `development` and does not use `'c++'` |
| `[3]` | $3,456$ | `testing` department uses `python` |
| `[4]` | $2,592$ | `'Ben'` prefers `web` and is not in `testing` |
| `[5]` | $3,456$ | `java` user works in `design` |
| `[6]` | $7,776$ | `'Carla'` does not prefer `embedded` and is not in `development` |
| `[7]` | $5,184$ | `'Dana'` does not use `java` and works in `research` or `testing` |
| `[8]` | $2,592$ | `data` project is in `research` and does not use `javascript` |
| `[9]` | $3,456$ | `python` user prefers `'AI'` projects |
| `[1, 2]` | $4,320$ | Pairwise combination of Clues 1 and 2 |
| `[3, 5]` | $1,152$ | Pairwise combination of Clues 3 and 5 |
| `[1, 2, 3, 4]` | $208$ | First half of the original clues |
| `[5, 6, 7, 8]` | $144$ | Second half of the original clues |
| `[1, 2, 3, 4, 5, 6, 7]` | $16$ | Omitting Clue 8 leaves $16$ valid assignments |
| `[1, 2, 3, 4, 5, 6, 7, 8]` | $3$ | Original puzzle specification (`P1.b`) |
| `[1, 2, 3, 4, 5, 6, 7, 8, 9]` | $1$ | Repaired puzzle with Clue 9 (`P1.c`) |

---

## 2. What $N = 3$ Tells Us About the Puzzle

1. **Consistency:** Because $N > 0$, clues 1 through 8 contain no logical contradictions; at least one valid assignment satisfies all constraints simultaneously.
2. **Under-Constraint (Ambiguity):** Because $N = 3 > 1$, clues 1 through 8 do not uniquely determine the assignment. Specifically:
   * Clues 1–8 completely fix Ben's assignment (`Ben = [development, javascript, web]`) and lock the remaining attribute triples to `(design, java, _)`, `(research, c++, data)`, and `(testing, python, _)`.
   * Two degrees of freedom remain:
     1. **Project placement (`'AI'` vs. `embedded`):** `'AI'` can belong either to the `(testing, python)` friend or to the `(design, java)` friend, with `embedded` taking the remaining slot.
     2. **Person swap (`Alex` vs. `Carla`):** When `'AI'` is paired with `(design, java)` and `embedded` with `(testing, python)`, both Alex and Carla satisfy all constraints in either role, producing two symmetric solutions that differ only by swapping Alex's and Carla's complete records.

### The Three Solutions Satisfying Clues 1 to 8

* **Solution 1:**
  * `Alex = [design, java, AI]`
  * `Ben = [development, javascript, web]`
  * `Carla = [research, c++, data]`
  * `Dana = [testing, python, embedded]`
* **Solution 2:**
  * `Alex = [design, java, embedded]`
  * `Ben = [development, javascript, web]`
  * `Carla = [testing, python, AI]`
  * `Dana = [research, c++, data]`
* **Solution 3:**
  * `Alex = [testing, python, embedded]`
  * `Ben = [development, javascript, web]`
  * `Carla = [design, java, AI]`
  * `Dana = [research, c++, data]`

---

## 3. Puzzle Repair with Clue 9 (`P1.c`)

* **Clue 9:** *The friend whose favorite language is Python prefers AI projects.*
* **Constraint Compliance:** The clue mentions no friend by name and relates only attribute values (`python` and `'AI'`).
* **Effect on Solutions:**
  * In **Solutions 1 and 3**, the friend using `python` prefers `embedded`, so Clue 9 fails.
  * In **Solution 2**, the friend using `python` prefers `'AI'`, so Clue 9 holds.
* **Result:** Evaluating `count_solutions([1, 2, 3, 4, 5, 6, 7, 8, 9], N)` yields **$N = 1$**, uniquely determining **Solution 2** as the sole valid assignment.