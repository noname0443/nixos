# Commands that should be applied only for interactive shells.
[[ $- == *i* ]] || return

HISTFILESIZE=100000
HISTSIZE=10000

shopt -s histappend
shopt -s checkwinsize
shopt -s extglob
shopt -s globstar
shopt -s checkjobs



if [[ ! -v BASH_COMPLETION_VERSINFO ]]; then
  . "/nix/store/qm7ybllh3nrg3sfllh7n2f6llrwbal58-bash-completion-2.16.0/etc/profile.d/bash_completion.sh"
fi

eval "$(starship init bash)"
