;; Example customisation file for Ansys mode under Unix and Windows
;; `default_el' can be used as a system wide startup file after
;; adjusting and renaming it to `default.el'.  And moving it e. g. to
;; `/usr/local/share/emacs/site-lisp' or `EMACS_INSTALLDIR/site-lisp'
;; Copyright (C) 2006 - 2010  H. Dieter Wilhelm GPL V3


(setq ansys-install-directory "/appl")	; Unix
;(setq ansys-install-directory "C:\\Program Files") ;Windows

(setq ansys-current-ansys-version "120") ;which Ansys version is used 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load-path for the Ansys mode

(add-to-list 'load-path "C:\\DIRECTORY-PATH\\WHERE\\THE\\ANSYS-MODE\\FILES\\RESIDE")
;for example: "c:\\emacs\\emacs-23.1" with Windows
;or "/usr/local/src/emacs-23.1/my-stuff" for a Gnu/Linux system

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; fontification (highlighting) levels 0,1,2 are available

;; experimental user variables highlighting only in level 2 available
(setq ansys-highlighting-level 1)
;; uncommenting the following might slow the editing of large .mac files
;; in level 2
;(setq ansys-dynamic-highlighting-flag t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; autoloading of command definitions

    (autoload 'ansys-mode "ansys-mode" nil t)
    (autoload 'ansys-customise-ansys "ansys-mode" "Activate the function for 
calling a special Ansys customisation buffer." 'interactive)
     (autoload 'ansys-abort-file "ansys-mode" "Activate the function for  aborting Ansys runs." 'interactive)
     (autoload 'ansys-display-error-file "ansys-mode" "Activate the function for inspecting the Ansys error file." 'interactive)
     (autoload 'ansys-start-ansys-help "ansys-mode" "Activate the function for starting the Ansys help browser." 'interactive)
; TODO: -license-file, -license-program variables
     (autoload 'ansys-license-status "ansys-mode" "Activate the function for displaying Ansys license status or starting a license utility." 'interactive)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; file suffixes for autoloading of ansys-mode

;; appropriate file suffixes for which Ansys mode is automatically
;; called for .mac is the macro suffix of ansys i. e. these files can
;; be called directly from the Ansys command line (without the suffix
;; .mac)
(add-to-list 'auto-mode-alist '("\\.mac$" . ansys-mode))
;;  (.dat and .inp are WorkBench's solver input file suffixes)
(add-to-list 'auto-mode-alist '("\\.dat$" . ansys-mode))
(add-to-list 'auto-mode-alist '("\\.inp\\'" . ansys-mode))
;; this is the suffix for "Ansys Neutral Files" which include some APDL.
(add-to-list 'auto-mode-alist '("\\.anf$" . ansys-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; processes stuff

(cond ((string= window-system "x")		;Unix
       ;; for starting the solver & ansys-license-status
       ;;license servers (or license file name)
       ;;specify even the default port for lmutil on Unix
       (setq ansys-license-file
	    "1055@frlifl01.auto.contiwan.com:1055@frlifl02.auto.contiwan.com")
       ;; The Ansys executable
       (setq  ansys-program
	      (concat ansys-install-directory
		      "/ansys_inc/v"
		      ansys-current-ansys-version
		      "/ansys/bin/ansys"
		      ansys-current-ansys-version))
      ;; Tool for the license status
       (setq ansys-lmutil-program
	     (concat
	      ansys-install-directory
	      "/ansys_inc/shared_files/licensing/linx64/lmutil"))
      ;; Ansys help browser executable
       (setq ansys-help-file
	     (concat
	      ansys-install-directory
	      "/ansys_inc/v"
	      ansys-current-ansys-version
	      "/ansys/bin/anshelp"
	      ansys-current-ansys-version)))
      (t     
       ;;else windows?
       
       (setq ansys-license-file "27005@lic-rbg1;27005@lic-rbg2") ;
       (setq ansys-lmutil-program
	     (concat
	      ansys-install-directory
	     "\\Ansys Inc\\Shared Files\\licensing\\win32\\anslic_admin.exe"))
       ;;backslash '\"' on windows mandatory
       (setq ansys-help-file
	     '((concat "\""
		       ansys-install-directory
		       "\\Ansys Inc\\v"
		       ansys-current-ansys-version
		       "\\commonfiles\\jre\intel\\bin\\Javaw.exe\"")
	       "-cp"
	       (concat "\""
		       ansys-install-directory
		       "\\Ansys Inc\\v"
		       ansys-current-ansys-version
		       "\\commonfiles\\help\""
		       "HelpDocView")))))

;; for starting the solver
(setq ansys-license "struct"	     ;which license to use for the run
      ansys-job "file"			;job name
      )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto insertion stuff (in the moment of creating a new APDL file) ;;

(auto-insert-mode 1)
(add-hook 'find-file-hook 'auto-insert)
(setq auto-insert-query t)
(add-to-list 'auto-insert-alist '(ansys-mode . [ansys-skeleton-compilation]))

;; user variables:
;; mode: emacs-lisp
;; end