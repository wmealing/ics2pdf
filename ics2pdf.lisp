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
(defvar *element-padding* 10)


(defvar *page-border* 20)


(defun reload() (ql:quickload :ics2pdf) (devel))

(defun devel ()
  (format t "lets go~%")

  (let ((event-list (list (make-calendar-event :start "a"
                                               :end "b"
                                               :summary "event"))))
    (create-pdf event-list )
    )
  )

(defun draw-date ()
  (format t "Date date ...~%")
  (pdf:with-saved-state
    (pdf:in-text-mode
      (pdf:translate (* 1 *page-border*)
                     (- *remarkable-height* (+ *page-border* *element-padding*)))
      (pdf:set-font (pdf:get-font "Helvetica") 32)
      (pdf:draw-text "Jan 10 2022"))))

(defun draw-backing-surface (box-width box-height)
  (pdf:with-saved-state
    (pdf:in-text-mode
      (pdf:translate *page-border*
                     (- *remarkable-height* (+ *page-border* (* *element-padding* 2))))
      (pdf:set-rgb-fill 0.9 0.9 0.9)
      (pdf:rectangle 0 0
                     box-width
                     box-height )
      (pdf:close-fill-and-stroke))))

(defun draw-event (a)
  (format t "Drawing event..~%")
  )

(defun create-pdf (event-list &optional (filename "ex5.pdf"))
  (let* ((width (to-ppt 157.2)) ;; size 209.6 mm x 157.2
         (height (to-ppt 209.6))
         (helvetica (pdf:get-font "Helvetica"))
         (box-height (+ (* *remarkable-height* -1) 55))
         (box-width (- *remarkable-width* (* *page-border* 2)))
         )

    (pdf:with-document ()
      (pdf:with-page (:bounds (rutils:vec 0 0 *remarkable-width* *remarkable-height*))

        ;; draw big date at top
        (draw-date)

        ;; draw the backing grey surface.
        (draw-backing-surface box-width box-height)

        (pdf:translate 0 480)

        (draw-event ev1)


        )
      (pdf:write-document filename))))
