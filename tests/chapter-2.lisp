(defpackage :tests/chapter-2
  (:use :cl
        :lparallel
        :rove)
  (:import-from :common
                #:s->list)
  (:import-from :chapter-2
                #:s-take))
(in-package :tests/chapter-2)

(deftest test-s-take
  (testing "s-take should take n elements from stream"
    (ok (equal nil
               (let ((stream (delay (cons 1 (delay (cons 2 (delay (cons 3 (delay nil)))))))))
                 (s->list (s-take 0 stream)))))
    (ok (equal (list 1 2)
               (let ((stream (delay (cons 1 (delay (cons 2 (delay (cons 3 (delay nil)))))))))
                 (s->list (s-take 2 stream)))))))
