(defpackage :chapter-2
  (:use :cl)
  (:import-from :lparallel
                #:delay
                #:force)
  (:import-from :common
                #:s->list)
  (:export #:s-take
           #:s-drop
           #:s-append
           #:s-reverse))
(in-package :chapter-2)

;;; A stream is a suspended stream-cell (delay <stream-cell>)
;;; A stream-cell is either nil, or (cons <value> <stream>)

(defun s-take (n stream)
  "Takes the first n elements from stream, returning a stream"
  (delay
    (if (zerop n) nil
        (let ((stream-cell (force stream)))
          (when stream-cell
            (cons (car stream-cell) (s-take (1- n) (cdr stream-cell))))))))

(defun s-drop (n stream)
  "Drops the first n elements from stream, returning a stream"
  ;; This is a monolithic stream function, because all the calls to
  ;;   s-drop-prime are never delayed; they are dropped when the
  ;;   after-dropping-stream is created
  ;; s-reverse is also a monolithic stream function (see below)
  (delay
    (labels ((s-drop-prime (n stream)
               (let ((stream-cell (force stream)))
                 (cond ((zerop n) stream-cell)
                       ((null stream-cell) nil)
                       (t (s-drop-prime (1- n) (cdr stream-cell)))))))
      (s-drop-prime n stream))))

(defun s-append (s u)
  "Appends stream u after stream s"
  ;; s-append is incremental (as opposed to monolithic (see s-drop))
  ;; It constructs a new stream from the first two, and creates suspensions
  ;;   that will eventually calculate the rest of the appended list
  (delay
    (let ((s-stream-cell (force s))
          (u-stream-cell (force u)))
      (if (null s-stream-cell) u-stream-cell
          (cons (car s-stream-cell) (s-append (cdr s-stream-cell) u))))))

(defun s-reverse (stream)
  "Returns stream, reversed"
  (delay
    ;; This function does all the work (reversing, and forcing every delay in stream) at once.
    ;; (delay 2) is an example of what Okasaki calls trivial suspensions.
    ;; He believes that a good compiler should create these suspensions in already-memoized form.
    ;; Without this compiler optimization, memoization is something like
    ;;   `if forced, return value, else compute value`, which is already O(1)
    ;; See tests/chapter-2.lisp for more details
    (labels ((rev (stream reversed)
               (let ((stream-cell (force stream)))
                 (if (null stream-cell) reversed
                     (rev (cdr stream-cell) (cons (car stream-cell) (delay reversed)))))))
      (rev stream nil))))

;; Other function written to test understanding

(defun s-mapcar (f stream)
  (delay
    (let ((stream-cell (force stream)))
      (when stream-cell
        (cons (funcall f (car stream-cell)) (s-mapcar f (cdr stream-cell)))))))

;; (s->list (s-mapcar #'1+ (s-take 10 (range))))
