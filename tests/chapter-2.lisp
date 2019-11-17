(defpackage :tests/chapter-2
  (:use :cl
        :lparallel
        :rove
        :chapter-2)
  (:import-from :common
                #:s->list)
  (:import-from :streams
                #:range
                #:printing-range))
(in-package :tests/chapter-2)

(deftest test-s-take
  (testing "s-take should take n elements from stream"
    (ok (equal nil
               (let ((stream (delay (cons 1 (delay (cons 2 (delay (cons 3 (delay nil)))))))))
                 (s->list (s-take 0 stream)))))
    (ok (equal (list 1 2)
               (let ((stream (delay (cons 1 (delay (cons 2 (delay (cons 3 (delay nil)))))))))
                 (s->list (s-take 2 stream)))))
    (ok (equal (list 0 1 2 3 4)
               (s->list (s-take 5 (range)))))))

(deftest test-s-drop
  (testing "s-drop should drop n elements from stream"
    (ok (equal (list 3 4 5 6 7 8 9)
               (s->list (s-drop 3 (s-take 10 (range))))))))

(deftest test-s-append
  (testing "s-append should append one stream after the other"
    (ok (equal (list 0 1 0 1 2)
               (s->list (s-append (s-take 2 (range)) (s-take 3 (range))))))))

(deftest test-s-reverse
  (testing "s-reverse should reverse a stream"
    (ok (equal (list 5 4 3 2 1 0)
               (s->list (s-reverse (s-take 6 (range))))))))

;;; These two lines of code are used to check how reverse works

;; Sanity checks:
;; Running the next line should print nothing, since the printing is delayed
#+nil
(printing-range)

;; Running the next line should print |0||1||2||3||4||5|
;;   This shows that the printing happens when forced
#+nil
(s->list (s-take 6 (printing-range)))

;; Running the next line should print |0||1||2||3||4||5|
;;   Because it is printed in ascending order, we know that the delays
;;   were forced when the reversed stream was created. When s->list is called,
;;   the new delays containing only the extracted results were returned,
;;   hence no further the printing happened
#+nil
(s->list (s-reverse (s-take 6 (printing-range))))
