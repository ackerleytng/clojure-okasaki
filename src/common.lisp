(defpackage :common
  (:use :cl)
  (:import-from :lparallel
                #:delay
                #:force)
  (:export #:s->list))
(in-package :common)

(defun s->list (stream)
  "Turns a stream into a list. If this stream is infinite, this function will never return"
  (let ((stream-cell (force stream)))
    (when stream-cell
      (cons (car stream-cell) (s->list (cdr stream-cell))))))
