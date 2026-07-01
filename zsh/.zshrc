# ── Homebrew must be initialised FIRST so all tools are available ─────────────
# This must come before sourcing zprofile (which may call brew/gdircolors/etc.)
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

source "$HOME/.zprofile"

# ── Shell options ──────────────────────────────────────────────────────────────
unset MAILCHECK          # disable "you have new mail" noise
unset LD_LIBRARY_PATH    # avoid nix conflicts

setopt prompt_subst
setopt interactive_comments
# setopt autocd

# ── Colours ───────────────────────────────────────────────────────────────────
autoload -U colors && colors

# ── Prompt ────────────────────────────────────────────────────────────────────
git_prompt_info() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    [[ -n "$branch" ]] && echo " ($branch)"
}

PS1='%1~ %# '

# ── Completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' completer _expand_alias _complete _ignored
zmodload zsh/complist
compinit
_comp_options+=(globdots)    # include hidden files in completion

autoload -U select-word-style
select-word-style bash       # C-w stops at slashes, not whole path

# ── History ───────────────────────────────────────────────────────────────────
HISTFILESIZE=1000000
HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$HOME/.history"
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS

# ── Key bindings ──────────────────────────────────────────────────────────────
bindkey -e
bindkey '^U' backward-kill-line

autoload edit-command-line
zle -N edit-command-line
bindkey '^[e' edit-command-line

bindkey -s '^[p' '^Uedit-file\n'
bindkey -s '^[o' '^Ulfcd\n'
bindkey -s '^[g' '^Urgfzf\n'
bindkey -s '^[m' '^Umusic-search\n'
bindkey -s '^[j' '^Ujump\n'
bindkey -s '^[J' '^Ubdjump\n'

# Up/down arrow searches history by prefix
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "$terminfo[kcuu1]" history-beginning-search-backward-end
bindkey "$terminfo[kcud1]" history-beginning-search-forward-end

# ── Aliases / shortcuts ───────────────────────────────────────────────────────
for f in "${XDG_CONFIG_HOME:-$HOME/.config}/shell/shortcutrc" "$HOME/.aliases"; do
    [[ -f "$f" ]] && source "$f"
done

# ── Functions ─────────────────────────────────────────────────────────────────

bdjump() {
    local dest
    dest=$(cat "${XDG_CONFIG_HOME:-$HOME/.config}/bm/all-dirs" | fzf --height=100%)
    [[ -n "$dest" ]] && cd "$dest"
}

jump() {
    local location
    location=$(find * | fzf --prompt 'All> ' \
        --header 'CTRL-D: Directories / CTRL-F: Files' \
        --bind 'ctrl-d:change-prompt(Directories> )+reload(find * -type d)' \
        --bind 'ctrl-f:change-prompt(Files> )+reload(find * -type f)')
    if [[ -n "$location" ]]; then
        [[ -d "$location" ]] && cd "$location" || "$EDITOR" "$location"
    fi
}

edit-file() {
    local file
    file=$(find . -type f | fzf --ansi \
        --preview 'bat --style=plain --color=always {}' \
        --height=100% --preview-window="up:70%")
    [[ -f "$file" ]] && "$EDITOR" "$file"
}

lfcd() {
    local tmp
    tmp=$(mktemp)
    trap 'rm -f "$tmp" 2>/dev/null; trap - HUP INT QUIT TERM EXIT' HUP INT QUIT TERM EXIT
    if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
        lf -last-dir-path="$tmp" "$@"
    else
        mkdir -p "$HOME/.cache/lf"
        lf -last-dir-path="$tmp" "$@" 3>&-
    fi
    if [[ -f "$tmp" ]]; then
        local dir
        dir=$(cat "$tmp")
        rm -f "$tmp"
        [[ -d "$dir" && "$dir" != "$(pwd)" ]] && cd "$dir"
    fi
}

yazicd() {
    local tmp cwd
    tmp=$(mktemp -t "yazi-cwd.XXXXXX")
    yazi "$@" --cwd-file="$tmp"
    if cwd=$(cat -- "$tmp") && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# ── SSH agent (reuse existing, don't spawn a new one every shell) ─────────────
if [[ -z "$SSH_AUTH_SOCK" ]]; then
    # Try to connect to a running agent via a known socket
    local _agent_sock="$HOME/.ssh/agent.sock"
    if [[ -S "$_agent_sock" ]]; then
        export SSH_AUTH_SOCK="$_agent_sock"
    else
        eval "$(ssh-agent -s -a "$_agent_sock")" >/dev/null 2>&1
    fi
fi

# ── Plugins ───────────────────────────────────────────────────────────────────
# zsh-autosuggestions via Homebrew
_autosug="$(brew --prefix 2>/dev/null)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$_autosug" ]] && source "$_autosug"
unset _autosug

source "$HOME/.config/zsh/zsh-artisan/artisan.plugin.zsh"    2>/dev/null
source "$HOME/.config/zsh/zsh-wakatime/zsh-wakatime.plugin.zsh" 2>/dev/null

# ── Powerlevel10k ─────────────────────────────────────────────────────────────
# Uncomment the instant-prompt block if you use p10k:
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
[[ -f "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"

# ── Tool initialisations ──────────────────────────────────────────────────────
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"

# ── pnpm ──────────────────────────────────────────────────────────────────────
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"

# ── fzf ───────────────────────────────────────────────────────────────────────
[[ -f "$HOME/.fzf.zsh" ]] && source "$HOME/.fzf.zsh"

# ── PATH (personal bins — Homebrew bins come from brew shellenv above) ─────────
# Only add dirs that exist and aren't already in PATH
_prepend_path() {
    local d
    for d in "$@"; do
        [[ -d "$d" && ":$PATH:" != *":$d:"* ]] && export PATH="$d:$PATH"
    done
}
_prepend_path \
    "/usr/local/go/bin" \
    "$HOME/flutter/bin" \
    "$HOME/bin" \
    "$HOME/bin/audio" \
    "$HOME/bin/i3" \
    "$HOME/bin/i3-statusbar" \
    "$HOME/.local/share/npm/bin" \
    "$HOME/.local/share/go/bin" \
    "$HOME/.local/share/cargo/bin" \
    "$HOME/.local/share/nvim/mason/bin" \
    "$HOME/.config/composer/vendor/bin" \
    "$HOME/.local/share/gem/ruby/3.3.0/bin" \
    "/Library/TeX/texbin"
unset -f _prepend_path
