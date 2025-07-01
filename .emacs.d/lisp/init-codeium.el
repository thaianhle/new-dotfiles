;; ~/.emacs.d/lisp/init-codeium.el

(add-to-list 'load-path "~/.emacs.d/codeium.el")
(require 'codeium)

(defun my-codeium-ghost-hook ()
  (when (and (fboundp 'codeium-request) (not (minibufferp)))
    (codeium-request)))

(dolist (hook '(go-mode-hook python-mode-hook))
  (add-hook hook
            (lambda ()
              (add-hook 'post-command-hook #'my-codeium-ghost-hook nil t))))

(defun my/codeium-complete-manually ()
  (interactive)
  (let ((completion-at-point-functions '(codeium-completion-at-point)))
    (completion-at-point)))

(define-key global-map (kbd "<backtab>") #'my/codeium-complete-manually)

(add-hook 'emacs-startup-hook
          (lambda () (run-with-timer 0.1 nil #'codeium-init)))

(setq codeium-mode-line-enable
      (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
(add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)

(defun my-codeium/document/text ()
  (buffer-substring-no-properties (max (- (point) 3000) (point-min))
                                  (min (+ (point) 1000) (point-max))))
(defun my-codeium/document/cursor_offset ()
  (codeium-utf8-byte-length
   (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
(setq codeium/document/text 'my-codeium/document/text)
(setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset)

(provide 'init-codeium)
