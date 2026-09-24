alias "dc"="docker compose"
alias "dce"="docker compose exec"
alias "sdc"="sudo docker compose"

# Enable vi mode only inside tmux
if [ -n "$TMUX" ]; then
  set -o vi
fi

# Force Ctrl+L to clear screen
bind '"\C-l": clear-screen'

# prefered text editor
export EDITOR=vim

# enable CTRL-S for forward search history
stty -ixon
