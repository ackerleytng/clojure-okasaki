(defpackage :tests/common
  (:use :cl
        :lparallel
        :rove)
  (:import-from :common
                #:s->list))
(in-package :tests/common)

(deftest test-s->list
  (testing "s->list should be able to turn a stream into a list"
    (ok (equal (list 1 2 3)
               (let ((stream (delay (cons 1 (delay (cons 2 (delay (cons 3 (delay nil)))))))))
                 (s->list stream))))))
