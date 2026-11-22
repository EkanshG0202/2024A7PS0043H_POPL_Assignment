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

;; --- S2.c Tests: make-inserter with various length predicates ---

;; 1. Insert 'empty only into empty lists: len-ok? = (lambda (len) (= len 0))
(define insert-into-empty (make-inserter 'empty (lambda (len) (= len 0))))
(show (insert-into-empty '(() (1) (() 2) (3 4))))
;; Expected: ((empty) (1) ((empty) 2) (3 4))

;; 2. Insert 'long into lists with length >= 2: len-ok? = (lambda (len) (>= len 2))
(define insert-if-long (make-inserter 'long (lambda (len) (>= len 2))))
(show (insert-if-long '((1) (2 3) ((4 5 6) ()))))
;; Expected: (long (1) (long 2 3) (long (long 4 5 6) ()))

;; 3. Insert '* into lists with even length (0, 2, 4, ...):
(define (even-len? len)
  (if (= len 0)
      #t
      (if (= len 1)
          #f
          (even-len? (- len 2)))))
(define insert-if-even (make-inserter '* even-len?))
(show (insert-if-even '(() (a) (b c) (d e f))))
;; Expected: (* (*) (a) (* b c) (d e f))

;; --- S2.b/S2.c Regression Tests: insert-if-short ---

;; Supplied Example 1: ((42 1 2) (3 4 5) (42 6) (42))
(show (insert-if-short 42 '((1 2) (3 4 5) (6) ()) 3))

;; Supplied Example 2: ((0 (0 1) 2) (0 3) (0 (4 5 6) (0)))
(show (insert-if-short 0 '(((1) 2) (3) ((4 5 6) ())) 3))

;; Supplied Example 3: (7)
(show (insert-if-short 7 '() 3))

;; Supplied Example 4: ()
(show (insert-if-short 7 '() 0))

;; Boundary check: lengths 0, 1, 2, 3 with threshold n = 2
(show (insert-if-short 'x '(() (a) (a b) (a b c)) 2))
;; Expected: ((x) (x a) (a b) (a b c))