# on mac, coreutils is needed to get realpath.
basedir=$(dirname $(realpath ${(%):-%N}))
source ${basedir}/extra/init-functions

autoload -U compinit && compinit

export RBENV_ROOT=${HOME}/.rbenv
export MANPATH=/usr/share/man:/usr/local/share/man:${basedir}/extra/z
export GOBIN=$HOME/bin GOPATH=$HOME/.go GIMME_SILENT_ENV=1 GIMME_TYPE=binary
export EDITOR=nvim PAGER=less MANPAGER=less

export PATH=/usr/bin:/bin:/usr/sbin:/sbin
prepend_to_path \
	${basedir}/extra/gimme \
	/usr/local/sbin \
	/usr/local/bin \
	${HOME}/.cargo/bin \
	${RBENV_ROOT}/shims \
	${HOME}/.local/bin \
	${basedir}/bin \
	${GOBIN}

source ${basedir}/extra/brew

cond_source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
cond_source "${HOME}/.gimme/envs/gotip.env"
cond_source "${basedir}/extra/z/z.sh"

source ${basedir}/extra/virtualenv
source ${basedir}/extra/gpg-agent

source ${basedir}/extra/git
source ${basedir}/extra/go
source ${basedir}/extra/mail
source ${basedir}/extra/ocaml
source ${basedir}/extra/neovim
source ${basedir}/extra/rclone

cond_source "${basedir}/extra/local-functions"
cond_source "${basedir}/extra/${OS_NAME}-functions"

export PS1="％ " PS2="\\ "

if command -v opam &>/dev/null; then
	eval "$(opam env)"
fi

if command -v fnm &>/dev/null; then
	eval "$(fnm env --multi)"
fi

if command -v rg &>/dev/null; then
	export FZF_DEFAULT_COMMAND="rg -l --hidden -g '!.git' -g '!.hg' '.*'"
fi

source ${basedir}/extra/tmux
unset basedir

fpath=(/usr/local/share/zsh-completions $fpath)
export ZLE_SPACE_SUFFIX_CHARS=$'|&'

export HISTFILE="$HOME/.history"
export HISTSIZE=1234567890
export SAVEHIST=$HISTSIZE

setopt noautomenu
setopt nomenucomplete

setopt BANG_HIST
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY

bindkey -e