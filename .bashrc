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
alias rm="trash -i"
alias cp="cp -i"
alias sc="scrot -sfe 'xclip -selection clipboard -t image/png -i $f'"
alias salesops="cd ~/eureciclo/salesops"
alias pessoal="cd ~/gdrive-pessoal/pessoal"
alias trabalho="cd ~/gdrive-pessoal/trabalho"
alias estudo="cd ~/gdrive-pessoal/estudo"
alias ~="cd ~"
alias arch-setup="cd ~/gdrive-pessoal/pessoal/programação/arch_setup"
alias downloads="cd ~/gdrive-pessoal/downloads"
alias fotos="cd ~/gdrive-pessoal/pessoal/fotos"
#To reload .bashrc use ->  source ~/.bashrc
