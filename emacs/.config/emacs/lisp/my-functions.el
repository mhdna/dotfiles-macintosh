(defun my-split-window-below-and-switch ()
  "Split the window horizontally, then switch to the new pane."
  (interactive)
  (split-window-below)
  (balance-windows)
  (other-window 1))

(defun my-split-window-right-and-switch ()
  "Split the window vertically, then switch to the new pane."
  (interactive)
  (split-window-right)
  (balance-windows)
  (other-window 1))

(defun my-delete-window-and-rebalance ()
  "Delete the current window, then rebalance the remaining windows."
  (interactive)
  (delete-window)
  (balance-windows))

(defun my-indent-buffer ()
  (interactive)
  (save-excursion
    (indent-region (point-min) (point-max) nil)))

(defun my-copy-file-path (&optional DirPathOnlyQ)
  "Copy current buffer file path or dired path.
Result is full path.
If `universal-argument' is called first, copy only the dir path.
If in dired, copy the current or marked files.
If a buffer is not file and not dired, copy value of `default-directory'.
URL `http://xahlee.info/emacs/emacs/emacs_copy_file_path.html'
Version 2018-06-18 2021-09-30"
  (interactive "P")
  (let (($fpath
         (if (string-equal major-mode 'dired-mode)
             (progn
               (let (($result (mapconcat 'identity (dired-get-marked-files) "\n")))
                 (if (equal (length $result) 0)
                     (progn default-directory )
                   (progn $result))))
           (if (buffer-file-name)
               (buffer-file-name)
             (expand-file-name default-directory)))))
    (kill-new
     (if DirPathOnlyQ
         (progn
           (message "Directory copied: %s" (file-name-directory $fpath))
           (file-name-directory $fpath))
       (progn
         (message "File path copied: %s" $fpath)
         $fpath )))))
(defun my-window-split-toggle ()
  "Toggle between horizontal and vertical split with two windows."
  (interactive)
  (if (> (length (window-list)) 2)
      (error "Can't toggle with more than 2 windows!")
    (let ((func (if (window-full-height-p)
                    #'split-window-vertically
                  #'split-window-horizontally)))
      (delete-other-windows)
      (funcall func)
      (save-selected-window
        (other-window 1)
        (switch-to-buffer (other-buffer))))))

(defun my-html-open-link-in-firefox (&optional @fullpath)
  "open url under cursor in Firefox browser.
Work in Windows, macOS. 2019-11-09 linux not yet.
Version 2019-11-09"
  (interactive)
  (let ($path)
    (if @fullpath
        (progn (setq $path @fullpath))
      (let (($inputStr
             (if (use-region-p)
                 (buffer-substring-no-properties (region-beginning) (region-end))
               (let ($p0 $p1 $p2
                         ($pathStops "^  \t\n\"`'‘’“”|[]{}「」<>〔〕〈〉《》【】〖〗«»‹›❮❯❬❭〘〙·。\\"))
                 (setq $p0 (point))
                 (skip-chars-backward $pathStops)
                 (setq $p1 (point))
                 (goto-char $p0)
                 (skip-chars-forward $pathStops)
                 (setq $p2 (point))
                 (goto-char $p0)
                 (buffer-substring-no-properties $p1 $p2)))))
        (setq $path (replace-regexp-in-string
                     "^file:///" "/"
                     (replace-regexp-in-string
                      ":\\'" "" $inputStr)))))
    (cond
     ((string-equal system-type "darwin")
      (shell-command (format "open -a 'Firefox.app' \"%s\"" $path)))
     ((string-equal system-type "windows-nt")
      ;; "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" 2019-11-09
      (let ((process-connection-type nil))
        (start-process "" nil "powershell" "start-process" "firefox" $path )))
     ((string-equal system-type "gnu/linux")
      (shell-command (format "firefox \"%s\"" $path))))))


