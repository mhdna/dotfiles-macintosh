;; Org settings
;; (defun my-org-faces ()
;; (set-face-attribute 'org-level-1 nil :height 130 :family "sans-serif")
;; (set-face-attribute 'org-level-2 nil :height 125 :family "sans-serif")
;; (set-face-attribute 'org-level-3 nil :height 120 :family "sans-serif")
;; (set-face-attribute 'org-level-4 nil :height 120 :family "sans-serif")
;; (set-face-attribute 'org-level-5 nil :height 120 :family "sans-serif")
;; (set-face-attribute 'org-level-6 nil :height 120 :family "sans-serif")
;; (set-face-attribute 'org-block nil :inherit 'fixed-pitch)
;; (set-face-attribute 'org-code nil :inherit 'fixed-pitch)
;; (set-face-attribute 'org-table nil :inherit 'fixed-pitch)
;; (set-face-attribute 'org-verbatim nil :inherit 'fixed-pitch)
;; (set-face-attribute 'org-formula nil :inherit 'fixed-pitch)
;; (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch :box t :foreground "#b5bd68"))

;; (add-hook 'org-mode-hook #'my-org-faces)

(add-hook 'org-mode-hook 'flyspell-mode)
(setq org-export-with-sub-superscripts nil)
(setq org-pretty-entities nil)
;; (add-hook 'org-mode
;;           (setq line-spacing 3))
(setq org-export-coding-system 'utf-8)
;; set default unprioritized tasks to #C instead of #B
(setq org-default-priority ?C)
;; (add-hook 'org-mode-hook 'org-indent-mode)
(setq org-adapt-indentation nil)
(setq coding-system-for-read 'utf-8 ) ; use utf-8 by default
(setq coding-system-for-write 'utf-8 )

(use-package org
  :config
  (require 'org-tempo))

;; an org-bullets replacement
(use-package org-superstar
  :after org
  :hook (org-mode . org-superstar-mode))

(setq org-hide-emphasis-markers t) ;; (e.g. hide slashes and astrisks in *bold*)
(use-package org-appear
  :hook (org-mode . org-appear-mode))
(setq org-pretty-entities t) ;; pretify mathematical symbols and other symbols
;; Don't expand enormous images, instead use imagemagick to display them at a manageable size.
(setq org-startup-with-inline-images t
      org-image-actual-width '(300))
(setq org-src-fontify-natively t) ;; syntax highlighting in source blocks
(setq org-src-tab-acts-natively t) ;; Make TAB act as if it were issued in a buffer of the language's major mode.
(add-to-list 'org-structure-template-alist
             '("el" . "src emacs-lisp"))
(setq org-adapt-indentation nil)

(setq org-directory "~/personal/notes/")
(setq org-private-directory (concat org-directory "private/"))
(setq org-public-directory(concat org-directory "public/"))

(defun org-file-path (dir filename)
  "Return the absolute address of an org file, given its relative name."
  (concat (file-name-as-directory dir) filename))
(defun org-private-file-path (filename)
	(org-file-path org-private-directory filename))
(defun org-public-file-path (filename)
	(org-file-path org-public-directory filename))

(setq org-anki-directory (org-public-file-path "anki/"))
(setq org-language-directory (org-public-file-path "language/"))

(setq org-todo-file (org-private-file-path "todo.org"))
(setq org-archive-location
      (concat
       (org-private-file-path (format "archive/archive-%s.org" (format-time-string "%Y")))
       "::* From %s"))
(setq org-refile-targets `((,org-todo-file :level . 1)
                           (,(org-private-file-path "todo.org") :level . 1)
                           ;; (,(org-private-file-path "goals.org") :level . 1)
                           (,(org-private-file-path "links.org") :level . 1)
                           ;; (,(org-private-file-path "watchlater.org") :level . 1)
                           ))
;; (,(org-private-file-path "someday-maybe.org") :level . 1)
;; (,(org-private-file-path "work.org") :level . 1)))
(setq org-agenda-files (list
                        org-todo-file
                        ;; (org-private-file-path "calendars")
                        ;; (org-private-file-path "goals.org")
                        ;; (org-private-file-path "tasks.org")
                        ;; (org-private-file-path "habits.org")
                        (org-private-file-path "news.org")
                        ;; (org-private-file-path "week.org")
                        ;; (org-private-file-path "recurring-tasks.org")
                        ;; (org-private-file-path "work.org")
                        ))
(defun my-mark-done-and-archive ()
  "Mark the state of an org-mode item as DONE, archive it, and
save the Org buffers."
  (interactive)
  (org-todo 'done)
  (org-archive-subtree)
  (org-save-all-org-buffers))
(setq org-log-done 'time)
;; (setq org-log-done 'note)
(setq org-enforce-todo-dependencies t)
(defun my-org-add-tag (new-tag)
  (org-set-tags (cons new-tag
                      (seq-remove (lambda (tag)
                                    (get-text-property 0 'inherited tag))
                                  (org-get-tags)))))
(defun my-schedule-today ()
  "Tag this item with `daily'."
  (interactive)
  (my-org-add-tag "daily")
  (save-buffer))
(setq org-agenda-start-on-weekday nil)
;; (setq org-deadline-warning-days 0)
(setq org-agenda-prefix-format '((agenda . " %i %?-12t% s")
                                 (todo . " %i ")
                                 (tags . " %i ")
                                 (search . " %i ")))
;; (setq org-agenda-dim-blocked-tasks 'invisible)
(defun my-org-agenda-delete-empty-blocks ()
  "Remove empty agenda blocks.
A block is identified as empty if there are fewer than 2
non-empty lines in the block (excluding the line with
`org-agenda-block-separator' characters)."
  (when org-agenda-compact-blocks
    (user-error "Cannot delete empty compact blocks"))
  (setq buffer-read-only nil)
  (save-excursion
    (goto-char (point-min))
    (let* ((blank-line-re "^\\s-*$")
           (content-line-count (if (looking-at-p blank-line-re) 0 1))
           (start-pos (point))
           (block-re (format "%c\\{10,\\}" org-agenda-block-separator)))
      (while (and (not (eobp)) (forward-line))
        (cond
         ((looking-at-p block-re)
          (when (< content-line-count 2)
            (delete-region start-pos (1+ (point-at-bol))))
          (setq start-pos (point))
          (forward-line)
          (setq content-line-count (if (looking-at-p blank-line-re) 0 1)))
         ((not (looking-at-p blank-line-re))
          (setq content-line-count (1+ content-line-count)))))
      (when (< content-line-count 2)
        (delete-region start-pos (point-max)))
      (goto-char (point-min))
      ;; The above strategy can leave a separator line at the beginning
      ;; of the buffer.
      (when (looking-at-p block-re)
        (delete-region (point) (1+ (point-at-eol))))))
  (setq buffer-read-only t))
(add-hook 'org-agenda-finalize-hook #'my-org-agenda-delete-empty-blocks)
(setq org-agenda-custom-commands '())
(add-to-list 'org-agenda-custom-commands
             '("p" "Personal agenda"
               ((tags-todo "plan"
                           ((org-agenda-overriding-header "Index")
                            (org-agenda-hide-tags-regexp "plan\\|daily\\|weekly\\|yearly")))
                (tags-todo "daily"
                           ((org-agenda-overriding-header "Today")
                            (org-agenda-hide-tags-regexp "habit\\|daily\\|weekly\\|yearly")))
                (tags-todo "habit-daily-weekly"
                           ((org-agenda-overriding-header "Habits")
                            (org-agenda-hide-tags-regexp "habit")))
                (tags-todo "weekly-daily"
                           ((org-agenda-overriding-header "This Week")
                            (org-agenda-hide-tags-regexp "weekly\\|yearly")))
                (agenda ""
                        (
                         ;; (org-agenda-overriding-header "Calendar")
                         (org-agenda-tag-filter-preset '("-daily"
                                                         "-habit"
                                                         "-weekly"
                                                         "-yearly"))
                         (org-agenda-hide-tags-regexp "daily\\|weekly\\|yearly")))
                (tags-todo "yearly-daily-weekly"
                           ((org-agenda-overriding-header "Annual Goals")
                            (org-agenda-hide-tags-regexp "yearly"))))
               ((org-agenda-skip-deadline-if-done t)
                (org-agenda-skip-scheduled-if-done t)
                (org-agenda-skip-timestamp-if-done t)
                (org-agenda-tag-filter-preset '("-duplicate" "-news" "-writing")))))

;; (defun my-agenda ()
;;   (interactive)
;;   (call-process-shell-command "daily-checklist")
;;   (delete-other-windows)
;;   (org-agenda nil "t"))

;; (defun my-agenda ()
;;    "Show the agenda for the current week without splitting windows."
;;   (interactive)
;;   (let ((org-agenda-span 'week)
;;         (org-agenda-window-setup 'current-window))  ; Show agenda in the current window
;;     (org-agenda nil "a")))

(add-hook 'org-agenda-mode-hook 'delete-other-windows)

(defun my-notes-open()
  (interactive)
  (find-file org-directory))

(defun my-org-todo-open()
  (interactive)
  (find-file org-todo-file))

(defun my-org-goto()
  (interactive)
  (let ((org-goto-interface 'outline-path-completion)) (org-goto)))

(setq my-diary-file (org-private-file-path "/diary.org"))
(defun my-diary-file-open()
  (interactive)
  (find-file my-diary-file)
  (end-of-buffer)
  ;; (insert (concat "** " (format-time-string "%Y.%m.%d %H:%M %P ") "\n"))
  (let ((title (read-string "Enter Title: ")))
    ;; (insert (concat "** " title (format-time-string " %Y.%m.%d %H:%M %P ") "\n")))
    (insert (concat "** " title (format-time-string " <%Y-%m-%d %H:%M %p %a> ") "\n")))
  ;; (insert (concat "**" (format-time-string " %Y.%m.%d") "\n"))
  (org-set-tags-command)
  (when (featurep 'evil)
    (evil-insert-state))
  ;; (flycheck-mode -1)
  )

(setq my-journal-file (org-private-file-path "/journal.org"))
(defun my-journal-file-open()
  (interactive)
  (find-file my-journal-file)
  (end-of-buffer)
  (let ((title (read-string "Enter Title: ")))
    (insert (concat "** " title (format-time-string "\n<%Y-%m-%d %a>") "\n")))
  (org-set-tags-command)
  ;; TODO check if evil is installed
  (when (featurep 'evil)
		(evil-insert-state))
  ;; (flycheck-mode -1)
  )

(defun my-english-reading-notes-open ()
  (interactive)
  (find-file (org-public-file-path "/language.org"))
  (goto-char (org-find-exact-headline-in-buffer "English Reading Notes"))
  (org-shifttab)
  (org-cycle))


(defun my-org-insert-link-dwim ()
  "Like `org-insert-link' but with personal dwim preferences."
  (interactive)
  (let* ((point-in-link (org-in-regexp org-link-any-re 1))
         (clipboard-url (when (string-match-p "^http" (current-kill 0))
                          (current-kill 0)))
         (region-content (when (region-active-p)
                           (buffer-substring-no-properties (region-beginning)
                                                           (region-end)))))
    (cond ((and region-content clipboard-url (not point-in-link))
           (delete-region (region-beginning) (region-end))
           (insert (org-make-link-string clipboard-url region-content))
           (message clipboard-url))
          ((and clipboard-url (not point-in-link))
           (insert (org-make-link-string
                    clipboard-url
                    (read-string "title: "
                                 (with-current-buffer (url-retrieve-synchronously clipboard-url)
                                   (dom-text (car
                                              (dom-by-tag (libxml-parse-html-region
                                                           (point-min)
                                                           (point-max))
                                                          'title))))))))
          (t
           (call-interactively 'org-insert-link)))))


(defadvice org-agenda-set-mode-name (after truncate-org-agenda-mode-name activate)
  (setq mode-name '("Org-agenda")))
(add-to-list 'org-agenda-custom-commands
             '("n" "News from this week"
               ((agenda ""))
               ((org-agenda-overriding-header "News from this week")
                (org-agenda-start-day "-6d")
                (org-agenda-span 21)
                (org-agenda-files (list (org-private-file-path "news.org")
                                        (org-public-file-path "books.org"))))))

(defun my-org-emphasize ()
  "Emphasize the active region or the word at point."
  (interactive)
  (if (use-region-p)
      (org-emphasize)
    (save-excursion
      (let ((bounds (bounds-of-thing-at-point 'word)))
        (if bounds
            (progn
              (goto-char (car bounds))
              (set-mark (point))
              (goto-char (cdr bounds))
              (org-emphasize))
          (message "No word at point"))))))

(defun my-anki-language-expand (file heading snippet)
	(interactive)
	(find-file (concat org-anki-directory file))
	(goto-char (org-find-exact-headline-in-buffer heading))
	(end-of-line)
	(open-line 1)                               ;; Insert a new line
	(forward-line 1)                            ;; Move to the new line
	(evil-insert-state)  
	(yas-expand-snippet (yas-lookup-snippet snippet)))

(defun my-org-insert-language-item (file heading)
	(interactive)
	(find-file (concat org-language-directory file))
	(goto-char (org-find-exact-headline-in-buffer heading))
	(end-of-line)
	(open-line 1)                               ;; Insert a new line
	(forward-line 1)                            ;; Move to the new line
	(evil-insert-state)  
	(insert "- "))

(defun my-org-insert-h2tag (file heading)
	(interactive)
	(find-file (concat org-language-directory file))
	(goto-char (org-find-exact-headline-in-buffer heading))
	(end-of-line)
	(open-line 1)                               ;; Insert a new line
	(forward-line 1)                            ;; Move to the new line
	(evil-insert-state)  
	(yas-expand-snippet (yas-lookup-snippet "h2tag")))

(defun my-anki-push-all-notes ()
  "Push Anki notes for all files in the directory '~/ankidir'."
  (interactive)
    (dolist (file (directory-files org-anki-directory t "^[^.].*"))  ;; List files with full path
      (when (file-regular-p file)
        (with-current-buffer (find-file-noselect file)
          (anki-editor-push-notes)))))

(defun my-org-emphasize-bold ()
  "Emphasize the active region or the word at point."
  (interactive)
  (if (use-region-p)
      (org-emphasize ?*)
    (progn
      (mark-word)
      (org-emphasize ?*))))

(setq org-capture-templates
      (quote (("s" "Schedule"
               plain
               (file+headline org-todo-file "Scheduled")
               "** %?\n   SCHEDULED: %t\n")
              ("t" "todo"
               entry
               (file+headline org-todo-file "Index")
               "* TODO %?\t%^g\n")
              ("T" "todo code (File)"
               entry
               (file+headline org-todo-file "Code")
               "* TODO %?\n%i%a\n")
              ;; ("w" "Watch Later"
              ;;  plain
              ;;  (file+headline org-todo-file "Watch Later")
              ;;  "** %?\n")
              ("n" "News item"
               entry
               (file "news.org")
               "* %?\n%t\n")
              ("p" "Project idea"
               entry
							 (file+headline (file (org-public-file-path "project-idea.org")) "Project Idea")
               "** %?\t%^g\n")
              ;; ("j" "Journal prompt"
              ;;  entry
              ;;  (file "journal.org")
              ;;  "* %?\t%^g\n   %t\n")
              ;; ("b" "to Buy"
              ;;  plain
              ;;  (file "toby.org")
              ;;  "* %? \t%^g\n")
              ("Q" "Quote"
               plain
               (file (org-public-file-path "quotes.org"))
               "** %? (%^{Quotee})\t%^g\n")
              ;; Languages templates
              ("r" "Readlater"
               plain
               (file+headline org-todo-file "ReadLater")
               "** %^{Title or link to readlater}")
              ("q" "Question"
               plain
               (file (org-public-file-path "questions.org"))
               "** %^{Question}? \t%^g\n")
              ;; ("d" "Advice"
              ;;  plain
              ;;  (file "advice.org")
              ;; ("d" "Download"
              ;;  plain
              ;;  (file+headline org-todo-file "To Download")
              ;;  "- %^{Titel or Link}")
              ("b" "Book to read"
               plain
               (file+headline (org-public-file-path "books.org") "Books")
               "** %^{Book Title}\t%^g")
              ("B" "Red Book"
               entry
               (file+headline "books.org" "Red Books")
               "* %^{Title} -- %^{Author}\t%^g\n%^t --> %^t\n** Stars: %^{Stars (out of 10)}\n** Review\n%^{Review}\n** Summary\n%^{Summary}")
              ("M" "Movie"
               plain
               (file (org-public-file-path "movies.org"))
               "* %^{Title} -- %t   \t%^g:\n** Stars: %^{Stars (out of 10)}/10\n** Degeneracy: %^{Degeneracy (out of 10)}/10\n** Review\n%?\n** Quotes\n")
              ;; ("e" "English Words"
              ;;  plain
              ;;  (file+headline "language.org" "English Words")
              ;;  "*** %^{Word}\t%^g\n\t: %^{Meaning}")
              ;; ("E" "English Phrases"
              ;;  plain
              ;;  (file+headline "language.org" "English Phrases")
              ;;  "*** %^{Phrase}\t%^g\n")
              ;; ("f" "Farsi Words"
              ;;  plain
              ;;  (file+headline "language.org" "Farsi Words")
              ;;  "- %^{Word}\t%^g\n\t: %^{Meaning}")
              ;; ("F" "Farsi Phrases"
              ;;  plain
              ;;  (file+headline "language.org" "Farsi Phrases")
              ;;  "*** %^{Phrase}\t%^g\n\t: %^{Meaning}")
              ;; ("a" "Arabic Words"
              ;;  item
              ;;  (file+headline "language.org" "Arabic Words")
              ;;  "*** %^{Word}\t%^g")
              ;; ("A" "Arabic Phrases"
              ;;  plain
              ;;  (file+headline "language.org" "Arabic Phrases")
              ;;  "*** %^{Phrase}\t%^g")
              ;; ("c" "Color"
              ;;  plain
              ;;  (file+headline "language.org" "Colors")
              ;; "** %^{Color and explanation -if any-} %^{Hex Code}")
							)))
(setq org-refile-use-outline-path t)
(setq org-outline-path-complete-in-steps nil)


(defun org-capture-todo ()
  (interactive)
  (org-capture :keys "t"))

;; WARN: doesn't work
;; (defun my-language-split ()
;;   (interactive)
;;   (if (not (one-window-p))
;;       (split-window-right))
;;   (find-file (org-public-file-path "language.org")))

(setq org-confirm-babel-evaluate nil)
(setq org-export-with-smart-quotes t)
(setq org-html-postamble nil)

;; org notifications
(use-package org-alert
  :config
  (setq alert-default-style 'libnotify)
  (setq org-alert-interval 300
        ;; org-alert-notify-cutoff 10
        org-alert-notification-title "Upcoming Event"
        org-alert-notify-after-event-cutoff 10)
  (org-alert-enable))

;; anki-editor
(use-package anki-editor)

(use-package org-download
	:config
	(setq-default org-download-image-dir (concat org-directory "pix"))
	(add-hook 'org-mode-hook 'org-download-enable)
	(add-hook 'dired-mode-hook 'org-download-enable)
	;; (setq-default org-download-screenshot-method "scrot")
	)

;; Use `htmlize' to ensure that exported code blocks use syntax highlighting.
(use-package htmlize)

;; (defun my-startup ()
;;   (interactive)
;;   (delete-other-windows)
;;   (find-file org-todo-file)
;;   ;; (make-frame)
;;   (split-window-right)
;;   (find-file (org-public-file-path "anki/anki-english-phrases.org"))
;; )

;; ;; Live html previews
(use-package org-preview-html
  :config
  (setq org-preview-html-viewer 'xwidgets))

(define-key org-mode-map (kbd "C-c C-l") 'my-org-insert-link-dwim)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)
(define-key org-mode-map (kbd "C-c C-x C-a") 'my-mark-done-and-archive)
(global-set-key (kbd "C-c t") 'org-capture-todo)
(global-set-key (kbd "C-c d") 'my-diary-file-open)
(global-set-key (kbd "C-c D") 'my-journal-file-open)


(provide 'init-org)
