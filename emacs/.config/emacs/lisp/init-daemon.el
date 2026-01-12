;; run this hook after we have initialized the first time
;; (add-hook 'after-init-hook 'my-setup-font-faces)
;; re-run this hook if we create a new frame from daemonized Emacs
(add-hook 'server-after-make-frame-hook 'my-setup-font-faces)
;; (add-hook 'server-after-make-frame-hook '(set-frame-width (frame-focus) 75)
;; )
;; (add-hook 'server-after-make-frame-hook '(set-frame-height (frame-focus) 30))


(provide 'init-daemon)