;; If the *scratch* buffer is killed, recreate it automatically
;; FROM: Morten Welind
;;http://www.geocrawler.com/archives/3/338/1994/6/0/1877802/
(save-excursion
  (set-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode)
  (make-local-variable 'kill-buffer-query-functions)
  (add-hook 'kill-buffer-query-functions 'my-kill-scratch-buffer))

(defun my-kill-scratch-buffer ()
  ;; The next line is just in case someone calls this manually
  (set-buffer (get-buffer-create "*scratch*"))
  ;; Kill the current (*scratch*) buffer
  (remove-hook 'kill-buffer-query-functions 'my-kill-scratch-buffer)
  (kill-buffer (current-buffer))
  ;; Make a brand new *scratch* buffer
  (set-buffer (get-buffer-create "*scratch*"))
  (lisp-interaction-mode)
  (make-local-variable 'kill-buffer-query-functions)
  (add-hook 'kill-buffer-query-functions 'my-kill-scratch-buffer)
  ;; Since we killed it, don't let caller do that.
  nil)

;; (defun my-config-reload ()
;; (interactive)
;; (eval-buffer (expand-file-name "~/.emacs.d/init.el")))

(defun my-split-term()
  (interactive)
  (split-window-vertically)
  (other-window 1)
  (eshell)
  ;; (shrink-window 10)
  )

(defun my-kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer
        (delq (current-buffer)
              (remove-if-not 'buffer-file-name (buffer-list)))))

(defvar find-file-root-prefix (if (featurep 'xemacs) "/[sudo/root@localhost]" "/sudo:root@localhost:" )
  "*The filename prefix used to open a file with `find-file-root'.")

(defvar find-file-root-history nil
  "History list for files found using `find-file-root'.")

(defvar find-file-root-hook nil
  "Normal hook for functions to run after finding a \"root\" file.")

(defun my-find-file-root ()
  "*Open a file as the root user.
   Prepends `find-file-root-prefix' to the selected file name so that it
   maybe accessed via the corresponding tramp method."

  (interactive)
  (require 'tramp)
  (let* ( ;; We bind the variable `file-name-history' locally so we can
         ;; use a separate history list for "root" files.
         (file-name-history find-file-root-history)
         (name (or buffer-file-name default-directory))
         (tramp (and (tramp-tramp-file-p name)
                     (tramp-dissect-file-name name)))
         path dir file)

    ;; If called from a "root" file, we need to fix up the path.
    (when tramp
      (setq path (tramp-file-name-localname tramp)
            dir (file-name-directory path)))

    (when (setq file (read-file-name "Find file (UID = 0): " dir path))
      (find-file (concat find-file-root-prefix file))
      ;; If this all succeeded save our new history list.
      (setq find-file-root-history file-name-history)
      ;; allow some user customization
      (run-hooks 'find-file-root-hook))))

(defun my-which (filename)
  "Open a file with the given filename."
  (interactive "sEnter executable name: ")
  (find-file (executable-find filename)))

(defun kill-start-of-line ()
  "kill from point to start of line"
  (interactive)
  (kill-line 0))

(defvar my-recently-closed-buffers nil "alist of recently closed buffers. Each element is (buffer name, file path). The max number to track is controlled by the variable `my-recently-closed-buffers-max'.")

(defvar my-recently-closed-buffers-max 40 "The maximum length for `my-recently-closed-buffers'.")
(defun my-user-buffer-p ()
  "Return t if current buffer is a user buffer, else nil.
Typically, if buffer name starts with *, it is not considered a user buffer.
This function is used by buffer switching command and close buffer command, so that next buffer shown is a user buffer.
You can override this function to get your idea of “user buffer”.
Version: 2016-06-18 2022-05-19"
  (interactive)
  (cond
   ((string-equal "*" (substring (buffer-name) 0 1)) nil)
   ((string-equal major-mode "dired-mode") nil)
   ((string-equal major-mode "eww-mode") nil)
   ((string-equal major-mode "help-mode") nil)
   (t t)))

(defun my-close-current-buffer ()
  "Close the current buffer.

Similar to `kill-buffer', with the following addition:

• Prompt user to save if the buffer has been modified even if the buffer is not associated with a file.
• If the buffer is editing a source file in an `org-mode' file, prompt the user to save before closing.
• If the buffer is a file, add the path to the list `my-recently-closed-buffers'.

URL `http://xahlee.info/emacs/emacs/elisp_close_buffer_open_last_closed.html'
Version: 2016-06-19 2021-07-01 2022-03-22 2022-05-13"
  (interactive)
  (let (($isOrgMode (string-match "^*Org Src" (buffer-name))))
    (if (active-minibuffer-window) ; if the buffer is minibuffer
        ;; (string-equal major-mode "minibuffer-inactive-mode")
        (minibuffer-keyboard-quit)
      (progn
        ;; Offer to save buffers that are non-empty and modified, even for non-file visiting buffer. (Because `kill-buffer' does not offer to save buffers that are not associated with files.)
        (when (and (buffer-modified-p)
                   (my-user-buffer-p)
                   (not (string-equal major-mode "dired-mode"))
                   (if (equal (buffer-file-name) nil)
                       (if (string-equal "" (save-restriction (widen) (buffer-string))) nil t)
                     t))
          (if (y-or-n-p (format "Buffer %s modified; Do you want to save? " (buffer-name)))
              (save-buffer)
            (set-buffer-modified-p nil)))
        (when (and (buffer-modified-p)
                   $isOrgMode)
          (if (y-or-n-p (format "Buffer %s modified; Do you want to save? " (buffer-name)))
              (org-edit-src-save)
            (set-buffer-modified-p nil)))
        ;; save to a list of closed buffer
        (when (buffer-file-name)
          (setq my-recently-closed-buffers
                (cons (cons (buffer-name) (buffer-file-name)) my-recently-closed-buffers))
          (when (> (length my-recently-closed-buffers) my-recently-closed-buffers-max)
            (setq my-recently-closed-buffers (butlast my-recently-closed-buffers 1))))
        (kill-buffer (current-buffer))))))
(defun my-open-last-closed ()
  "Open the last closed file.
URL `http://xahlee.info/emacs/emacs/elisp_close_buffer_open_last_closed.html'
Version: 2016-06-19"
  (interactive)
  (if (> (length my-recently-closed-buffers) 0)
      (find-file (cdr (pop my-recently-closed-buffers)))
    (progn (message "No recently close buffer in this session."))))

(defun my-open-recently-closed ()
  "Open recently closed file.
Prompt for a choice.

URL `http://xahlee.info/emacs/emacs/elisp_close_buffer_open_last_closed.html'
Version: 2016-06-19 2021-10-27 2022-04-07"
  (interactive)
  (find-file (completing-read "Open:" (mapcar (lambda (f) (cdr f)) my-recently-closed-buffers))))

(defun my-list-recently-closed ()
  "List recently closed file.

URL `http://xahlee.info/emacs/emacs/elisp_close_buffer_open_last_closed.html'
Version: 2016-06-19"
  (interactive)
  (let (($buf (generate-new-buffer "*recently closed*")))
    (switch-to-buffer $buf)
    (mapc (lambda ($f) (insert (cdr $f) "\n"))
          my-recently-closed-buffers)))

;; (defun duplicate-line-or-region (&optional n)
;;	"Duplicate current line, or region if active.
;;		With argument N, make N copies.
;;		With negative N, comment out original line and use the absolute value."
;;	(interactive "*p")
;;	(let ((use-region (use-region-p)))
;;		(save-excursion
;;			(let ((text (if use-region        ;Get region if active, otherwise line
;;											(buffer-substring (region-beginning) (region-end))
;;										(prog1 (thing-at-point 'line)
;;											(end-of-line)
;;											(if (< 0 (forward-line 1)) ;Go to beginning of next line, or make a new one
;;													(newline))))))
;;				(dotimes (i (abs (or n 1)))     ;Insert N times, or once if not specified
;;					(insert text))))
;;		(if use-region nil                  ;Only if we're working with a line (not a region)
;;			(let ((pos (- (point) (line-beginning-position)))) ;Save column
;;				(if (> 0 n)                             ;Comment out original with negative arg
;;						(comment-region (line-beginning-position) (line-end-position)))
;;				(forward-line 1)
;;				(forward-char pos)))))

(defun my-bookmark-set (&optional bookmark-name file-name)
  (interactive
   (let* ((default-name (if (eq major-mode 'dired-mode)
                            (file-name-nondirectory (directory-file-name (dired-current-directory)))
                          (file-name-nondirectory (buffer-file-name))))
          (prompt (if (and default-name (not current-prefix-arg))
                      (format "Bookmark name (default: %s): " default-name)
                    "Bookmark name: ")))
     (list (if (and (not current-prefix-arg)
                    (not (string= (setq bookmark-name (read-string prompt)) "")))
               bookmark-name
             default-name)
           (if (eq major-mode 'dired-mode)
               (dired-current-directory)
             (buffer-file-name)))))
  (add-to-list 'bookmark-alist `(,bookmark-name ((filename . ,file-name))))
  (bookmark-save))

(defun my-chatgpt-switch-or-open ()
  (interactive)
  (if (get-buffer "chatgpt-shell")
      (switch-to-buffer "chatgpt-shell")
    (chatgpt-shell)))

(defun my-notes-switch-or-open ()
  (interactive)
  (if (get-buffer "notes")
      (switch-to-buffer "notes")
    (my-notes-open)))

(defun my-eval-region-or-buffer ()
  "Evaluate the selected region if active, otherwise evaluate the buffer."
  (interactive)
  (if (use-region-p)
      (progn
        (eval-region (region-beginning) (region-end))
        (message "Evaluated region"))
    (progn
      (eval-buffer)
      (message "Evaluated buffer"))))

(defun my-insert-current-week-number ()
  "Insert the current week number at point in the current buffer."
  (interactive)
  (insert (format-time-string "%U")))

(defun my-insert-timestamp ()
  (interactive)
  (org-insert-time-stamp (current-time) t))

(setq startup-page "duckduckgo.com")
(defun my-eww ()
  (interactive)
  (eww startup-page))

(defun my-duplicate-line ()
  "Duplicate current line"
  (interactive)
  (let ((column (- (point) (point-at-bol)))
        (line (let ((s (thing-at-point 'line t)))
                (if s (string-remove-suffix "\n" s) ""))))
    (move-end-of-line 1)
    (newline)
    (insert line)
    (move-beginning-of-line 1)
    (forward-char column)))

(defun my-paste-from-clipboard ()
  "Paste text from the clipboard in evil normal mode."
  (interactive)
  (insert (gui-get-selection 'CLIPBOARD)))

(defun my-paste-from-primary ()
  "Paste text from the primary selection (X11) in evil normal mode."
  (interactive)
  (insert (gui-get-selection 'PRIMARY)))

(provide 'my-functions)
