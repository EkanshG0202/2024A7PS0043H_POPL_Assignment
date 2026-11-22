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

;; --- 1. Supplied Examples via print-insert-result (reads from stdin) ---
(print-insert-result)
(print-insert-result)
(print-insert-result)
(print-insert-result)

;; --- 2. Edge Cases: Nested Empty Lists & Boundary Lengths (n-1, n, n+1) ---
;; Threshold n = 2: lengths 0, 1 get 'b; lengths 2, 3 unchanged; outer length 4 unchanged
(show (insert-if-short 'b '(() (1) (1 2) (1 2 3)) 2))
;; Expected: ((b) (b 1) (1 2) (1 2 3))

;; Deeply nested empty lists with n = 1
(show (insert-if-short 9 '(((()))) 1))
;; Expected: ((((9))))

;; --- 3. Stress Test A: Nesting Depth 100 ---
(define (make-nested-depth d inner)
  (if (= d 0)
      inner
      (make-nested-depth (- d 1) (cons inner '()))))

(define deep-100 (make-nested-depth 100 '()))
;; Each level has length 1 except innermost '() which has length 0.
;; With n = 1, only innermost '() becomes (x); with n = 2, all 101 lists get x.
(define res-deep-n1 (insert-if-short 'x deep-100 1))
(define res-deep-n2 (insert-if-short 'x deep-100 2))
(show (my-length res-deep-n1)) ;; Expected: 1
(show (my-length res-deep-n2)) ;; Expected: 2

;; --- 4. Stress Test B: 10,000-Element List ---
(define (make-flat-list k)
  (let loop ((i k) (acc '()))
    (if (= i 0)
        acc
        (loop (- i 1) (cons i acc)))))

(define big-10k (make-flat-list 10000))
(show (my-length (insert-if-short 'head big-10k 10000))) ;; Expected: 10000 (not < 10000)
(show (my-length (insert-if-short 'head big-10k 10001))) ;; Expected: 10001 (< 10001 -> inserted)
(show (car (insert-if-short 'head big-10k 10001)))       ;; Expected: head