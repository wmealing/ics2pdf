;;;; ics2pdf.asd

(asdf:defsystem #:ics2pdf
  :description "Given an ics file, create a pdf of the calendar"
  :author "wmealing@gmail.com"
  :license  "artistic license"
  :version "0.0.1"
  :serial t
  :depends-on (#:alexandria #:cl-ppcre :rutils :str :cl-pdf)
  :components ((:file "package")
               (:file "ics2pdf")
               (:file "ics2pdf-tests")))
