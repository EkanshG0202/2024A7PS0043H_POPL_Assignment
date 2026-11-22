;; --- Tests for my-length ---
(display (my-length '()))                     (newline) ;; Expected: 0
(display (my-length '(a)))                    (newline) ;; Expected: 1
(display (my-length '(1 2 3 4 5)))            (newline) ;; Expected: 5
(display (my-length '((1 2) (3 4 5) (6) ()))) (newline) ;; Expected: 4 (top-level elements only)

;; --- Tests for my-map ---
(display (my-map (lambda (x) (+ x 10)) '()))               (newline) ;; Expected: ()
(display (my-map (lambda (x) (* x 2)) '(1 2 3 4)))         (newline) ;; Expected: (2 4 6 8)
(display (my-map (lambda (x) (cons 'tag x)) '((a) (b c)))) (newline) ;; Expected: ((tag a) (tag b c))
(display (my-map my-length '(() (1) (1 2) (1 2 3))))       (newline) ;; Expected: (0 1 2 3)

;; --- Helper Output Utility ---
(define (show expr)
  (display expr)
  (newline))

;; --- Supplied Examples (S2) ---
;; Example 1: ((42 1 2) (3 4 5) (42 6) (42))
(show (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3))

;; Example 2: ((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))
(show (insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3))

;; Example 3: (7)
(show (insert-if-short 7 '() 3))

;; Example 4: ()
(show (insert-if-short 7 '() 0))

;; --- Boundary & Nested Empty List Cases ---
;; Lengths strictly below (1), equal to (2), and above (3) threshold n = 2, plus nested empty lists
(show (insert-if-short 'x '(() (a) (a b) (a b c)) 2))

;; Top-level list length equals n (3 == 3 -> no top-level insert), inner lists have lengths 0, 2, 3
(show (insert-if-short 9 '(() (1 2) (1 2 3)) 3))

;; Deeply nested empty lists with n = 1 (every empty list becomes (1), outer lists of length 1 stay unchanged)
(show (insert-if-short 1 '(((()))) 1))