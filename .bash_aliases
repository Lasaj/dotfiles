#list
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -la'
alias l='ls'
alias l.="ls -A | egrep '^\.'"

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

#use all cores
alias uac="sh ~/.bin/main/000*"

#continue download
alias wget="wget -c"

#userlist
alias userlist="cut -d: -f1 /etc/passwd"

#merge new settings
alias merge="xrdb -merge ~/.Xresources"
alias upall="sudo apt update && sudo apt upgrade -y && sudo snap refresh && sudo apt autoremove -y"

#ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"

#grub update
alias update-grub="sudo grub-mkconfig -o /boot/grub/grub.cfg"

#add new fonts
alias update-fc='sudo fc-cache -fv'

#hardware info --short
alias hw="hwinfo --short"

#check vulnerabilities microcode
alias microcode='grep . /sys/devices/system/cpu/vulnerabilities/*'


#youtube-dl
alias yta-aac="youtube-dl --extract-audio --audio-format aac "
alias yta-best="youtube-dl --extract-audio --audio-format best "
alias yta-flac="youtube-dl --extract-audio --audio-format flac "
alias yta-m4a="youtube-dl --extract-audio --audio-format m4a "
alias yta-mp3="youtube-dl --extract-audio --audio-format mp3 "
alias yta-opus="youtube-dl --extract-audio --audio-format opus "
alias yta-vorbis="youtube-dl --extract-audio --audio-format vorbis "
alias yta-wav="youtube-dl --extract-audio --audio-format wav "

alias ytv-best="youtube-dl -f bestvideo+bestaudio "

#Recent Installed Packages
alias rip="grep 'installed' /var/log/dpkg.log | sort | tail -200 | nl"
alias riplong="grep 'installed' /var/log/dpkg.log | sort | tail -3000 | nl"

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
alias matlab="env MESA_LOADER_DRIVER_OVERRIDE=i965 matlab -desktop -nosplash &"
alias unsafe_buuni='rsync -aPzv --delete --exclude .stack-work --exclude venv --exclude .idea --exclude __pycache__ --exclude .git /home/rick/Documents/BCompSc/ rick@192.168.86.241:/volume1/Rick/Documents/BCompSc/Current'
alias buuni='rsync -aPzv --exclude .stack-work --exclude venv --exclude .idea --exclude __pycache__ --exclude .git /home/rick/Documents/BCompSc/ rick@192.168.86.241:/volume1/Rick/Documents/BCompSc/Current'
alias weka="/usr/local/weka-3-8-6/weka.sh"

alias xclip="xclip -selection c"

alias dotgit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias doro='python3 /home/rick/Documents/playground/antidoro/main.py uni.json'

alias bash_com='fabric -sp bash_com'
alias bash_com_l='fabric -sp bash_com -m gemma3:4b'

alias bashcom='f() { echo "$1" | fabric -sp bash_com; }; f'

alias ilu='signal-cli send -m "I love you, Lan-Lan" +61413840044'
