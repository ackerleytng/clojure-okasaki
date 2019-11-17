(defpackage :streams
  (:use :cl)
  (:import-from :lparallel
                #:delay)
  (:export #:range
           #:printing-range))
(in-package :streams)

(defun range (&optional end (start 0))
  "Returns a stream of integers between start and end.
   If not specified, start is 0, and end is infinite."
  (delay
    (if (and end (= start end))
        nil
        (cons start (range end (1+ start))))))

(defun printing-range (&optional end (start 0))
  "Returns a stream of integers between start and end.
   If not specified, start is 0, and end is infinite.

   Also prints numbers as it is forced, so we can check when it is forced"
  (delay
    (format t "|~D|" start)
    (if (and end (= start end))
        nil
        (cons start (printing-range end (1+ start))))))
