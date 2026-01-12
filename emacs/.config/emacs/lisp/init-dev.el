;; (use-package company
;;   :ensure t
;;   :hook (prog-mode . company-mode))
;; (add-hook 'after-init-hook 'global-company-mode)

;; Code Completion
;; (use-package corfu
;;   ;; Optional customizations
;;   :custom
;;   (corfu-cycle t)                 ; Allows cycling through candidates
;;   (corfu-auto t)                  ; Enable auto completion
;;   (corfu-auto-prefix 2)
;;   (corfu-auto-delay 0.0)
;;   (corfu-popupinfo-delay '(0.5 . 0.2))
;;   (corfu-preview-current 'insert) ; Do not preview current candidate
;;   (corfu-preselect-first nil)
;;   (corfu-on-exact-match nil)      ; Don't auto expand tempel snippets

;;   ;; Optionally use TAB for cycling, default is `corfu-complete'.
;;   :bind (:map corfu-map
;;               ("M-SPC"			 . corfu-insert-separator)
;;               ("TAB"				 . corfu-next)
;;               ("<escape>"				 . (lambda () (interactive)  (evil-normal-state) (corfu-quit)))
;;               ([tab]      . corfu-next)
;;               ("C-p"				 . corfu-previous)
;;               ("S-TAB"		 . corfu-quit)
;;               ([backtab]  . corfu-previous)
;;               ("RET"				 . corfu-insert)
;;               ("S-<return>"	 . nil))
;;   :hook ((prog-mode . corfu-mode)
;;          (shell-mode . corfu-mode)
;;          (eshell-mode . corfu-mode))
;;   :init
;;   (corfu-history-mode)
;;   (corfu-popupinfo-mode) ; Popup completion info
;;   :config
;;   (add-hook 'eshell-mode-hook
;;             (lambda () (setq-local corfu-quit-at-boundary t
;;                                    corfu-quit-no-match t
;;                                    corfu-auto nil)
;;               (corfu-mode))))

;; (use-package cape
;;   :defer 10
;;   :bind ("C-c f" . cape-file)
;;   :init
;;   ;; Add `completion-at-point-functions', used by `completion-at-point'.
;;   (defalias 'dabbrev-after-2 (cape-capf-prefix-length #'cape-dabbrev 2))
;;   (add-to-list 'completion-at-point-functions 'dabbrev-after-2 t)
;;   (cl-pushnew #'cape-file completion-at-point-functions)
;;   :config
;;   ;; Silence then pcomplete capf, no errors or messages!
;;   (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-silent)

;;   ;; Ensure that pcomplete does not write to the buffer
;;   ;; and behaves as a pure `completion-at-point-function'.
;;   (advice-add 'pcomplete-completions-at-point :around #'cape-wrap-purify))

(use-package yasnippet
  :init
  (setq yas-nippet-dir "~/.emacs.d/snippets")
  (yas-global-mode))
(use-package yasnippet-snippets
  :after yasnippet)

(use-package cape-yasnippet
:ensure nil
:quelpa (cape-yasnippet :fetcher github :repo "elken/cape-yasnippet")

:after yasnippet
:hook ((prog-mode . yas-setup-capf)
       (text-mode . yas-setup-capf)
       (lsp-mode  . yas-setup-capf)
       (sly-mode  . yas-setup-capf))
:bind (("C-c y" . cape-yasnippet)
       ("M-+"   . yas-insert-snippet))
:config
(defun yas-setup-capf ()
  (setq-local completion-at-point-functions
              (cons 'cape-yasnippet
                    completion-at-point-functions)))
(push 'cape-yasnippet completion-at-point-functions))

web stuff
(use-package web-mode
  :config
  (setq web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2
        web-mode-code-indent-offset 2
        web-mode-indent-style 2)
  (add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
  (add-to-list 'auto-mode-alist '("\\.htm\\'" . web-mode)))

(use-package emmet-mode
  :config
  (add-hook 'web-mode-hook 'emmet-mode))

;; Javascript
(use-package js2-mode)
;; set as the default mode for javascript
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(use-package js2-refactor)

;;; LSP
;; Should boost performance with lsp
;; https://emacs-lsp.github.io/lsp-mode/page/performance/
;; (use-package lsp-mode
;;	:defer t
;;	:bind (("C-h ," . help-at-pt-buffer)
;;				 (:map lsp-mode-map
;;							 ("M-<return>" . lsp-execute-code-action))
;;				 (:map c++-mode-map
;;							 ("C-c x" . lsp-clangd-find-other-file))
;;				 (:map c-mode-map
;;							 ("C-c x" . lsp-clangd-find-other-file)))
;;	:commands (lsp lsp-deferred)
;;	:init
;;	(setenv "LSP_USE_PLISTS" "1")
;;	;; Increase the amount of data emacs reads from processes
;;	(setq read-process-output-max (* 1024 1024))
;;	(setq lsp-clients-clangd-args '("--header-insertion-decorators=0"
;;																	"--clang-tidy"
;;																	"--enable-config"))
;;	;; General lsp-mode settings
;;	(setq lsp-completion-provider :none
;;				lsp-enable-snippet t
;;				lsp-enable-on-type-formatting nil
;;				lsp-enable-indentation nil
;;				lsp-diagnostics-provider :flymake
;;				lsp-keymap-prefix "C-x L")
;;	;; to enable the lenses
;;	(add-hook 'lsp-mode-hook #'lsp-lens-mode)
;;	(add-hook 'lsp-completion-mode-hook
;;						(lambda ()
;;							(setf (alist-get 'lsp-capf completion-category-defaults)
;;										'((styles . (orderless flex))))))
;;	:config
;;	(defun help-at-pt-buffer ()
;;		(interactive)
;;		(let ((help (help-at-pt-kbd-string))
;;					(h-at-p-buf "*Help At Point*"))
;;			(if help
;;					(progn (with-current-buffer (get-buffer-create h-at-p-buf)
;;									 (view-mode -1)
;;									 (erase-buffer) (insert (format "%s" (substitute-command-keys help)))
;;									 (view-mode +1))
;;								 (switch-to-buffer-other-window h-at-p-buf))
;;				(if (not arg) (message "No local help at point")))))
;;	(use-package lsp-ui
;;		:after lsp
;;		:init
;;		(setq lsp-ui-sideline-show-code-actions t)
;;		(setq lsp-ui-sideline-show-diagnostics t)))

;; (use-package lsp-languages
;;	:no-require t :ensure nil
;;	:hook ((c-mode          . lsp-deferred)
;;				 (c++-mode        . lsp-deferred)
;;				 (typescript-mode . lsp-deferred)
;;				 (purescript-mode . lsp-deferred)
;;				 (js-mode         . lsp-deferred)
;;				 (javascript-mode . lsp-deferred))
;;	:init
;;	(use-package lsp-javascript :ensure nil :no-require t
;;		:hook (javascript-mode . lsp-deferred)
;;		:config
;;		(setq lsp-javascript-display-inlay-hints t
;;					lsp-javascript-display-return-type-hints t
;;					lsp-javascript-display-variable-type-hints t
;;					lsp-javascript-display-parameter-type-hints t)
;;		(with-eval-after-load 'js
;;			(define-key js-mode-map (kbd "M-.") 'xref-find-definitions)))

;;	(use-package lsp-rust :ensure nil :no-require t
;;		:hook (rust-mode       . lsp-deferred)
;;		:config
;;		(lsp-rust-analyzer-inlay-hints-mode 1))

;;	(use-package lsp-haskell
;;		:hook (haskell-mode    . lsp-deferred))

;;	(use-package lsp-java
;;		:hook (java-mode       . lsp-deferred)
;;		:init
;;		(require 'lsp-java-boot)
;;		(add-hook 'java-mode-hook #'lsp-java-boot-lens-mode))

;;	(use-package lsp-pyright
;;		:hook (python-mode . (lambda ()
;;													 (require 'lsp-pyright)
;;													 (lsp-deferred)))
;;		:init
;;		(setq python-shell-enable-font-lock nil)))

;; ;;; Debugging
;; (use-package dap-mode
;;	:defer t
;;	:bind (:map dap-mode-map
;;							("C-x D D" . dap-debug)
;;							("C-x D d" . dap-debug-last))
;;	:init
;;	(defun my-dap-cpp-setup ()
;;		(require 'dap-gdb-lldb)
;;		(dap-gdb-lldb-setup))
;;	:config
;;	(my-dap-cpp-setup)
;;	(setq dap-auto-configure-features '(sessions locals controls tooltip)))

;; ;;; Languages
;; (use-package nvm
;;	:ensure nil
;;	:commands (my-nvm-use)
;;	:quelpa (nvm :fetcher github :repo "rejeep/nvm.el")
;;	:commands (nvm-use nvm-use-for-buffer)
;;	:config
;;	(setq nvm-dir (concat (getenv "HOME") "/.config/nvm"))
;;	(defun my-nvm-use () (interactive)
;;		(nvm-use
;;		 (completing-read "Enter Node Version" '("16.17.1")))))

;; (use-package extra-languages
;;	:ensure nil :no-require t
;;	:init
;; ;;;; Haskell
;;	(use-package haskell-mode :mode "\\.hs\\'"
;;		;; lets you use C-c C-l
;;		:hook ((haskell-mode . interactive-haskell-mode)
;;					 (haskell-mode . turn-on-haskell-doc-mode)
;;					 (haskell-mode . haskell-indent-mode)
;;					 (haskell-mode . haskell-setup-outline-mode))
;;		:bind (
;;					 :map haskell-mode-map
;;					 ("M-n" . haskell-goto-next-error)
;;					 ("M-p" . haskell-goto-prev-error))
;;		:config
;;		(defun haskell-setup-outline-mode ()
;;			(make-local-variable 'outline-regexp)
;;			(setq outline-regexp "\\`\\|\\s-+\\S-")))
;; ;;;; PureScript
;;	(use-package purescript-mode :mode "\\.purs\\'"
;;		:hook ((purescript-mode . purescript-indent-mode)
;;					 (purescript-mode . turn-on-purescript-unicode-input-method))
;;		:config
;;		(use-package psci
;;			:hook (purescript-mode . inferior-psci-mode)))

;; ;;;; WEB
;;	(use-package web-mode
;;		:mode (("\\.tsx\\'"  . typescript-tsx-mode)
;;					 ("\\.html\\'" . web-mode))
;;		:hook ((web-mode            . lsp-deferred)
;;					 (typescript-tsx-mode . lsp-deferred))
;;		:bind (
;;					 :map typescript-tsx-mode-map
;;					 ("C-c C-M-f". sgml-skip-tag-forward)
;;					 ("C-c C-M-b". sgml-skip-tag-backward)
;;					 ("C-c C-f". sgml-skip-tag-forward)
;;					 ("C-c C-b". sgml-skip-tag-backward)
;;					 :map web-mode-map
;;					 ("C-c C-M-f". sgml-skip-tag-forward)
;;					 ("C-c C-M-b". sgml-skip-tag-backward)
;;					 ("C-c C-f". sgml-skip-tag-forward)
;;					 ("C-c C-b". sgml-skip-tag-backward)
;;					 ("C-M-i" . completion-at-point)
;;					 ("C-M-u" . web-mode-element-parent)
;;					 ("C-M-d" . web-mode-element-child))
;;		:init
;;		(define-derived-mode typescript-tsx-mode typescript-mode "TypeScript-tsx")
;;		(setq web-mode-markup-indent-offset 2
;;					web-mode-css-indent-offset 2
;;					web-mode-code-indent-offset 2
;;					web-mode-auto-close-style 2))
;; ;;; Rust
;;	(use-package rust-mode    :mode "\\.rs\\'"
;;		:init
;;		;; scratchpad for rust
;;		(setq lsp-rust-clippy-preference "on")
;;		(use-package rust-playground
;;			:commands (rust-playground)))
;; ;;;; Racket
;;	(use-package racket-mode  :mode "\\.rkt\\'"
;;		:config
;;		(require 'racket-xp)
;;		(add-hook 'racket-mode-hook #'racket-xp-mode)
;;		(add-hook 'racket-mode-hook #'prettify-symbols-mode)
;;		(defun setup-racket-eldoc ()
;;			(eldoc-mode +1)
;;			(setq eldoc-documentation-function #'racket-xp-eldoc-function))
;;		(add-hook 'racket-mode-hook #'setup-racket-eldoc))
;; ;;;; Clojure
;;	(use-package clojure-mode :mode "\\.clj\\'")
;;	)

;; (use-package prog-mode
;;	:ensure nil
;;	:hook ((prog-mode       . infer-indentation-style)
;;				 (prog-mode       . (lambda () (setq-local show-trailing-whitespace t)))
;;				 (emacs-lisp-mode . (lambda () (add-hook 'local-write-file-hooks 'check-parens)))
;;				 (lisp-mode       . (lambda () (setq indent-tabs-mode nil)))
;;				 ;; Make all scripts executable. Ya this might be sketch but I don't
;;				 (after-save      . executable-make-buffer-file-executable-if-script-p))
;;	:bind (:map emacs-lisp-mode-map
;;							("C-c RET" . emacs-lisp-macroexpand)
;;							("C-c C-k" . eval-buffer))
;;	:init
;;	;; Don't prompt for a reference
;;	(setq xref-prompt-for-identifier nil)
;;	(global-prettify-symbols-mode)

;;	;; Smart Indentation
;;	(defun infer-indentation-style ()
;;		;; if our source file uses tabs, we use tabs, if spaces spaces, and if
;;		;; neither, we use the current indent-tabs-mode
;;		(let ((space-count (how-many "^  " (point-min) (point-max)))
;;					(tab-count (how-many "^\t" (point-min) (point-max))))
;;			(if (> space-count tab-count) (setq indent-tabs-mode nil))
;;			(if (> tab-count space-count) (setq indent-tabs-mode t)))))

;; (use-package emmet-mode
;;	:hook ((js-jsx-mode typescript-mode) emmet-jsx-major-modes)
;;	:bind
;;	("C-j" . emmet-expand-line)
;;	(:map emmet-mode-keymap
;;				("M-}" . emmet-next-edit-point)
;;				("M-{" . emmet-prev-edit-point))
;;	:config
;;	(defun my-emmet-expand-capf ()
;;		(let ((bounds (bounds-of-thing-at-point 'symbol))
;;					(tap (thing-at-point 'symbol)))
;;			(list (car bounds) (cdr bounds)
;;						;; Just return the symbol at point to so completion will be possible
;;						;; TODO Determine if there is a less hacky option
;;						(lambda (string pred action) (list (thing-at-point 'symbol)))
;;						;; Annotate with what emmet expands to
;;						;; TODO find a way for this to show since right now
;;						;; corfu doesn't display this on a single completion
;;						:annotation-function (lambda (str) (emmet-transform str))
;;						;; Don't try to complete with emmet if there is no possible
;;						;; expansion
;;						:predicate (not (string= (emmet-transform tap)
;;																		 tap))
;;						;; Expand Emmet Template On Match
;;						:exit-function (lambda (str status)
;;														 (when (eql status 'finished)
;;															 (emmet-expand-line nil)))
;;						;; Allow for other completions to follow
;;						:exlcusive 'no)))

;;	(defun emmet-setup-capf ()
;;		(setq-local completion-at-point-functions
;;								(add-to-list 'completion-at-point-functions
;;														 'my-emmet-expand-capf
;;														 t)))
;;	(add-hook 'emmet-mode-hook 'emmet-setup-capf))



(use-package flymake
  :defer 10
  :bind (("M-g l"   . flymake-show-buffer-diagnostics)
         ("M-g M-l" . flymake-show-project-diagnostics)
         ("M-g M-n" . flymake-goto-next-error)
         ("M-g M-p" . flymake-goto-prev-error)
         :repeat-map flymake-repeatmap
         ("p" . flymake-goto-prev-error)
         ("n" . flymake-goto-next-error)
         :map flymake-diagnostics-buffer-mode-map
         ("?" . flymake-show-diagnostic-here)
         :map flymake-project-diagnostics-mode-map
         ("?" . flymake-show-diagnostic-here))
  :hook (prog-mode . (lambda () (flymake-mode t)))
  :config
  (defun flymake-show-diagnostic-here (pos &optional other-window)
    "Show the full diagnostic of this error.
Used to see multiline flymake errors"
    (interactive (list (point) t))
    (let* ((id (or (tabulated-list-get-id pos)
                   (user-error "Nothing at point")))
           (text (flymake-diagnostic-text (plist-get id :diagnostic))))
      (message text)))
  (remove-hook 'flymake-diagnostic-functions #'flymake-proc-legacy-flymake))

;; (use-package highlight-indent-guides
;;   :hook (python-ts-mode . highlight-indent-guides-mode))

;; :config
;; (setq highlight-indent-guides-method 'character))

;; System notifications
;; (setq compilation-finish-functions
;;       (append compilation-finish-functions
;;               '(fmq-compilation-finish)))

;; (defun fmq-compilation-finish (buffer status)
;;   (call-process "notify-send" nil nil nil
;;                 "-t" "0"
;;                 "-i" "emacs"
;;                 "Compilation finished in Emacs"
;;                 status))

(global-set-key (kbd "<f5>") 'recompile)

(use-package magit)

(add-hook 'c++-mode-hook
          (lambda ()
            (setq compile-command (concat "g++ -std=c++11 -O2 -Wall "
                                          buffer-file-name
                                          " -o "
                                          (file-name-sans-extension buffer-file-name)
                                          " && " (file-name-sans-extension buffer-file-name)))))

(provide 'init-dev)
