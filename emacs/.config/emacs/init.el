;; Since it can't reach it's function at runtime
;; Configure package.el to include MELPA.
(setq EMACS_DIR "~/.config/emacs/")
(setq EMACS_CACHE_DIR "~/.cache/emacs/")
(setq user-init-file (expand-file-name "init.el" EMACS_DIR))

(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
;; (add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/") t)
(package-initialize)

;; (package-refresh-contents)

;; If use-package isn't already installed, it's extremely likely that this is a
;; fresh installation! So we'll want to update the package repository and
;; install use-package before loading the literate configuration.
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package-ensure)
(eval-and-compile
  (setq use-package-always-ensure
				t
				use-package-expand-minimally t))

;; Install and load `quelpa-use-package'.
(setq quelpa-update-melpa-p nil)
(package-install 'quelpa-use-package)
(require 'quelpa-use-package)

;; config changes made through the customize UI will be stored here
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(setq byte-compile-warnings '(cl-functions))

;; load path
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
;; gotta be before init-daemon
(defun my-setup-font-faces ()
  ;;   "Setup all gui font faces."
  ;;   (when (display-graphic-p)
  ;;     (setq my-font-change-increment 1.1)
  ;;     ;; set default font
  ;;     (set-face-attribute 'default nil :font (font-spec :family "monospace" :size 21 :weight 'regular))
  ;;     ;; Arabic font
  ;;     (set-fontset-font "fontset-default" 'arabic (font-spec :family "DejaVu Sans Mono" :size 18))
  ;;     ;; Set the fixed pitch face
  ;;     ;; (set-face-attribute 'fixed-pitch nil :font (font-spec :family "monospace" :size 18 :weight 'regular))
  ;;     ;; Set the variable pitch face which is the same for mac and linux
  ;;     ;; (set-face-attribute 'variable-pitch nil :font (font-spec :family "Sans" :size 18 :weight 'regular))
  ;;     ;; Makes commented text and keywords italics. This is working in emacsclient but not emacs. Your font must have an italic face available.
  ;;	(set-face-attribute 'font-lock-comment-face nil :slant 'italic)
  ;;	(set-face-attribute 'font-lock-keyword-face nil :slant 'italic)
  (add-to-list 'default-frame-alist '(font . "monospace-15" ))
  (set-face-attribute 'default t :font "monospace-15" )
  (set-face-attribute 'default nil :font "monospace-15" )
  (set-frame-font "monospace-15" nil t)
  (set-fontset-font t 'arabic "DejaVu Sans Mono"))

(my-setup-font-faces)

(require 'my-functions)
;; (require 'column-marker)
;; (require 'init-tex)
;; (require 'init-dev)
(require 'init-org)
(require 'init-html)
(require 'htmlz-mode)
(require 'init-evil)
;; (require 'init-daemon)
(require 'init-emacsbindings)
;; (require 'init-lsp)
;; (require 'init-eglot)


;; Set the directory for backup files
(setq backup-directory-alist `(("." . ,(concat EMACS_CACHE_DIR  "backups/"))))
;; Set the directory for auto-save files
(let ((auto-saves-dir (concat EMACS_CACHE_DIR "auto-saves/")))
  (unless (file-exists-p auto-saves-dir)
		(make-directory auto-saves-dir t)))
(setq auto-save-file-name-transforms `((".*" ,(concat EMACS_CACHE_DIR "auto-saves/") t)))
;; Set the directory for lock files
(setq create-lockfiles (concat EMACS_CACHE_DIR "lockfiles/"))
;; Set the directory for auto-save-list files
(setq auto-save-list-file-prefix (concat EMACS_CACHE_DIR "auto-save-list/.saves-"))

																				; disable version control symbolic links warnings
(setq vc-follow-symlinks t)

;; native compilation stuff
(when (boundp 'native-comp-eln-load-path)
  ;; ;; ;; Don't store eln files in ~/.emacs.d/eln-cache (where they can easily be deleted).
  ;; ;; ;; REVIEW Use `startup-redirect-eln-cache' when 28 support is dropped
  ;; (add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" EMACS_CACHE_DIR))
  ;; ;;
  ;; UX: Suppress compiler warnings and don't inundate users with their popups.
  ;; ;; ;;   They are rarely more than warnings, so are safe to ignore.
  (setq native-comp-async-report-warnings-errors init-file-debug
				native-comp-warning-on-missing-source init-file-debug))


;; Startup performance
;; reduce each 50MB of allocated data (the default is on every 0.76MB)
;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 100 1000 1000))

