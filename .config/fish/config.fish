# fish config

set fish_greeting

# vi mode
function fish_user_key_bindings
  #fish_default_key_bindings
  fish_vi_key_bindings
end

# aliases

#list
alias ls='ls --color=auto'
alias la='ls -a'
alias ll='ls -la'
alias l='ls'
alias l.="ls -A | egrep '^\.'"

alias uni="cd /home/rick/Documents/BCompSc"
alias buuni="sudo cp -r /home/rick/Documents/BCompSc /home/rick/NAS/Rick/Documents/BCompSc"

alias upall="paru -Syu --noconfirm"
alias pacman='sudo pacman --color auto'
alias update='sudo pacman -Syyu'

alias dotgit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias buuni='rsync -aPzv --delete --exclude .stack-work --exclude venv --exclude .idea --exclude __pycache__ --exclude .git /home/rick/Documents/BCompSc/ rick@192.168.86.3:/volume1/Rick/Documents/BCompSc/Current'
alias uni='cd /home/rick/Documents/BCompSc'

