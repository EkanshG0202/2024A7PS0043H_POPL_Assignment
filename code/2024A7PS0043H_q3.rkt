#lang racket/base

;; --- Tree Accessors ---

(define (node-val tree)
  (car tree))

(define (left-sub tree)
  (cadr tree))

(define (right-sub tree)
  (caddr tree))

;; --- List Utility ---

;; Custom append since built-in append is forbidden
(define (my-append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (my-append (cdr xs) ys))))

;; --- Traversal Helpers ---

;; Returns the inorder traversal list (left, root, right)
(define (inorder tree)
  (if (null? tree)
      '()
      (my-append (inorder (left-sub tree))
                 (cons (node-val tree)
                       (inorder (right-sub tree))))))

;; Returns the preorder traversal list (root, left, right)
(define (preorder tree)
  (if (null? tree)
      '()
      (cons (node-val tree)
            (my-append (preorder (left-sub tree))
                       (preorder (right-sub tree))))))

;; Returns the postorder traversal list (left, right, root)
(define (postorder tree)
  (if (null? tree)
      '()
      (my-append (postorder (left-sub tree))
                 (my-append (postorder (right-sub tree))
                            (cons (node-val tree) '())))))

;; --- Output Helper ---

(define (display-line val)
  (display val)
  (newline))

;; --- Public Functions (S1.a & S1.b) ---

;; S1.a: Prints the inorder traversal list on one line
(define (print-inorder tree)
  (display-line (inorder tree)))

;; S1.b: Prints inorder, preorder, and postorder on three separate lines
(define (print-all-traversals tree)
  (display-line (inorder tree))
  (display-line (preorder tree))
  (display-line (postorder tree)))