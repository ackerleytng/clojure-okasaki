(defpackage :chapter-3-batched-queue
  (:use :cl)
  (:export #:queue
           #:empty-queue
           #:empty-queue-p
           #:snoc
           #:head
           #:tail
           #:q->list
           #:front
           #:rear))
(in-package :chapter-3-batched-queue)

(defclass queue ()
  ((front
    :initarg :front
    :accessor front
    :initform (error "You didn't specify :front"))
   (rear
    :initarg :rear
    :accessor rear
    :initform (error "You didn't specify :rear"))))

(defun queue (front rear)
  "Pseudo-constructor for a queue, maintains the invariant that
   front will never be nil unless rear is nil"
  (if front
      (make-instance 'queue :front front :rear rear)
      (make-instance 'queue :front (reverse rear) :rear nil)))

(defun empty-queue ()
  (queue nil nil))

(defun empty-queue-p (q)
  (null (front q)))

(defun snoc (q element)
  (queue (front q) (cons element (rear q))))

(defun head (q)
  (if (empty-queue-p q) (error "Queue is empty")
      (car (front q))))

(defun tail (q)
  (if (empty-queue-p q) (error "Queue is empty")
      (queue (cdr (front q)) (rear q))))

(defun q->list (q)
  "Converts a queue to a list for debugging"
  (cons (head q) (ignore-errors (q->list (tail q)))))
