;;;; land-of-lisp.asd

(asdf:defsystem :land-of-lisp
  :serial t
  :components ((:file "package")
	       (:file "graph-lib")
               (:file "wizard")
	       (:file "wumpus")
	       (:file "orc-battle")))

