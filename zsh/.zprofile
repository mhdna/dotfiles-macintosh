#!/bin/zsh

export EDITOR="editor-wrapper"
export TERMINAL="term-wrapper"
export BROWSER="browser-wrapper"

export MEDIA="/mnt/media"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_VIDEOS_DIR="$HOME/Videos"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_DOCUMENTS_DIR="$HOME/Documents"
export NOTES_DIR="$HOME/personal/notes"
export XDG_CONFIG_HOME="$HOME/.config"
export XRESOURCES="$HOME/.Xresources"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority" # Breaks some display managers like lightdm and sddm
export RLWRAP_HOME="$XDG_DATA_HOME"/rlwrap # used by translate-shell as an interactive shell wrapper
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch-config"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export CM_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"
export LESS=-R
export LESSHISTFILE="-"
export LESS_TERMCAP_md=$'\e[1;38;5;3m'    # Bold
export LESS_TERMCAP_me=$'\e[0m'           # End Bold
export LESS_TERMCAP_us=$'\e[4;38;5;6m'    # Underline
export LESS_TERMCAP_ue=$'\e[0m'           # End Underline
export GROFF_NO_SGR=1                     # Needed since groff 1.23

# export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export KODI_DATA="$XDG_DATA_HOME/kodi"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
export UNISON="$XDG_DATA_HOME/unison"
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
export MBSYNCRC="$XDG_CONFIG_HOME/mbsync/config"
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/pythonrc"
# export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME"/java
# Other program settings:
export DICS="$HOME/.stardict/dic/"
export SDCV_PAGER='less --quit-if-one-screen -RX'
export SUDO_ASKPASS="$HOME/bin/menus/askpass_menu"
export MOZ_USE_XINPUT2="1"		# Mozilla smooth scrolling/touchpads.
export AWT_TOOLKIT="MToolkit wmname LG3D"	#May have to install wmname
export _JAVA_AWT_WM_NONREPARENTING=1	# Fix for Java applications in dwm/bspwm
# export QT_STYLE_OVERRIDE=adwaita-dark
export QT_QPA_PLATFORMTHEME=qt6ct
export TRANSMISSION_DAEMON="transmission-daemon -w $MEDIA/torrent --logfile $XDG_CACHE_HOME/transmission/log"
# export FZF_DEFAULT_OPTS='--reverse' # --no-color
export BAT_THEME='ansi'
export BAT_STYLE='plain'
export FZF_PREVIEW_COMMAND='bat --style=plain {}'
export JAVA_HOME=/usr/lib/jvm/default
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export NPM_PATH="$XDG_DATA_HOME/npm"
export LSP_SERVERS_PATH="$XDG_DATA_HOME/nvim/mason/bin"
export PHP_COMPOSER_PATH="$XDG_CONFIG_HOME/composer/vendor/bin"
# export YDOTOOL_SOCKET="$HOME/.ydotool_socket"

export SHIORI_HTTP_SECRET_KEY="X43eZvn7++fF9Anhobepd3yMQsXt0e4LCY7kqPkQNGE=" # (openssl rand -base64 32) to gene_rate a new one
export GEM_HOME="$XDG_DATA_HOME/gem/ruby/3.3.0/bin/"

# # allow non-free nix packages
# export NIXPKGS_ALLOW_UNFREE=1

# export http_proxy=http://127.0.0.1:8080/
# export https_proxy=$http_proxy
# export ftp_proxy=$http_proxy
# export rsync_proxy=$http_proxy

eval $(gdircolors ~/.dircolors)

BREW_BIN="/usr/local/bin/brew"
if [ -f "/opt/homebrew/bin/brew" ]; then
    BREW_BIN="/opt/homebrew/bin/brew"
fi

if type "${BREW_BIN}" &> /dev/null; then
    export BREW_PREFIX="$("${BREW_BIN}" --prefix)"
    for bindir in "${BREW_PREFIX}/opt/"*"/libexec/gnubin"; do export PATH=$bindir:$PATH; done
    for bindir in "${BREW_PREFIX}/opt/"*"/bin"; do export PATH=$bindir:$PATH; done
    for mandir in "${BREW_PREFIX}/opt/"*"/libexec/gnuman"; do export MANPATH=$mandir:$MANPATH; done
    for mandir in "${BREW_PREFIX}/opt/"*"/share/man/man1"; do export MANPATH=$mandir:$MANPATH; done
fi

HOMEBREW_NO_AUTO_UPDATE=1

# -H for it to not treat symlinks as the dst, but the directories that they point to
export PATH="$PATH:$(find -H $HOME/bin $HOME/bin -type d ):$NPM_PATH/bin:$GOPATH/bin:$CARGO_HOME/bin:$JAVA_HOME/bin:$LSP_SERVERS_PATH:$PHP_COMPOSER_PATH:$GEM_HOME"
# setsid -f mailsync >/dev/null 2>&1&

# Start graphical server on user's current tty if not already running and put the outputs into ~/.local/share/xorg/
# use exec to automatically close the shell when the X11 server gets killed
[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && startx "$XINITRC" # to close tty after logging out use `exec` before startx
# [ "$(tty)" = "/dev/tty1" ] && ! pidof -s sway >/dev/null 2>&1 && startw

[ ! -f $XDG_CONFIG_HOME/shell/shortcutrc ] && setsid shortcuts >/dev/null 2>&1

# Switch escape and caps if tty and no passwd required and keyd isn't installed:
# ! command -v keyd > /dev/null 2>&1 && sudo -n loadkeys ${XDG_CONFIG_HOME:-$HOME}/.ttymaps.kmap 2> /dev/null
sudo -n loadkeys ${XDG_CONFIG_HOME:-$HOME}/.ttymaps.kmap 2> /dev/null
