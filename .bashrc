alias "dc"="docker compose"
alias "dce"="docker compose exec"

# Enable vi mode only inside tmux
if [ -n "$TMUX" ]; then
  set -o vi
fi

# Force Ctrl+L to clear screen
bind '"\C-l": clear-screen'

# prefered text editor
export EDITOR=vim
