;;;; land-of-lisp.asd

(asdf:defsystem :land-of-lisp
  :serial t
  :components ((:file "package")
	       (:file "graphviz")
               (:file "wizard")
	       (:file "wumpus")
	       (:file "orc-battle")
	       (:file "evolution")))

