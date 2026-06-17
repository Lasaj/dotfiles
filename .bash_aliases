#list
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -la'
alias l='ls'
alias l.="ls -A | rg '^\.'"

#fix obvious typo's
alias cd..='cd ..'
alias pdw="pwd"

## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

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
alias uni='cd ~/Documents/BCompSc/'
alias unsafe_buuni='rsync -aPzv --delete --exclude .stack-work --exclude venv --exclude .idea --exclude __pycache__ --exclude .git /home/rick/Documents/BCompSc/ rick@192.168.86.241:/volume1/Rick/Documents/BCompSc/Current'
alias buuni='rsync -aPzv --exclude .stack-work --exclude venv --exclude .idea --exclude __pycache__ --exclude .git /home/rick/Documents/BCompSc/ rick@192.168.86.241:/volume1/Rick/Documents/BCompSc/Current'
alias os_buuni='rsync -aPzv --exclude .stack-work --exclude venv --exclude .idea --exclude __pycache__ --exclude .git /home/rick/Documents/BCompSc/ rick@bokonon-nas:/volume1/Rick/Documents/BCompSc/Current'

alias xclip="xclip -selection c"

alias dotgit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias dotlazy='lazygit --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias doro='python3 /home/rick/Documents/playground/antidoro/main.py uni.json'

# --- Quality of Life (QoL) Aliases ---

# Syntax Highlighted cat / preview (using bat)
alias cat='bat --style=plain --paging=never'
alias preview='bat'

# Use ripgrep by default instead of standard grep
alias grep='rg'

# Quick directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
