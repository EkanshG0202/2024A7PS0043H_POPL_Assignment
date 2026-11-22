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

;; --- Height & Leaf Helpers ---

;; Returns the height of the tree (0 for empty, 1 + max(left, right) otherwise)
(define (tree-height tree)
  (if (null? tree)
      0
      (+ 1 (max (tree-height (left-sub tree))
                (tree-height (right-sub tree))))))

;; Predicate: true iff tree is a non-empty node with both subtrees empty
(define (leaf? tree)
  (and (not (null? tree))
       (null? (left-sub tree))
       (null? (right-sub tree))))

;; Returns the total number of leaves in the tree
(define (count-leaves tree)
  (if (null? tree)
      0
      (if (leaf? tree)
          1
          (+ (count-leaves (left-sub tree))
             (count-leaves (right-sub tree))))))

;; --- Output Helper ---

(define (display-line val)
  (display val)
  (newline))

;; --- Public Functions (S1.a, S1.b, S1.c) ---

;; S1.a: Prints the inorder traversal list on one line
(define (print-inorder tree)
  (display-line (inorder tree)))

;; S1.b: Prints inorder, preorder, and postorder on three separate lines
(define (print-all-traversals tree)
  (display-line (inorder tree))
  (display-line (preorder tree))
  (display-line (postorder tree)))

;; S1.c: Prints (height leaf-count) on one line
(define (print-height-and-leaves tree)
  (display-line (list (tree-height tree) (count-leaves tree))))