#lang racket/base

;; --- List Helpers (S2.b) ---

;; Returns the number of top-level elements in lst (tail-recursive)
(define (my-length lst)
  (let loop ((xs lst) (acc 0))
    (if (null? xs)
        acc
        (loop (cdr xs) (+ acc 1)))))

;; Applies single-argument procedure f to each top-level element of lst in order
(define (my-map f lst)
  (if (null? lst)
      '()
      (cons (f (car lst))
            (my-map f (cdr lst)))))