# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# load utility functions if it exists
if [[ -f ~/.bash_functions ]]; then
    . ~/.bash_functions
fi

# load bash powerline if it exists
if [[ -f ~/.bash_powerline.sh ]]; then
    . ~/.bash_powerline.sh
fi

# load bash variables if it exists
if [[ -f ~/.bash_variables ]]; then
    . ~/.bash_variables
fi

# load additional scripts
if [[ -f ~/.bash_additionals ]]; then
    . ~/.bash_additionals
fi
