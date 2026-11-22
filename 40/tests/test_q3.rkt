;; --- Test Trees ---
(define t1 '(4 (2 (1 () ()) (3 () ())) (6 (5 () ()) (7 () ()))))
(define t2 '(1 () (2 () (3 () ()))))
(define t3 '(a (b () ()) (c () ())))

(define empty-tree '())
(define single-node '(99 () ()))
(define left-skewed '(3 (2 (1 () ()) ()) ()))
(define right-skewed '(10 () (20 () (30 () ()))))
(define unequal-tree '(10 (5 (2 (1 () ()) ()) ()) (15 () ())))
(define zigzag-one-child '(1 (2 () (3 () ())) ()))

;; --- S1.a & S1.b Tests: Traversals ---
(print-inorder empty-tree)
(print-all-traversals empty-tree)

(print-inorder t1)
(print-all-traversals t1)

(print-all-traversals t2)
(print-all-traversals t3)

(print-inorder single-node)
(print-all-traversals single-node)

(print-inorder left-skewed)
(print-all-traversals left-skewed)

(print-inorder right-skewed)
(print-all-traversals right-skewed)

;; --- S1.c Tests: Height and Leaves ---
(print-height-and-leaves empty-tree)
(print-height-and-leaves t1)
(print-height-and-leaves t2)
(print-height-and-leaves t3)
(print-height-and-leaves single-node)
(print-height-and-leaves left-skewed)
(print-height-and-leaves right-skewed)
(print-height-and-leaves unequal-tree)
(print-height-and-leaves zigzag-one-child)