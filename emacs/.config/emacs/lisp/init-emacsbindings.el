(use-package multiple-cursors
  :config
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  (global-set-key (kbd "C-M->")        'mc/skip-to-next-like-this)
  (global-set-key (kbd "C-M-<")         'mc/skip-to-previous-like-this))

(use-package change-inner
  :config
  (global-set-key (kbd "M-i") 'change-inner)
  (global-set-key (kbd "M-o") 'change-outer))

(global-set-key (kbd "C-,") 'my-duplicate-line)

(provide 'init-emacsbindings)
