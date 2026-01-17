# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# random-quote

source $HOME/.zprofile

# # disable annoying "you have a new mail" messages
# unset MAILCHECK
# # fix nix package manager conflict with local packages' libraries
# unset LD_LIBRARY_PATH

# Prompt color settings
autoload -U colors && colors

# setprompt() {

  git_prompt_info() {
        local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [ -n "$branch" ]; then
                echo " ($branch)"
        fi
  }
#   setopt prompt_subst

#   if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
#     p_host='%F{yellow}%M%f'
#   else
#     p_host='%F{green}%M%f'
#   fi

#   PS1=${(j::Q)${(Z:Cn:):-$'
# 	%(!.%F{red}%n%f.%F{green}%n%f)
#     @%f
#     ${p_host}
# 	:
#     %F{blue}%~%f
#     %F{magenta}$(git_prompt_info)
#     %(!.%F{red}%#%f.%F{green}%#%f)
#     " "
#   '}}

#   PS2=$'%_>'
#   RPROMPT=$'${vcs_info_msg_0_}'
# }

# # setprompt
# git_prompt_info() {
#     local branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
#     if [ -n "$branch" ]; then
#         # echo "%{$fg[magenta]%} ($branch)"
#         echo " ($branch)"
#     fi
# }

# PS1='%{$fg[green]%}[%n@%m]%{$reset_color%} %1~%b %# '
PS1='%n@%m %1~%b$(git_prompt_info) $ '
# PS1='%1~ %# '
zstyle ':completion:*' completer _expand_alias _complete _ignored # expand aliases on tab (default is C-x a)

# # I cannot handle two lines for prompt, it's ridiculous and hirts my feelings. I always think that something went wrong with my previous command when saying two lines come out
# # PS1='%{$fg[green]%}%n@%m:%{$fg[yellow]%}%~$(git_prompt_info) %{$fg[cyan]%}%D{%H:%M:%S}'$'\n''%{$reset_color%}%#%b '
# # PS1='%n@%m:%~$(git_prompt_info) %D{%H:%M:%S}'$'\n''%#%b '
# # PS1='%{$fg[yellow]%}%n (at) %m:%{$reset_color%}%~$(git_prompt_info) $ '
# PS1='%B%{$fg[green]%}%n@%m:%{$fg[yellow]%}%B%~$(git_prompt_info) %{$fg[cyan]%}%D{%L:%M:%S}%{$reset_color%}%#%b '
# # PS1='%B%{$fg[green]%}%n@%m:%{$fg[yellow]%}%B%~$(git_prompt_info) %{$fg[cyan]%}%D{%L:%M:%S}'$'\n''%{$reset_color%}%#%b '
# # precmd() {
#   RIGHT="$(date +'%H:%M:%S') "
#   RIGHTWIDTH=$(($COLUMNS-${#LEFT}))
#   print $LEFT${(l:$RIGHTWIDTH::_:)RIGHT}
# }
# PS1='%n@%m %1~%b%# '
# PS1='%1~%b%# '
# PS1='%m:%1~%b%# '
# PS1='%B$ '
# zle_highlight=(default:bold)
# PS1='[%B%{$fg[green]%}%n@%m:%{$fg[yellow]%}%B%~$(git_prompt_info)%{$reset_color%}] %{$fg[cyan]%}%D{%L:%M:%S}'$'\n''%#%b '
# RPS1="bar"
# PS1='---------------------'$'\n''%{$fg[reset_color]%}%n@%m:%{$fg[reset_color]%}%~$(git_prompt_info) %{$fg[reset_color]%}%D{%L:%M:%S}%{$reset_color%}$%B '
# PS1='%{$fg[reset_color]%}%n@%m:%{$fg[reset_color]%} %1~$(git_prompt_info)%{$fg[reset_color]%}%{$reset_color%} $%b '



# Enable substitution in the prompt.
setopt prompt_subst

# setopt autocd		# Automatically cd into typed directory.
# stty stop undef		# Disable ctrl-s to freeze terminal. (causes errors with power10ktheme)
setopt interactive_comments


# Load aliases and shortcuts if existent.
for f in "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" "$HOME/.aliases"; do
    [ -f "$f" ] && source "$f"
done

# Basic auto/tab complete:
autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

_comp_options+=(globdots)		# Include hidden files.
autoload -U select-word-style
select-word-style bash # So C-w does not delete whole words in things like a path

# History in cache directory:
HISTFILESIZE=1000000
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$HOME/.history"
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
# If a new command line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS
# TODO
# HISORY_IGNORE="^_ .*"
# Do not save commands starting with a space to history
# Super annoying, don't toggle on. It doesn't remember recent commands (I guess because I'm saving history on each prompt or something).
# setopt HIST_IGNORE_SPACE

bindkey -e
bindkey \^U backward-kill-line

# # Edit line in vim with alt-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^[e' edit-command-line
bindkey -s '^[p' '^Uedit-file\n'
# bindkey -s '^[o' '^Ulfcd\n'
bindkey -s '^[o' '^Ulfcd\n'
bindkey -s '^[g' '^Urgfzf\n'
bindkey -s '^[m' '^Umusic-search\n'
bindkey -s '^[j' '^Ujump\n'
bindkey -s '^[J' '^Ubdjump\n'
# Make zsh autocomplete with up arrow
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "$terminfo[kcuu1]" history-beginning-search-backward-end
bindkey "$terminfo[kcud1]" history-beginning-search-forward-end

bdjump(){
    cd $(cat ${XDG_CONFIG_HOME:-$HOME/.config}/bm/all-dirs | fzf --height=100%)
}

jump() {
	location="$(find * | fzf --prompt 'All> ' \
             --header 'CTRL-D: Directories / CTRL-F: Files' \
             --bind 'ctrl-d:change-prompt(Directories> )+reload(find * -type d)' \
			 --bind 'ctrl-f:change-prompt(Files> )+reload(find * -type f)')"
	if [ ! -z "$location" ]; then
	 [ -d "$location" ] && cd "$location" || "$EDITOR" "$location"
	fi
 }

edit-file () {
	file=$(find . -type f | fzf --ansi --preview 'bat --style=plain --color=always {}' --height=100% --preview-window="up:70%")
	[ -f "$file" ] && $EDITOR "$file"
}

lfcd () {
   # set -e
   tmp="$(mktemp)"
   trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM EXIT' HUP INT QUIT TERM EXIT
   if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
       lf -last-dir-path="$tmp" "$@"
   else
       [ ! -d "$HOME/.cache/lf" ] && mkdir --parents "$HOME/.cache/lf"
       lf -last-dir-path="$tmp" "$@" 3>&-
   fi
   if [ -f "$tmp" ]; then
       dir="$(cat "$tmp")"
       rm -f "$tmp" >/dev/null
       [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
   fi
}

yazicd () {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp" >/dev/null 2>&1
}

# Plugins
# source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
# debian
# source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
# source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
source /usr/share/zsh/plugins/pnpm-shell-completion/pnpm-shell-completion.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source ~/.config/zsh/zsh-artisan/artisan.plugin.zsh 2>/dev/null
# source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
# source /usr/share/zsh/scripts/git-prompt.zsh
# source /usr/share/git-prompt.zsh/examples/ascii.zsh 2>/dev/null
# eval "$(atuin init zsh)"
# [[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
#  typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
eval "$(ssh-agent -s)" > /dev/null 2>&1

# pnpm
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
