(defsystem "okasaki-cl"
  :version "0.1.0"
  :depends-on ("lparallel")
  :components ((:module "src"
                        :components
                        ((:file "common")
                         (:file "streams")
                         (:file "chapter-2" :depends-on ("common"))
                         (:file "chapter-3-batched-queue"))))
  :description ""
  :in-order-to ((test-op (test-op "okasaki-cl/tests"))))

(defsystem "okasaki-cl/tests"
  :depends-on ("okasaki-cl"
               "rove")
  :components ((:module "tests"
                        :components
                        ((:file "common")
                         (:file "chapter-2")
                         (:file "streams")
                         (:file "chapter-3-batched-queue"))))
  :description "Test system for okasaki-cl"
  :perform (test-op (op c) (symbol-call :rove :run c)))
