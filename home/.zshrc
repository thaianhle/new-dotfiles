#--
#--
# Zsh config: minimal + portable

# Zsh theme & prompt
export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
export ZSH_THEME="robbyrussell"  # hoặc agnoster/pure tùy
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

# Editor, Terminal, etc
export EDITOR='emacs -nw'
export TERMINAL='x-terminal-emulator'
export BROWSER='xdg-open'

# AWS
export AWS_REGION="ap-south-1"

# Add local bin
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# Activate plugins
source $ZSH/oh-my-zsh.sh
source $ZSH_CUSTOM/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSH_CUSTOM/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Zsh options
setopt AUTOCD
setopt PROMPT_SUBST
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt COMPLETE_IN_WORD
setopt AUTO_LIST
setopt MENU_COMPLETE
setopt noflowcontrol

# Prompt (simple)
PROMPT='%B%F{green}%n@%m%f%b:%F{blue}%~%f%# '

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Disable unneeded aliases and clutter
# No ls/exa/nala/ytfzf/etc


alias k="kubectl"
alias knode="${k} get nodes"
alias kpod="${k} get pods"
export KUBECONFIG=$HOME/go_project/ansible/plays/kubeconfig_RKE_CLUSTER.yaml
export GOPATH=$HOME/.go
export GOROOT=/usr/local/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOROOT/bin:$GOBIN
export XDG_CONFIG_HOME=$HOME/.config
export AWS_REGION="ap-south-1"
export GDK_BACKEND=wayland,x11
export QT_QPA_PLATFORM=wayland,xcb
export MOZ_ENABLE_WAYLAND=1
export project_id='rke2-prod'
export OPENROUTER_API_KEY_1="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"
export OPENROUTER_API_KEY_2="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"
export GEMINI_API_KEY="AIzaSyAmVodIu1QimrQJ5xE_J_yz2PnbTG3KZc0"
export MISTRAL_API_KEY="4UUWHr6c9Ol1Tzl2dI8gTqSCM0Wuxz37"
export FIREWORK_API_KEY="fw_3Zk6s8w7WqMUesCJT5pq8Z9T"
export DEEPSEEK_API_KEY="sk-d11512b0d7d6470db3a870ff079de211"

# --- GOOGLE VERTEX AI DEEPSEEK ---
export ENDPOINT=asia-south1-aiplatform.googleapis.com
export REGION=asia-south1
export PROJECT_ID=rke2-prod
# add Pulumi to the PATH
export PATH=$PATH:/home/thaianh/.pulumi/bin