;; ;; Some global settings
(defalias 'yes-or-no-p 'y-or-n-p)
;; confirm quiting or not
(setq confirm-kill-emacs 'yes-or-no-p)
;; (setq confirm-kill-processes nil)

;; ;; Disable scratch buffer's initial messages
;; (setq initial-scratch-message "")

;; ;; Start the initial scratch buffer in org-mode
;; (add-hook 'emacs-startup-hook
;;           (lambda ()
;;             (with-current-buffer "*scratch*"
;;               (org-mode))))

;; ;; save a list of open files in user-emacs-dir/.emacs.desktop
;; (setq desktop-path (list user-emacs-directory)
;; 			desktop-auto-save-timeout 600)
;; ;; disable frame sizing so it doesn't conflict with auto maximization
;; (setq desktop-restore-frames nil)
;; (desktop-save-mode 1)

;; Always indent with 2 spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
;; (add-hook 'sh-mode-hook
;;           (lambda ()
;;             (setq sh-basic-offset 2
;;                   sh-indentation 2)))

(setq use-dialog-box nil) ;; Do not show gui dialog boxs, instead, use the minibuffer
;; (add-hook 'window-setup-hook 'toggle-frame-maximized t) ;; maximize on startup
;; Set up the visible bell
;; (setq visible-bell 1)

(setq column-number-mode t)
;; (global-visual-line-mode) ;; works better with bidi mode and arabic input method in general ;; Warning: makes j and k work weirdly with arabic text (can't be even fixed with bidi-toggle)
;; (global-hl-line-mode) ;; sucks quiet a bit
;; TODO: doesn't work
;; (make-variable-buffer-local 'global-hl-line-mode)
;; (add-hook 'minibuffer-setup-hook (lambda () (setq global-hl-line-mode nil)))
;; (add-hook 'minibuffer-exit-hook (lambda () (setq global-hl-line-mode nil)))

;; (global-prettify-symbols-mode) ;; fancy lambdas and stuff like that

;; ;; whitespace-mode
;; (setq whitespace-style '(empty lines-tail tabs tab-mark trailing))
;; 	   ;; '(face tabs spaces trailing space-before-tab newline indentation empty space-after-tab space-mark tab-mark))
;; (global-whitespace-mode)
;; ;; disable whitespace-mode for
;; (setq-default whitespace-global-modes
;; 			  '(not shell-mode
;; 					help-mode
;; 					magit-mode
;; 					magit-diff-mode
;; 					ibuffer-mode
;; 					dired-mode
;; 					occur-mode))
;; ;; Whitespace color corrections.
;; ;; (require 'color)
;; ;; (let* ((ws-lighten 30) ;; Amount in percentage to lighten up black.
;; ;;        (ws-color (color-lighten-name "#666666" ws-lighten)))
;; ;;   (custom-set-faces
;; ;;    `(whitespace-newline                ((t (:foreground ,ws-color))))
;; ;;    `(whitespace-missing-newline-at-eof ((t (:foreground ,ws-color))))
;; ;;    `(whitespace-space                  ((t (:foreground ,ws-color))))
;; ;;    `(whitespace-space-after-tab        ((t (:foreground ,ws-color))))
;; ;;    `(whitespace-space-before-tab       ((t (:foreground ,ws-color))))
;; ;;    `(whitespace-tab                    ((t (:foreground ,ws-color))))
;; ;;    `(whitespace-trailing               ((t (:foreground ,ws-color))))))
;; ;; (custom-set-faces
;; ;;  '(whitespace-tab ((t (:foreground "#636363")))))

(setq-default line-spacing 1)

;; Set whitespace actions.
(setq-default whitespace-action
							'(cleanup auto-cleanup))

;; (global-display-line-numbers-mode)
;; ;; count the number of lines to use for line number width
;; (setq-default display-line-numbers-width-start t)

;; Relative line numbers
;; (setq display-line-numbers-type 'relative)
(setq display-line-numbers-type 'absolute)

;; default tab width
(setq tab-width 2)
(setq-default tab-width 2)

;; (setq-default indent-tabs-mode nil
;;               tab-stop-list    ()
;;               tab-width        4)

(setq-default inhibit-x-resources 1)

;; hide all major and minor modes from status line
;; (setq-default mode-line-format (delq 'mode-line-modes mode-line-format))

;; no colors
;; (global-font-lock-mode -1)


;; acme background
;; (set-background-color "#fefee9")

;; (use-package acme-theme
;;   :config
;;   (load-theme 'acme t))
;; (load-theme 'manoj-dark t)
;; (use-package green-screen-theme
;; 	:config
;; 	(load-theme 'green-screen t))
;; (use-package gruvbox-theme
;;   :config
;;   (load-theme 'gruvbox-dark-medium t)
;; 	(set-background-color "#1d1d1d")
;; 	)
;; (package-install solarized-theme
;; 				 :config
;; 				 (load-theme 'solarized-dark t))
;; (use-package zenburn-theme
;;   :config
;;   (load-theme 'zenburn t))
;; (use-package gruber-darker-theme
;;   :config
;;   (load-theme 'gruber-darker t))
;;   (set-background-color "black"))

;; (eval-after-load 'zenburn
;;   (set-face-attribute 'line-number nil :inherit 'default))
;; )

;; (use-package gruber-darker-theme
;;   :config
;;   (load-theme 'gruber-darker t))
;; (use-package monokai-theme
;;   :config
;;   (load-theme 'monokai t))

;; (use-package parchment-theme
;;   :config
;;   (load-theme 'parchment t))

;; (use-package vscode-dark-plus-theme
;; 	:config
;; 	(load-theme 'vscode-dark-plus t)
;; 	(set-background-color "black"))

;; Set the directory for backup files
(setq backup-directory-alist `(("." . ,(concat EMACS_CACHE_DIR  "backups/"))))
;; Set the directory for auto-save files
(let ((auto-saves-dir (concat EMACS_CACHE_DIR "auto-saves/")))
  (unless (file-exists-p auto-saves-dir)
		(make-directory auto-saves-dir t)))
(setq auto-save-file-name-transforms `((".*" ,(concat EMACS_CACHE_DIR "auto-saves/") t)))
;; Set the directory for lock files
(setq create-lockfiles (concat EMACS_CACHE_DIR "lockfiles/"))
;; Set the directory for auto-save-list files
(setq auto-save-list-file-prefix (concat EMACS_CACHE_DIR "auto-save-list/.saves-"))

;; native compilation stuff
(when (boundp 'native-comp-eln-load-path)
  ;; ;; ;; Don't store eln files in ~/.emacs.d/eln-cache (where they can easily be deleted).
  ;; ;; ;; REVIEW Use `startup-redirect-eln-cache' when 28 support is dropped
  ;; (add-to-list 'native-comp-eln-load-path (expand-file-name "eln-cache/" EMACS_CACHE_DIR))
  ;; ;;
  ;; UX: Suppress compiler warnings and don't inundate users with their popups.
  ;; ;; ;;   They are rarely more than warnings, so are safe to ignore.
  (setq native-comp-async-report-warnings-errors init-file-debug
				native-comp-warning-on-missing-source init-file-debug))

;; Startup performance
;; reduce each 50MB of allocated data (the default is on every 0.76MB)
;; The default is 800 kilobytes.  Measured in bytes.
;; (setq gc-cons-threshold (* 100 1000 1000))

;; ;; Some global settings
(defalias 'yes-or-no-p 'y-or-n-p)
;; confirm quiting or not
(setq confirm-kill-emacs 'yes-or-no-p)
;; (setq confirm-kill-processes nil)

;; ;; save a list of open files in user-emacs-dir/.emacs.desktop
;; (setq desktop-path (list user-emacs-directory)
;; 			desktop-auto-save-timeout 600)
;; ;; disable frame sizing so it doesn't conflict with auto maximization
;; (setq desktop-restore-frames nil)
;; (desktop-save-mode 1)

;; (setq split-width-threshold 0) ;; default splits to vertical
(blink-cursor-mode -1) ;; disable blinking cursor

;; set transparency
;; (add-to-list 'default-frame-alist '(alpha-background . 90))

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; disable startup messages
(setq inhibit-startup-message t)
;; vim-like scrolling
(setq scroll-conservatively 100)
;; (setq ring-bell-function 'ignore)
;; enable image mode by default
;; (setq image-mode 1)
;; (setq-default image-mode nil)
(setq default-input-method "arabic")
;; if there is a dired buffer displayed in the next window, use its
;; current subdir, instead of the current subdir of this dired buffer

;; install xclip (for copying in tui)
;; (use-package xclip
;;   :config
;;   (xclip-mode 1))
;; enable x clipboard
;; (setq x-select-enable-clipboard t)

(setq dired-dwim-target t)
(setq ibuffer-expert t)
;; warn when o
(setq large-file-warning-threshold 100000000)
;; Always load newest byte code
(setq load-prefer-newer t)
(setq-default diff-update-on-the-fly nil)
;; recentf
(recentf-mode 1)
(setq recentf-max-saved-items 1000) ;; more recentf amount
(run-at-time nil (* 5 60) 'recentf-save-list)
(global-set-key "\C-x\ \C-r" 'recentf-open)

;; bookmarks default file
(setq bookmark-default-file (concat (file-name-as-directory EMACS_DIR) "/bookmarks"))
(tooltip-mode -1)

;; Enable clipboard integration in TUI mode
(unless (display-graphic-p)
  (setq select-enable-clipboard t
				select-enable-primary t))

(defvar my-term-shell "/bin/zsh")
(defadvice ansi-term (before force-zsh)
  (interactive (list my-term-shell)))
(ad-activate 'ansi-term)

;; keybind/unbind
;; (use-package emacs
;;   :ensure nil
;;   :defer nil
;;   :bind (
;;          ("C-x u"   . undo-only)
;;          ("C-z"     . nil)
;;          ("C-x C-z"     . nil)
;;          ("C-x C-u" . undo-redo)
;;          ("C-x k" . my-close-current-buffer)
;;          ("C-?"     . undo-redo)
;;          ("C-/"     . undo-only)
;;          ("M-p"   . other-window)
;;          ("M-SPC" .   nil) ;; so it doesn't interfere with my remaps key binding
;;          ;; ("C-SPC".						 'toggle-input-method)
;;          ("C-x s"   . eshell))
;; useful completion configurations (for vertico)...
;; :init
;; ;; Add prompt indicator to `completing-read-multiple'.
;; ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
;; (defun crm-indicator (args)
;;   (cons (format "[CRM%s] %s"
;;                 (replace-regexp-in-string
;;                  "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
;;                  crm-separator)
;;                 (car args))
;;         (cdr args)))
;; (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

;; ;; Do not allow the cursor in the minibuffer prompt
;; (setq minibuffer-prompt-properties
;;       '(read-only t cursor-intangible t face minibuffer-prompt))
;; (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)
;; )

(global-set-key (kbd "<f5>")						 'recompile)
(define-key emacs-lisp-mode-map (kbd "<f5>") 'my-eval-region-or-buffer)
(global-set-key (kbd "M-o")	'(lambda () (interactive) (dired ".")))
(global-set-key (kbd "<f6>")						 'my-indent-buffer)
(global-set-key (kbd "C-c p") 'find-file-at-point)
(global-set-key (kbd "C-x u")    'undo-only)
(global-set-key (kbd "C-z")      'nil)
(global-set-key (kbd "C-x C-z")      'nil)
(global-set-key (kbd "C-x C-u")  'undo-redo)
(global-set-key (kbd "C-x k")  'my-close-current-buffer)
(global-set-key (kbd "C-?")      'undo-redo)
(global-set-key (kbd "C-/")      'undo-only)
(global-set-key (kbd "M-SPC")  'nil) ;; so it doesn't interfere with my remaps key binding
(global-set-key (kbd "C-x s")    'eshell)
;; (global-set-key (kbd "M-p")    'other-window) ;; not compatible with compile-mode bindings
(global-set-key "\C-x\ \C-b" 'bookmark-jump)

(setq dictionary-server "dict.org")


;; (let ((ar-font "DejaVu Sans Mono")
;;       (range '(#x000600 . #x0006FF)))
;;   (set-fontset-font "fontset-startup"  range ar-font)
;;   (set-fontset-font "fontset-default"  range ar-font)
;;   (set-fontset-font "fontset-standard" range ar-font))

;; bidi settings
;; (setq-default bidi-paragraph-direction 'left-to-right)
;; (setq-default bidi-paragraph-direction 'nil)
(setq-default bidi-display-reordering 'nil)
;; (defun bidi-direction-toggle ()
;;   "Will switch the explicit direction of text for current
;;  buffer. This will set BIDI-DISPLAY-REORDERING to T"
;;   (interactive "")
;;   (setq bidi-display-reordering t)
;;   (if (equal bidi-paragraph-direction 'right-to-left)
;; 			(setq bidi-paragraph-direction 'left-to-right)
;; 		(setq bidi-paragraph-direction 'right-to-left))
;;   (message "%s" bidi-paragraph-direction))

;; (setq-default bidi-paragraph-direction 'left-to-right)
;; (Add-hook 'org-mode
;;           ;; (setq line-spacing 3)
;;           (setq-local bidi-paragraph-direction 'left-to-right))

;; Avoid performance issues in files with very long lines.
(if (version<= "27.1" emacs-version)
		(global-so-long-mode 1))

;; kill-ring pop-up menu
;; (use-package popup-kill-ring
;;   :bind ("M-y" . popup-kill-ring))

;; (ido-mode 1)
;; (ido-everywhere 1)
;; ;; (ido-ubiquitous-mode 1)
;; (use-package smex
;;   :config
;;   (global-set-key (kbd "M-x") 'smex))

;; Enable vertico
(use-package vertico
  :init
  (vertico-mode)
  :config
	(setq vertico-count '10)
  (use-package orderless
		:init
		;; Configure a custom style dispatcher (see the Consult wiki)
		;; (setq orderless-style-dispatchers '(+orderless-dispatch)
		;;       orderless-component-separator #'orderless-escapable-split-on-space)
		(setq completion-styles '(orderless basic)
					completion-category-defaults nil
					completion-category-overrides '((file (styles partial-completion))))))

(use-package consult
  :bind (
				 :map minibuffer-local-map
				 ("M-r" . consult-history))
  :custom
  (completion-in-region-function #'consult-completion-in-region)
  :config
  ;; ignore backup files
  (setq consult-ripgrep-args
				"rg --null --line-buffered --color=never --max-columns=1000 --path-separator /   --smart-case --no-heading --with-filename --line-number --search-zip --glob !*~"))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

(use-package saveplace
  :init
  (save-place-mode 1)
  :config
  (setq save-place-file (expand-file-name "saveplace" user-emacs-directory))
  ;; activate it for all buffers
  (setq-default save-place t))

(use-package undo-tree
  :config
  ;; autosave the undo-tree history
  (setq undo-tree-history-directory-alist
				`((".*" . ,temporary-file-directory)))
  (setq undo-tree-auto-save-history t)
  (global-undo-tree-mode +1))

(use-package rainbow-mode
  ;; :hook
  ;; (org-mode)
  :config
  ;; Rainbow mode doesn't work globaly by default, so I'll define my own global mode
  (define-globalized-minor-mode my-global-rainbow-mode rainbow-mode
    (lambda () (rainbow-mode 1)))
  (my-global-rainbow-mode 1))

;; (use-package hide-mode-line
;;   :config
;;   (define-globalized-minor-mode my-global-hide-mode-line-mode hide-mode-line-mode
;;     (lambda () (hide-mode-line-mode 1)))
;;   (my-global-hide-mode-line-mode 1))

;; Electric pair mode
;; (setq electric-pair-pairs '(
;;                             (?\( . ?\))
;;                             (?\[ . ?\])
;;                             ))

;; Disable for < and "
;; (setq electric-pair-inhibit-predicate
;;       (lambda (c)
;;         (or (char-equal c ?<)
;;             (char-equal c ?>)
;;             (char-equal c ?\")
;;             (electric-pair-default-inhibit c))))

;; (electric-pair-mode t)

;; dired icons
(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once))

(use-package imenu
  :ensure nil
  :custom
  (imenu-auto-rescan t)
  (imenu-max-items nil))

;; ;; leetcode
;; (use-package leetcode
;;   :hook
;;   (leetcode-solution-mode-hook .
;;								   (lambda() (flycheck-mode -1)))
;;   :config
;;   (setq leetcode-prefer-language "python3")
;;   (setq leetcode-prefer-sql "mysql")
;;   (setq leetcode-save-solutions t)
;;   (setq leetcode-directory "~/code/exercises/leetcode"))


;; (use-package chatgpt-shell
;;   :custom
;;   ((chatgpt-shell-openai-key
;;     (lambda ()
;;       (auth-source-pass-get 'secret "openai-key")))))

;; (setq chatgpt-shell-openai-key
;;       (lambda ()
;;         (nth 0 (process-lines "pass" "show" "gpt"))))

;; (use-package expand-region
;;   :config
;;   (global-set-key (kbd "C-=") 'er/expand-region))

;; Theme per daytime
;; (setq current-theme '(color-theme-solarized-light))

;; (use-package which-key
;; 	:config (which-key-mode))

(use-package yasnippet
  :init
  (setq yas-snippet-dir "~/.config/emacs/snippets")
  (yas-global-mode))
(use-package yasnippet-snippets
  :after yasnippet)

;; light "mode"
;; (set-background-color "#eeffcc")
;; (set-background-color "white")
;; (set-foreground-color "black")
;; (set-cursor-color "black")

;; (set-background-color "black")
;; (set-foreground-color "white")

;; (my-startup)
