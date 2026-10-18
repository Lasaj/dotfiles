#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- History Configuration ---
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
export HISTFILESIZE=20000
export HISTTIMEFORMAT="%F %T "
export HISTIGNORE="ls:ll:la:l:cd:pwd:exit:clear:history"

# Append new commands to ~/.bash_history immediately after every command
case "${PROMPT_COMMAND:-}" in
    *"history -a"*) ;;
    *) PROMPT_COMMAND="history -a${PROMPT_COMMAND:+; $PROMPT_COMMAND}" ;;
esac

# Fallback prompt (overridden by Starship below if installed)
PS1='[\u@\h \W]\$ '

# --- PATH Configuration (deduplicated) ---
path_prepend() {
    [ -d "$1" ] && case ":$PATH:" in
        *":$1:"*) ;;
        *) PATH="$1:$PATH" ;;
    esac
}
path_prepend "$HOME/.bin"
path_prepend "$HOME/.local/bin"
unset -f path_prepend
export PATH

# --- Readline & Completion Settings ---
# ignore upper and lowercase when TAB completion
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'
bind 'set mark-symlinked-directories on'
bind 'set colored-stats on'
bind 'set visible-stats on'
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'

# Up/Down arrows search history matching current input prefix
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

# --- Shell Options (shopt) ---
shopt -s autocd         # change to named directory
shopt -s cdspell        # autocorrects cd misspellings
shopt -s checkwinsize   # update LINES and COLUMNS after each command (great for Kitty splits)
shopt -s cmdhist        # save multi-line commands in history as single line
shopt -s globstar       # enable '**' recursive globbing
shopt -s histappend     # do not overwrite history
shopt -s expand_aliases # expand aliases
# shopt -s dotglob      # disabled for safety so 'rm *' doesn't match hidden files

# --- Everyday Helper Functions ---
# Create a directory and cd into it immediately
mkcd() {
    mkdir -p -- "$1" && cd -P -- "$1" || return
}

# Create a timestamped backup copy of a file or directory
bak() {
    cp -a -- "$1" "${1%/}.bak.$(date +%Y%m%d-%H%M%S)"
}

# Go up N directories (e.g. 'up 3' instead of 'cd ../../..')
up() {
    local d="" limit="${1:-1}"
    for ((i=1; i<=limit; i++)); do
        d="../$d"
    done
    cd "$d" || return
}

# # ex = EXtractor for all kinds of archives
# # usage: ex <file>
ex ()
{
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2|*.tbz2) tar xjf "$1"        ;;
      *.tar.gz|*.tgz)   tar xzf "$1"        ;;
      *.tar.xz|*.txz)   tar xJf "$1"        ;;
      *.tar.zst)        tar --zstd -xf "$1" ;;
      *.tar)            tar xf "$1"         ;;
      *.bz2)            bunzip2 "$1"        ;;
      *.rar)            unrar x "$1"        ;;
      *.gz)             gunzip "$1"         ;;
      *.xz)             unxz "$1"           ;;
      *.zst)            unzstd "$1"         ;;
      *.zip)            unzip "$1"          ;;
      *.Z)              uncompress "$1"     ;;
      *.7z)             7z x "$1"           ;;
      *.deb)            ar x "$1"           ;;
      *.rpm)            rpm2cpio "$1" | cpio -idmv ;;
      *)                echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# --- Environment & Integrations ---
# Added by Antigravity CLI installer
export BROWSER=firefox

# Syntax-highlighted manpages via bat (MANROFFOPT="-c" fixes groff ANSI escapes on openSUSE)
if command -v bat >/dev/null 2>&1; then
    export MANROFFOPT="-c"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

#create a file called .bashrc-personal and put all your personal aliases
#in there. They will not be overwritten by skel.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Enable Starship prompt (skip in 'dumb' terminals)
[ "$TERM" != "dumb" ] && command -v starship >/dev/null 2>&1 && eval "$(starship init bash)"

# Enable zoxide (smarter cd)
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init bash)"

# Enable direnv (automatic project environments)
command -v direnv >/dev/null 2>&1 && eval "$(direnv hook bash)"

# Enable fzf keybindings and completion (if installed)
command -v fzf >/dev/null 2>&1 && eval "$(fzf --bash)"
