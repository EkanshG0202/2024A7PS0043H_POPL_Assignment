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