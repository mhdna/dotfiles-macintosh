(use-package eglot
  ;; :ensure t
  :bind (:map eglot-mode-map
              ("<tab>" . company-complete)
              ("M-n" . flymake-goto-next-error)
              ("M-p" . flymake-goto-prev-error)
              ("C-c l r" . eglot-rename)
              ("C-c l f" . eglot-format)
              ("C-c l F" . eglot-format-buffer)
              ("C-c l a" . eglot-code-actions))
  :hook
  (python-mode . eglot-ensure)
   (c++-mode . eglot-ensure)
   ;; (LaTeX-mode . eglot-ensure)
  ;;  (c++-mode . eglot-ensure)
   (java-mode . eglot-ensure)

  ;; :config
  ;; (setcdr (assq 'java-mode eglot-server-programs)
  ;;         `("jdtls" "-data" "/home/user/.cache/emacs/workspace/"
  ;;           "-javaagent:/home/user/work/src/lombok.jar"
  ;;           "-Xbootclasspath/a:/home/user/work/src/lombok.jar"
  ;;           "--jvm-arg=-XX:+UseG1GC"
  ;;           "--jvm-arg=-XX:+UseStringDeduplication"
  ;;           "-Djava.format.settings.url=file:///home/user/code-format.xml"
  ;;           "-Djava.format.settings.profile=myown"))
  :custom
  ((eglot-autoshutdown t)))

(use-package eglot-java
  :ensure t)
;; (add-hook 'java-mode-hook
;;           (lambda ()
;;             (setq-local eglot-workspace-configuration
;;                         '((:java . ("org.eclipse.jdt.core.formatter.lineSplit"
;;                                     "40"))))))

;; Java development

;; (defconst my-eglot-eclipse-jdt-home
;;   "/home/mah/.emacs.d/jdt-language-server-0.52.0-202003111128/plugins/org.eclipse.equinox.launcher_1.5.700.v20200207-2156.jar"
;;   "Point to eclipse jdt jar.")

;; (defun my-eglot-eclipse-jdt-contact (interactive)
;;   "Contact with the jdt server input INTERACTIVE."
;;   (let ((cp (getenv "CLASSPATH")))
;;     (setenv "CLASSPATH" (concat cp ":" my-eglot-eclipse-jdt-home))
;;     (unwind-protect (eglot--eclipse-jdt-contact nil)
;;       (setenv "CLASSPATH" cp))))

;; (setcdr (assq 'java-mode eglot-server-programs) #'my-eglot-eclipse-jdt-contact)

;; (add-hook 'java-mode-hook 'eglot-ensure)

;; bndings
;; (define-key eglot-mode-map (kbd "C-c r") 'eglot-rename)
;; (define-key eglot-mode-map (kbd "C-c o") 'eglot-code-action-organize-imports)
;; (define-key eglot-mode-map (kbd "C-c h") 'eldoc)
;; (define-key eglot-mode-map (kbd "<f6>") 'xref-find-definitions)

;; (with-eval-after-load 'eglot
;;   (let ((cache
;;          (expand-file-name (md5 (project-root (eglot--current-project)))
;;                            (locate-user-emacs-file
;;                             "eglot-eclipse-jdt-cache"))))
;;     (add-to-list 'eglot-server-programs
;;                  `(java-mode "jdtls" "-data" ,cache))))

;; :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
;;        (python-mode . eglot)
;;        (html-mode . eglot)
;;        (css-mode . eglot)
;;        (c++-mode . eglot)
;;        (c-mode . eglot)
;;        (javascript-mode . eglot)
;;        ))

(provide 'init-eglot)
