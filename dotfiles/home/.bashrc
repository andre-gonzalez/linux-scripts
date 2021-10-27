#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

PS1="\W\033[00;32m\]\$(git_branch)\[\033[00m\] > "
########
#ALCI
########
export EDITOR='/usr/bin/nvim'
export VISUAL='/usr/bin/nvim'
export FZF_DEFAULT_COMMAND="fd . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d . $HOME"
# Alias
alias evb='doas systemctl enable --now vboxservice.service'
alias r="ranger"
alias l="ls --color -h --group-directories-first"
alias mv="mv -i"
alias rm="trash -i"
alias cp="cp -i"
alias sc="scrot -sfe 'xclip -selection clipboard -t image/png -i $f'"
alias salesops="cd ~/eureciclo/salesops"
alias pessoal="cd ~/gdrive-pessoal/pessoal"
alias trabalho="cd ~/gdrive-pessoal/trabalho"
alias estudo="cd ~/gdrive-pessoal/estudo"
alias ~="cd ~"
alias arch-setup="cd ~/gdrive-pessoal/pessoal/programação/arch-setup"
alias dotfiles="cd ~/gdrive-pessoal/pessoal/programação/arch-setup/dotfiles"
alias downloads="cd ~/gdrive-pessoal/downloads"
alias fotos="cd ~/gdrive-pessoal/pessoal/fotos"
alias hubspot="cd ~/eureciclo/salesops/hubspot"
alias pipefy="cd ~/eureciclo/salesops/pipefy"
alias slack="cd ~/eureciclo/salesops/slack-bot"
alias ..="cd .."
alias edownloads="cd ~/eureciclo/downloads"
alias database="cd ~/eureciclo/salesops-dw/"
alias tar="tar -xf"
alias v="nvim"
alias b="brightnessctl s"
alias p="python3"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push -u origin"
alias mirror="doas reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist" #get fastest mirrors
alias sudo="doas"
alias sudoedit="doas rvim"
alias pms="doas pacman -S"
alias pmu="doas pacman -Syu"
alias pmr="doas pacman -Rns"
alias vobsidian="cd gdrive-pessoal/pessoal/obsidian"
alias organizar="cd /home/frank/gdrive-pessoal/pessoal/obsidian/_organizar"
alias vo="fzf | xargs -r $EDITOR"
#To reload .bashrc use ->  source ~/.bashrc

#auto cd. Moving around without the need to type cd
shopt -s autocd
shopt -s cdspell #aurocorrects cd misspellings
shopt -s expand_aliases #expand aliases

#ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/frank/.config/google-cloud-sdk/path.bash.inc' ]; then . '/home/frank/.config/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/frank/.config/google-cloud-sdk/completion.bash.inc' ]; then . '/home/frank/.config/google-cloud-sdk/completion.bash.inc'; fi
