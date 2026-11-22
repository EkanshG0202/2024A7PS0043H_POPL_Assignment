#lang racket/base

;; Assuming definitions from id_q3.rkt are loaded or copied here for testing

;; Supplied test trees
(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))

;; Additional edge-case trees
(define empty-tree '())
(define single-node '(99 () ()))
(define left-skewed '(3 (2 (1 () ()) ()) ()))
(define right-skewed '(10 () (20 () (30 () ()))))

;; --- Test Execution ---
;; Run via `racket tests/test_q3.rkt` and compare against expected output below.

;; 1. Empty tree
(print-inorder empty-tree)
(print-all-traversals empty-tree)

;; 2. t1 (Balanced BST)
(print-inorder t1)
(print-all-traversals t1)

;; 3. t2 (Right-skewed numeric)
(print-all-traversals t2)

;; 4. t3 (Symbolic values)
(print-all-traversals t3)

;; 5. Single-node tree
(print-inorder single-node)
(print-all-traversals single-node)

;; 6. Left-skewed tree
(print-inorder left-skewed)
(print-all-traversals left-skewed)

;; 7. Right-skewed tree
(print-inorder right-skewed)
(print-all-traversals right-skewed)