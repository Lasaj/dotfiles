#list (uses eza with icons & git status if installed, otherwise standard ls)
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --color=auto --group-directories-first --icons=auto'
    alias la='eza -a --color=auto --group-directories-first --icons=auto'
    alias ll='eza -la --git --color=auto --group-directories-first --icons=auto'
    alias lt='eza --tree --level=2 --color=auto --icons=auto'
    alias l='eza --color=auto --group-directories-first --icons=auto'
    alias l.='eza -d .* --color=auto --icons=auto'
else
    alias ls='ls --color=auto'
    alias la='ls -a'
    alias ll='ls -la'
    alias l='ls'
    alias l.='ls -d .* --color=auto'
fi

#fix obvious typo's
alias cd..='cd ..'
alias pdw="pwd"

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='grep -E --color=auto'
alias fgrep='grep -F --color=auto'

#readable output
alias df='df -h'

#free
alias free="free -mt"


#continue download
alias wget="wget -c"

#userlist
alias userlist="cut -d: -f1 /etc/passwd"

#merge new settings
alias merge="xrdb -merge ~/.Xresources"
alias upall="sudo zypper ref && sudo zypper dup && flatpak update"

# zypper shortcuts
alias zyin="sudo zypper install"
alias zyrm="sudo zypper remove"
alias zyup="sudo zypper update"
alias zyref="sudo zypper refresh"
alias zyse="zypper search"
alias zyinfo="zypper info"

#ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"


#add new fonts
alias update-fc='sudo fc-cache -fv'

#hardware info --short
alias hw="hwinfo --short"

#check vulnerabilities microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'


#yt-dlp
alias yta-aac="yt-dlp --extract-audio --audio-format aac "
alias yta-best="yt-dlp --extract-audio --audio-format best "
alias yta-flac="yt-dlp --extract-audio --audio-format flac "
alias yta-m4a="yt-dlp --extract-audio --audio-format m4a "
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3 "
alias yta-opus="yt-dlp --extract-audio --audio-format opus "
alias yta-vorbis="yt-dlp --extract-audio --audio-format vorbis "
alias yta-wav="yt-dlp --extract-audio --audio-format wav "

alias ytv-best="yt-dlp -f bestvideo+bestaudio "

#Recent Installed Packages
alias rip="rpm -qa --last | head -200 | nl"
alias riplong="rpm -qa --last | head -3000 | nl"

#gpg
#verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
#receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

#shutdown or reboot
alias ssn="sudo shutdown now"
alias sr="sudo reboot"

#Uni programs and aliases
_UNI_RSYNC_EXCLUDES="--exclude .stack-work --exclude venv --exclude .idea --exclude __pycache__ --exclude .git"
alias uni='cd ~/Documents/BCompSc/'
alias pushuni="rsync -aPzv $_UNI_RSYNC_EXCLUDES /home/rick/Documents/BCompSc/ rick@192.168.86.241:/volume1/Rick/Documents/BCompSc/Current"
alias pulluni="rsync -aPzv $_UNI_RSYNC_EXCLUDES rick@192.168.86.241:/volume1/Rick/Documents/BCompSc/Current/ /home/rick/Documents/BCompSc/"
alias unsafe_buuni="rsync -aPzv --delete $_UNI_RSYNC_EXCLUDES /home/rick/Documents/BCompSc/ rick@192.168.86.241:/volume1/Rick/Documents/BCompSc/Current"
alias buuni='~/.local/bin/backup_uni.sh'
alias buuni-list='restic -r sftp:nas:/Rick/Documents/BCompSc_backup --password-file ~/.config/restic/repo_password.txt snapshots'
alias os_buuni="rsync -aPzv $_UNI_RSYNC_EXCLUDES /home/rick/Documents/BCompSc/ rick@bokonon-nas:/volume1/Rick/Documents/BCompSc/Current"

# Bidirectional sync (2-pass rsync preserving newer files with -u)
syncuni() {
    echo "==> Syncing local -> remote..."
    rsync -aPzvu $_UNI_RSYNC_EXCLUDES /home/rick/Documents/BCompSc/ rick@192.168.86.241:/volume1/Rick/Documents/BCompSc/Current/
    echo "==> Syncing remote -> local..."
    rsync -aPzvu $_UNI_RSYNC_EXCLUDES rick@192.168.86.241:/volume1/Rick/Documents/BCompSc/Current/ /home/rick/Documents/BCompSc/
}

alias xclip="xclip -selection c"

alias dotgit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias dotlazy='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias doro='python3 /home/rick/Documents/playground/antidoro/main.py uni.json'

# --- Quality of Life (QoL) Aliases ---
alias neofetch='fastfetch'

# Syntax Highlighted cat / preview (using bat)
alias cat='bat --style=plain --paging=never'
alias preview='bat'

# Kitty terminal & SSH helpers
if [ "$TERM" = "xterm-kitty" ]; then
    alias ssh='TERM=xterm-256color command ssh'
    alias kssh='kitten ssh'
    alias icat='kitten icat'
    alias kdiff='kitten diff'
fi

# Quick directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
