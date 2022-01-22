;;;; package.lisp


(ql:quickload "cl-pdf")
(ql:quickload "fiveam")

(defpackage #:ics2pdf
  (:use #:cl :cl-pdf)
  (:export
   :make-calendar-event
   :calendar-event
   :find-hour-of-day))
