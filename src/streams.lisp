(defpackage :streams
  (:use :cl)
  (:import-from :lparallel
                #:delay)
  (:export #:range))
(in-package :streams)

(defun range (&optional end (start 0))
  "Returns a stream of integers between start and end.
   If not specified, start is 0, and end is infinite."
  (delay
    (if (and (not (null end)) (= start end))
        nil
        (cons start (range end (1+ start))))))
