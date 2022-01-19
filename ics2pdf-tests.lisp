(defpackage ics2pdf-tests
  (:use #:cl :cl-pdf :fiveam)
  (:export)
  )

(in-package :ics2pdf-tests)

(test add-2
      "Test the ADD-2 function" ;; a short description
      ;; the checks
      (is (= 2 (add-2 0)))
      (is (= 0 (add-2 -2))))
