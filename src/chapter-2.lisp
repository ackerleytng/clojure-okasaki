(defpackage :chapter-2
  (:use :cl)
  (:import-from :lparallel
                #:delay
                #:force)
  (:import-from :common
                #:s->list)
  (:export #:s-take))
(in-package :chapter-2)

;;; A stream is a suspended stream-cell (delay <stream-cell>)
;;; A stream-cell is either nil, or (cons <value> <stream>)

(defun s-take (n stream)
  "Takes the first n elements from stream s, returning a stream"
  (delay
    (if (zerop n) nil
        (let ((stream-cell (force stream)))
          (when stream-cell
            (cons (car stream-cell) (s-take (1- n) (cdr stream-cell))))))))

(defun s-mapcar (f stream)
  (delay
    (let ((stream-cell (force stream)))
      (when stream-cell
        (cons (funcall f (car stream-cell)) (s-mapcar f (cdr stream-cell)))))))

;; (s->list (s-mapcar #'1+ (s-take 10 (range))))
