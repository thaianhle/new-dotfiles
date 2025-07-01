(use-package emigo
  :straight (:host github :repo "MatthewZMD/emigo" :files (:defaults "*.py" "*.el"))
  :config
  (emigo-enable) ;; Starts the background process automatically
  :custom
  ;; Encourage using OpenRouter with Deepseek
  ;;(emigo-model "openrouter/deepseek/deepseek-chat-v3-0324")
  (emigo-model "deepseek/deepseek-chat-v3-0324:free")
  (emigo-base-url "https://openrouter.ai/api/v1")
  (emigo-api-key (getenv "OPENROUTER_API_KEY")))

(provide 'init-emigo-agent)
