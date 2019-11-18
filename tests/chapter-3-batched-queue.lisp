(defpackage :tests/chapter-3-batched-queue
  (:use :cl
        :rove
        :chapter-3-batched-queue))
(in-package :tests/chapter-3-batched-queue)

(deftest test-queue-pseudo-constructor
  (testing "test pseudo-constructor"
    (let ((q (queue nil nil)))
      (ok (null (front q)))
      (ok (null (rear q))))
    (let ((q (queue nil (list 1 2))))
      (ok (equal (list 2 1) (front q)))
      (ok (null (rear q))))))

(deftest test-empty-queue
  (testing "empty queue"
    (ok (empty-queue-p (empty-queue))))
  (testing "empty queue true after emptying"
    (ok (empty-queue-p (tail (snoc (empty-queue) 1))))))

(deftest test-snoc
  (testing "test that snoc queues a new element behind"
    (ok (equal (list 1 2)
               (q->list (snoc (snoc (empty-queue) 1) 2)))))
  (testing "test implementation of snoc"
    (let ((q (snoc (snoc (empty-queue) 1) 2)))
      (ok (equal (list 1)
                 (front q)))
      (ok (equal (list 2)
                 (rear q))))))

(deftest test-head
  (testing "test that head gets the first element in the queue"
    (ok (equal 1
               (head (snoc (empty-queue) 1))))))

(deftest test-tail
  (testing "test that tail removes the first item of the queue"
    (ok (empty-queue-p (tail (snoc (empty-queue) 1))))
    (ok (equal (list 2)
               (q->list (tail (snoc (snoc (empty-queue) 1) 2)))))))
