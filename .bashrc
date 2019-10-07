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
if [[ -e ~/.bash_function ]]; then
    source ~/.bash_function
fi

# load bash powerline if it exists
if [[ -e ~/.bash_powerline.sh ]]; then
    source ~/.bash_powerline.sh
    pl-disable k8s
fi

# load bash variables if it exists
if [[ -e ~/.bash_variables ]]; then
    source ~/.bash_variables
fi

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/yusuke/.sdkman"
[[ -s "/home/yusuke/.sdkman/bin/sdkman-init.sh" ]] && source "/home/yusuke/.sdkman/bin/sdkman-init.sh"
