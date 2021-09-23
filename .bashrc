#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='\W > '

########
#ALCI
########
alias evb='sudo systemctl enable --now vboxservice.service'
export EDITOR='/usr/bin/vim'
export VISUAL='/usr/bin/vim'

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/frank/.config/google-cloud-sdk/path.bash.inc' ]; then . '/home/frank/.config/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/frank/.config/google-cloud-sdk/completion.bash.inc' ]; then . '/home/frank/.config/google-cloud-sdk/completion.bash.inc'; fi

# Alias
alias r="ranger"
alias l="ls -CF"
alias mv="mv -i"
alias rm="rm -i"
alias cp="cp -i"
