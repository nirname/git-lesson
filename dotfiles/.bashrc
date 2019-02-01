#!/usr/bin/env bash

source "/root/.git_completion"
source "/root/.bash_prompt"

alias next='cd $(cli next-path); task'
alias prev='cd $(cli prev-path); task'
alias list='cli list'
alias h='cli help'
alias task='cli task'

clear
echo "Добро пожаловать на семинар по Git!"
echo
cli help