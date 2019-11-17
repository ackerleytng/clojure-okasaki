(defpackage :tests/streams
  (:use :cl
        :rove)
  (:import-from :common
                #:s->list)
  (:import-from :chapter-2
                #:s-take)
  (:import-from :streams
                #:range))
(in-package :tests/streams)

(deftest test-range
  (testing "range should be able generate streams of numbers"
    (ok (equal (list 0 1 2 3 4 5 6 7 8 9)
               (s->list (s-take 10 (range)))))))
