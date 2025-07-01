;; ~/.emacs.d/init-windsurf.el
(add-to-list 'load-path "~/.emacs.d/codeium.el")
(require 'codeium)

;; ✅ Cần có để ghost hoạt động (CAPF trigger)
;;(add-hook 'prog-mode-hook
;;          (lambda ()
;;            (add-to-list 'completion-at-point-functions #'codeium-completion-at-point)))

;; ✅ Init Codeium background sớm
(add-hook 'emacs-startup-hook
          (lambda () (run-with-timer 0.1 nil #'codeium-init)))

;; ✅ Accept ghost suggestion bằng Shift-TAB
(define-key global-map (kbd "<backtab>") #'codeium-accept-completion)

;; ✅ Optional: hiển thị status modeline
(setq codeium-mode-line-enable
      (lambda (api) (not (memq api '(CancelRequest Heartbeat AcceptCompletion)))))
(add-to-list 'mode-line-format '(:eval (car-safe codeium-mode-line)) t)

;; ✅ Optional: giới hạn text gửi
(defun my-codeium/document/text ()
  (buffer-substring-no-properties (max (- (point) 3000) (point-min))
                                  (min (+ (point) 1000) (point-max))))
(defun my-codeium/document/cursor_offset ()
  (codeium-utf8-byte-length
   (buffer-substring-no-properties (max (- (point) 3000) (point-min)) (point))))
(setq codeium/document/text 'my-codeium/document/text)
(setq codeium/document/cursor_offset 'my-codeium/document/cursor_offset)

(provide 'init-windsurf)
