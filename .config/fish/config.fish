# fish config

set fish_greeting

# vi mode
function fish_user_key_bindings
  #fish_default_key_bindings
  fish_vi_key_bindings
end

# aliases

#list
alias ls='exa --color=auto'
alias la='exa -a'
alias ll='exa -la'
alias l='exa'
alias l.="exa -A | egrep '^\.'"

# uni workflows
alias uni="cd /home/rick/Documents/BCompSc"
alias emaim="cd /home/rick/Documents/BCompSc/emaim/emaim"
# alias buuni="sudo cp -r /home/rick/Documents/BCompSc /home/rick/NAS/Rick/Documents/BCompSc"
alias buuni='rsync -aPzv --delete --exclude .stack-work --exclude venv --exclude .idea --exclude __pycache__ --exclude .git /home/rick/Documents/BCompSc/ rick@192.168.86.3:/volume1/Rick/Documents/BCompSc/Current'
alias moss='TERM=xterm-256color ssh s4012681@remote.labs.eait.uq.edu.au'
alias unet='cd ~/Documents/BCompSc/COMP3710/report/PatternFlow/recognition/s4012681/'

# pacman and paru
# alias upall="paru -Syu --noconfirm"
alias upall="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"
# alias pacman='sudo pacman --color auto'
alias update='sudo pacman -Syyu'
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"

# dotfiles repo
alias dotgit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# detect audio
alias speaker='pulseaudio -k && pactl load-module module-detect && pactl set-default-sink alsa_output.usb-Generic_USB_Audio_200901010001-00.HiFi__hw_Dock_1__sink'

alias xclip="xclip -selection c" 

starship init fish | source
