;;;; SVG library

(in-package :land-of-lisp.svg)

(defun print-tag (name alist closing-p)
  (princ #\<)
  (when closing-p
    (princ #\/))
  (princ (string-downcase name))
  (mapc (lambda (att)
	  (format t " ~a=\"~a\""
		  (string-downcase (car att))
		  (cdr att)))
	alist)
  (princ #\>))

(defmacro split (val yes no)
  (let ((g (gensym)))
    `(let ((,g ,val))
       (if ,g
	   (let ((head (car ,g))
		 (tail (cdr ,g)))
	     ,yes)
	   ,no))))

(defun pairs (lst)
  (labels ((f (lst acc)
	     (split lst
		    (if tail
			(f (cdr tail)
			   (cons (cons head (car tail)) acc))
			(reverse acc))
		    (reverse acc))))
    (f lst nil)))

(defmacro tag (name attributes &body body)
  `(progn (print-tag ',name
		     (list ,@(mapcar (lambda (x)
				       `(cons ',(car x) ,(cdr x)))
				     (pairs attributes)))
		     nil)
	  ,@body
	  (print-tag ',name nil t)))

(defmacro svg (&body body)
  `(tag svg (xmlns "http://www.w3.org/2000/svg"
	     "xmlns:xlink" "http://www.w3.org/1999/xlink")
     ,@body))

(defun brightness (color amount)
  (mapcar (lambda (x)
	    (min 255 (max 0 (+ x amount))))
	  color))

(defun svg-style (color)
  (format nil
	  "~{fill:rgb(~a,~a,~a);stroke:rgb(~a,~a,~a)~}"
	  (append color
		  (brightness color -100))))

(defun circle (centre radius color)
  (tag circle 
      (cx (car centre)
       cy (cdr centre)
       r radius
       style (svg-style color))))

(defun polygon (points color)
  (tag polygon (points (format nil
			       "~{~a,~a ~}"
			       (mapcan (lambda (tp)
					 (list (car tp) (cdr tp)))
				       points))
		       style (svg-style color))))
