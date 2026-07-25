## Starting from scratch

If you haven't been tracking your configurations in a Git repository before, you can start using this technique easily with these lines:

```
git init --bare $HOME/.cfg
alias dotgit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
dotgit config --local status.showUntrackedFiles no
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
```

## Installing your dotfiles onto a new system (or migrate to this setup)

```
alias dotgit='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
echo ".cfg" >> .gitignore
git clone --bare <git-repo-url> $HOME/.cfg
dotgit checkout
dotgit config --local status.showUntrackedFiles no
```

from: https://www.atlassian.com/git/tutorials/dotfiles
