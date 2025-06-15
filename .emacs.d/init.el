;; disable splash screen and startup message
;; fast loading startup for emacs
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq inhibit-startup-echo-area-message t)

;; reduce garbage collection for boost startup
(setq gc-cons-threshold (* 50 1000 1000))

;; global display line numbers
(global-display-line-numbers-mode t)
(setq-default tab-width 4)

(require 'package)
(setq package-archives
	  '(("melpa" . "https://melpa.org/packages/")
		("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; install use-package if unless
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(vterm)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; install vterm
(use-package vterm
  :ensure t)

(defun my/vterm-toggle-right ()
  "Toggle vterm on the right with fixed width."
  (interactive)
  (let ((buf-name "*vterm*")
		(width 80)) ;; fixed width
	(if (get-buffer buf-name)
		(if (get-buffer-window buf-name)
			(delete-window (get-buffer-window buf-name))
		  (let ((win (split-window-right)))
			(select-window win)
			(switch-to-buffer buf-name)))
	  (let ((win (split-window-right)))
		(select-window win)
		(vterm buf-name))))
  (when (get-buffer-window "*vterm*")
	(let ((window (get-buffer-window "*vterm")))	
  (window-resize window (- 80 (window-width window)) t))))

;; clipboard system
;;(setq x-select-enable-clipboard t)
;;(setq x-select-enable-primary t)
;;(setq save-interprogram-paste-before-kill t)

;; wayland
;;(setq select-enable-primary nil)
;;(setq select-enable-clipboard t)
;;(setq x-select-enable-primary nil)
;;(setq x-select-enable-clipboard t)
;;(setq xclip-select-enable-clipboard t)

;; copy for emacs -nw , this work any display x11 or wayland
(defun my/setup-clipboard ()
  "Enable clipboard integration in both Wayland and X11 for terminal Emacs."
  (unless (display-graphic-p) ;; only needed in terminal (emacs -nw)
    (cond
     ;; Wayland - nếu biến môi trường WAYLAND_DISPLAY tồn tại
     ((getenv "WAYLAND_DISPLAY")
      (when (executable-find "wl-copy")
        (setq interprogram-cut-function
              (lambda (text &optional push)
                (let ((process-connection-type nil))
                  (let ((proc (start-process "wl-copy" "*Messages*" "wl-copy")))
                    (process-send-string proc text)
                    (process-send-eof proc)))))
        (setq interprogram-paste-function
              (lambda ()
                (when (executable-find "wl-paste")
                  (string-trim (shell-command-to-string "wl-paste -n")))))))

     ;; X11 - nếu DISPLAY tồn tại (Xorg)
     ((getenv "DISPLAY")
      (when (executable-find "xclip")
        (setq interprogram-cut-function
              (lambda (text &optional push)
                (let ((process-connection-type nil))
                  (let ((proc (start-process "xclip" "*Messages*" "xclip" "-selection" "clipboard")))
                    (process-send-string proc text)
                    (process-send-eof proc)))))
        (setq interprogram-paste-function
              (lambda ()
                (when (executable-find "xclip")
                  (string-trim (shell-command-to-string "xclip -selection clipboard -o"))))))))))


(global-set-key (kbd "M-`") #'my/vterm-toggle-right)

(my/setup-clipboard)
;; vterm mode key binding as real shell
;; Cấu hình vterm để truyền phím như terminal thật



