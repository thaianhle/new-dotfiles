#--
#--
export BAT_THEME="Dracula"
export GDK_DPI_SCALE=1.2
#--
export FZF_BASE="/usr/bin/fzf"
export ZSH="$HOME/.oh-my-zsh"
export VISUAL='emacs'
export EDITOR='emacs -nw'
export TERMINAL='alacritty'
export BROWSER='firefox-esr'
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..)"
export ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
#export TERM=xterm
if [ -d "$HOME/.local/bin" ] ;
then PATH="$HOME/.local/bin:$PATH"
fi

#load compinit
autoload -Uz compinit
for dump in ~/.zcompdump-Debian12-5.9(N.mh+24); do
    compinit -d ~/.zcompdump-Debian12-5.9
done
compinit -C -d ~/.zcompdump-Debian12-5.9

autoload -Uz add-zsh-hook
autoload -Uz vcs_info
precmd () { vcs_info }
_comp_options+=(globdots)

zstyle ':completion:*' verbose true
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} 'ma=48;5;197;1'
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:warnings' format "%B%F{red}No matches for:%f %F{magenta}%d%b"
zstyle ':completion:*:descriptions' format '%F{yellow}[-- %d --]%f'
zstyle ':vcs_info:*' formats ' %B%s-[%F{magenta}%f %F{yellow}%b%f]-'

#waiting dots
expand-or-complete-with-dots() {
    echo -n "\e[31m…\e[0m"
    zle expand-or-complete
    zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

#history
#HISTFILE=~/.config/zsh/zhistory
#HISTSIZE=5000
#SAVEHIST=5000

#zsh option
setopt AUTOCD              # change directory just by typing its name
setopt PROMPT_SUBST        # enable command substitution in prompt
setopt MENU_COMPLETE       # Automatically highlight first element of completion menu
setopt LIST_PACKED		   # The completion menu takes less space.
setopt AUTO_LIST           # Automatically list choices on ambiguous completion.
setopt HIST_IGNORE_DUPS	   # Do not write events to history that are duplicates of previous events
setopt HIST_FIND_NO_DUPS   # When searching history don't display results already cycled through twice
setopt COMPLETE_IN_WORD    # Complete from both ends of a word.
stty start undef
stty stop undef
setopt noflowcontrol

#prompt
function dir_icon {
    if [[ "$PWD" == "$HOME" ]]; then
        echo "%B%F{yellow}%f%b"
    else
        echo "%B%F{cyan}%f%b"
    fi
}
PS1='%B%F{blue}%f%b  %B%F{magenta}%n%f%b $(dir_icon)  %B%F{red}%~%f%b${vcs_info_msg_0_} %(?.%B%F{yellow}.%F{red})%f%b '

#PS1='%B%F{blue}%f%b  %B%F{magenta}%n%f%b $(dir_icon)  %B%F{cyan}%~%f%b${vcs_info_msg_0_} %(?.%B%F{yellow}->>.%F{red}->>)%f%b '

#PS1='%B%F{blue}%f%b  %B%F{magenta}%n%f%b $(dir_icon)  %B%F{red}%~%f%b${vcs_info_msg_0_} %(?.%B%F{green}>>.%F{red}>>)%f%b '

#plugin
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source $ZSH_CUSTOM/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh
#source $ZSH_CUSTOM/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
#source $ZSH
#source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
#bindkey '^A' history-substring-search-up
#bindkey '^B' history-substring-search-down

#plugins=(git zsh-autosuggestions zsh-syntax-highlighting fast-syntax-highlighting zsh-autocomplete)

#terminal title
function xterm_title_precmd () {
    print -Pn -- '\e]2;%n@%m %~\a'
    [[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}

function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}

if [[ "$TERM" == (kitty*|alacritty*|termite*|gnome*|konsole*|kterm*|putty*|rxvt*|screen*|tmux*|xterm*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

#plugins=(git fzf cp sudo colored-man-pages command-not-found dirhistory zsh-autosuggestions fast-syntax-highlighting zsh-syntax-highlighting)

plugins=(git fzf cp sudo colored-man-pages command-not-found dirhistory)
#source $ZSH_CUSTOM
source $ZSH/oh-my-zsh.sh

##alias
#apt
alias list="sudo nala list --installed"
alias clean="sudo apt autoclean"
alias remove="sudo nala autoremove && sudo nala autopurge"
alias update="sudo nala update && sudo nala upgrade"
#music&video
alias music="ncmpcpp"
alias youtube="ytfzf -f -t"
alias download="ytfzf -d -f"
alias ytmusic="ytfzf --audio-only --select-all search_pattern"
alias downloadmp3="yt-dlp --extract-audio --audio-format mp3 --audio-quality 0"
#other
alias tree='exa -a --tree --color always --icons --group-directories-first'
alias treell='exa -a -l -b --tree --color always --icons --group-directories-first'
alias ls='exa -a --color always --icons --group-directories-first'
alias ll='exa -a -l -b --color always --icons --group-directories-first'
#alias ls='lsd -a --group-directories-first'
#alias ll='lsd -la --group-directories-first'
#alias cat="batcat"
alias hdd="echo tami | sudo -S $HOME/.scripts/HDSentinel"
alias mem="echo tami | sudo -S ps_mem"

#autostart
#$HOME/.local/bin/colorscript -r

# zsh-autocomplete
#zstyle ':completion:*' completer _expand _complete _approximate

alias k="kubectl"
alias knode="${k} get nodes"
alias kpod="${k} get pods"
export KUBECONFIG=$HOME/go_project/ansible/plays/kubeconfig_RKE_CLUSTER.yaml
export GOPATH=$HOME/.go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
