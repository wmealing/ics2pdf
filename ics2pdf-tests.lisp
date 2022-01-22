(defpackage ics2pdf-tests
  (:use #:cl :cl-pdf :fiveam)
  (:export)
  )

(in-package :ics2pdf-tests)

(test add-2
  "Test the ADD-2 function" ;; a short description
  ;; the checks
  (is (= 2 (+ 2 0)))
  (is (= 0 (+ 2 -2))))


(defun print-nicely (ti)

  (multiple-value-bind
        (second minute hour date month year day-of-week dst-p tz) (decode-universal-time ti)
    (format t "~%It is now ~2,'0d:~2,'0d:~2,'0d of ~a, ~d/~2,'0d/~d (GMT~@d)~%"
            hour
            minute
            second
            day-of-week
            month
            date
            year
            (- tz)))

  )
(test find-hour-of-same-day
  "given an event find an hour on that day."
  (let* ((first-hour (encode-universal-time 0 0 1 1 1 1920)) ;; 1:00:00 on jan 1 1920
         (random-time-on-same-day (encode-universal-time 0 11 4 1 1 1920)) ;; 4:11:00 1st jan 1920
         (event (ics2pdf:make-calendar-event :start random-time-on-same-day
                                             :end random-time-on-same-day
                                             :summary "test event summary"))
         )
    (is (= first-hour (ics2pdf:find-hour-of-day 1 event)))
    )

  )
