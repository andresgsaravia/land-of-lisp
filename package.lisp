;;;; package.lisp

;; (defpackage :land-of-lisp
;;   (:use :cl))

(defpackage :land-of-lisp.wizard
  (:use :cl))

(defpackage :land-of-lisp.graphviz
  (:use :cl)
  (:export :graph->dot
	   :dot->png
	   :graph->png
	   :ugraph->dot
	   :ugraph->png))

(defpackage :land-of-lisp.wumpus
  (:use :cl
	:land-of-lisp.graphviz))

(defpackage :land-of-lisp.orc-battle
  (:use :cl))

(defpackage :land-of-lisp.evolution
  (:use :cl))

(defpackage :land-of-lisp.robots
  (:use :cl))

(defpackage :land-of-lisp.web-server
  (:use :cl
	:usocket)
  (:export :serve))

(defpackage :land-of-lisp.dice-of-doom
  (:use :cl))