(use-package aidermacs
  :bind (("C-c a" . aidermacs-transient-menu))
  :config
  ;; Không cần setenv nếu đã export trong .zshrc và Emacs nhận được
  ;; Nếu muốn chắc chắn bạn có thể kiểm tra:
  (unless (getenv "OPENROUTER_API_KEY")
    (message "[Aidermacs] Cảnh báo: Không thấy biến OPENROUTER_API_KEY."))

  :custom
  ;; Chế độ mặc định khi mở Aidermacs (code | architect | shell)
  (aidermacs-default-chat-mode 'architect)

  ;; Model dùng qua OpenRouter — KHÔNG prefix "openrouter/", KHÔNG ghi ":free"
  ;; Aidermacs sẽ tự handle API backend là OpenRouter nếu có key
  ;;(aidermacs-default-model "openrouter/deepseek/deepseek-chat-v3-0324:free"))
  (aidermacs-default-model "openrouter/google/gemma-3-27b-it:free"))
(provide 'init-aider-agent)
