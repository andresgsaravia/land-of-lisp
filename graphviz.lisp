;;;; Library to use graphviz

(in-package :land-of-lisp.graphviz)

(defparameter *max-label-length* 30)

(defun dot-name (exp)
  (substitute-if #\_ (complement #'alphanumericp) (prin1-to-string exp)))

(defun dot-label (exp)
  (if exp
      (let ((s (write-to-string exp :pretty nil)))
	(if (> (length s) *max-label-length*)
	    (concatenate 'string (subseq s 0 (- *max-label-length* 3)) "...")
	    s))
      ""))

(defun nodes->dot (nodes)
  (mapc (lambda (node)
	  (fresh-line)
	  (princ (dot-name (car node)))
	  (princ "[label=\"")
	  (princ (dot-label node))
	  (princ "\"];"))
	nodes))

;; directed graphs

(defun edges->dot (edges)
  (mapc (lambda (node)
	  (mapc (lambda (edge)
		  (fresh-line)
		  (princ (dot-name (car node)))
		  (princ "->")
		  (princ (dot-name (car edge)))
		  (princ "[label=\"")
		  (princ (dot-label (cdr edge)))
		  (princ "\"];"))
		(cdr node)))
	edges))

(defun graph->dot (nodes edges)
  (princ "digraph{")
  (nodes->dot nodes)
  (edges->dot edges)
  (princ "}"))

#+sbcl
(defun sbcl-shell (x)
  (sb-ext:run-program "/bin/sh" (list "-c" x) :output t))

(defun dot->png (fname thunk)
  (with-open-file (*standard-output*
		   fname
		   :direction :output
		   :if-exists :supersede)
    (funcall thunk))
  #+clisp (ext:shell (concatenate 'string "dot -Tpng -O " fname))
  #+sbcl (sbcl-shell (concatenate 'string "dot -Tpng -O " fname))
  #-(or clisp sbcl) (error "DOT->PNG not implemented"))

(defun graph->png (fname nodes edges)
  (dot->png fname
	    (lambda ()
	      (graph->dot nodes edges))))

;; undirected graphs

(defun uedges->dot (edges)
  (maplist (lambda (lst)
	     (mapc (lambda (edge)
		     (unless (assoc (car edge) (cdr lst))
		       (fresh-line)
		       (princ (dot-name (caar lst)))
		       (princ "--")
		       (princ (dot-name (car edge)))
		       (princ "[label=\"")
		       (princ (dot-label (cdr edge)))
		       (princ "\"];")))
		   (cdar lst)))
	   edges))

(defun ugraph->dot (nodes edges)
  (princ "graph{")
  (nodes->dot nodes)
  (uedges->dot edges)
  (princ "}"))

(defun ugraph->png (fname nodes edges)
  (dot->png fname 
	    (lambda ()
	      (ugraph->dot nodes edges))))