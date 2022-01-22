;;;; ics2pdf.lisp

(in-package #:ics2pdf)

;; an ics event in lisp format.
(defstruct calendar-event summary start end)

;; tbh i'm not sure what this is for ?
(defun to-ppt (size-in-mm)
  (/ size-in-mm 1/72 25.4))

;; size 209.6 mm x 157.2
(defvar *remarkable-width* (to-ppt 157.2))
(defvar *remarkable-height* (to-ppt 209.6))


(defvar *big-date-height* 2)
(defvar *element-padding* 10)
(defvar *page-border* 5)

(defvar *box-offset-x* *page-border*)
(defvar *box-offset-y* (- *remarkable-height* (+ *page-border* *big-date-height*)))

(defvar *box-height* (+ (* *remarkable-height* -1) 55))
(defvar *box-width*  (- *remarkable-width* (* *page-border* 2)))


(defun reload() (ql:quickload :ics2pdf) (devel))
(defun runtests ()  (fiveam:run!))

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

(defun devel ()
  (format t "lets go~%")

  ;;                                                                         S M H D M YYYY
  (let ((event-list (list (make-calendar-event :start (encode-universal-time 0 0 7 1 1 1920)
                                               :end   (encode-universal-time 0 0 8 1 1 1920)
                                               :summary "event"))))
    (create-pdf event-list )
    )
  )


(defun draw-date ()
  (format t "Date date ...~%")
  (pdf:with-saved-state
    (pdf:in-text-mode
      (pdf:translate *page-border*
                     (- *remarkable-height* (+ *page-border* *element-padding*)))
      (pdf:set-font (pdf:get-font "Helvetica") 32)
      (pdf:draw-text "Jan 20 2022"))))

(defun draw-backing-surface (box-width box-height)
  (pdf:with-saved-state
    (pdf:in-text-mode
      (pdf:translate *box-offset-x*
                     *box-offset-y*)
      (pdf:set-rgb-fill 0.9 0.9 0.9)
      (pdf:rectangle 0 0
                     box-width
                     box-height )
      (pdf:close-fill-and-stroke))))

(defun find-hour-of-day (users-hour event)
  ;; desconstruct the time
  (multiple-value-bind
        (second minute hour date month year day-of-week dst-p tz) (decode-universal-time (calendar-event-start event))
    (format t "~%EVENT: ~s ~%" (calendar-event-start event))
    ;;    (format t "DATE: |~s| ~%" date)
    ;; encode-universal-time second minute hour date month year &optional time-zone
    (encode-universal-time 0 0 users-hour date month year tz)
    ))

(defun draw-event (event)
  (format t "Drawing event..~%")

  ;; ive chosen thse as arbitary
  (let* ( (six-am (find-hour-of-day 6 event))   ;; start of the visible time.
          (six-pm (find-hour-of-day 18 event))  ;; end of the visible time.
          (event-start-offset-from-six-am (- (calendar-event-start event) six-am))
          (event-end-offset-from-six-am (- (calendar-event-end event) six-am))
          (six-to-six-delta (- six-pm six-am))
          (ratio (/ (* -1 six-to-six-delta ) *box-height* ) )
          (start (/ event-start-offset-from-six-am ratio))
          (end (/ event-end-offset-from-six-am ratio))
          )

    (pdf:with-saved-state
      (pdf:set-rgb-stroke 0 0 0)
      (pdf:set-rgb-fill 0.8 0.8 0.8)
      (pdf:rectangle *box-offset-x* (* -1 start)  *box-width* (* -1 end) :radius 4) ;; working.
      (pdf:close-fill-and-stroke)
      )

    ))




(defun create-pdf (event-list &optional (filename "ex5.pdf"))
  (let* ((width (to-ppt 157.2)) ;; size 209.6 mm x 157.2
         (height (to-ppt 209.6))
         (box-height (+ (* *remarkable-height* -1) 55))
         (box-width (- *remarkable-width* (* *page-border* 2)))
         )

    (pdf:with-document ()
      (pdf:with-page (:bounds (rutils:vec 0 0 *remarkable-width* *remarkable-height*))

        ;; draw big date at top
        (draw-date)

        ;; draw the backing grey surface.
        (draw-backing-surface box-width box-height)

        (pdf:translate 0 *box-offset-y*) ;; probably shouldnt be necessary

        (draw-event (first event-list))

        )
      (pdf:write-document filename))))
