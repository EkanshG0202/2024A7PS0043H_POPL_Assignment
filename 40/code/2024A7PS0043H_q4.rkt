#lang racket/base

;; --- List Helpers (S2.b) ---

;; Returns the number of top-level elements in lst (tail-recursive)
(define (my-length lst)
  (let loop ((xs lst) (acc 0))
    (if (null? xs)
        acc
        (loop (cdr xs) (+ acc 1)))))

;; Tail-recursive list reversal helper for tail-recursive my-map
(define (my-reverse lst)
  (let loop ((xs lst) (acc '()))
    (if (null? xs)
        acc
        (loop (cdr xs) (cons (car xs) acc)))))

;; Applies single-argument procedure f to each top-level element of lst in order
;; (tail-recursive so 10,000-element lists use O(1) stack frames)
(define (my-map f lst)
  (let loop ((xs lst) (acc '()))
    (if (null? xs)
        (my-reverse acc)
        (loop (cdr xs) (cons (f (car xs)) acc)))))

;; --- Higher-Order Conditional Insertion (S2.c) ---

;; Returns a function taking a list and inserting atom x at the front of every
;; list (at all nesting levels) whose original top-level length satisfies len-ok?
(define (make-inserter x len-ok?)
  (letrec ((insert-fn
            (lambda (lst)
              (let ((processed
                     (my-map (lambda (elem)
                               (if (or (null? elem) (pair? elem))
                                   (insert-fn elem)
                                   elem))
                             lst)))
                (if (len-ok? (my-length lst))
                    (cons x processed)
                    processed)))))
    insert-fn))

;; Inserts atom x at the front of lst and every nested sublist whose original length < n
(define (insert-if-short x lst n)
  ((make-inserter x (lambda (len) (< len n))) lst))

;; --- Standard I/O Entry Point (S2.a) ---

;; Reads x, lst, and n from standard input in order, prints result with newline
(define (print-insert-result)
  (let* ((x (read))
         (lst (read))
         (n (read)))
    (display (insert-if-short x lst n))
    (newline)))