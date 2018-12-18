OS=$(uname -s)

export NVM_DIR="$HOME/.nvm"
export RBENV_ROOT=${HOME}/.rbenv
export MANPATH=/usr/share/man:/usr/local/share/man:${HOME}/.dotfiles/extra/z
export GOPATH=$HOME GIMME_SILENT_ENV=1 GIMME_TYPE=binary

export PATH=$GOPATH/bin:$RBENV_ROOT/shims:${HOME}/.dotfiles/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:${HOME}/.dotfiles/extra/gimme:$PATH

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_EMOJI=1
export HOMEBREW_NO_GITHUB_API=1

[ -f ${HOME}/.dotfiles/extra/z/z.sh ] && source ${HOME}/.dotfiles/extra/z/z.sh

export EDITOR=nvim PAGER=less MANPAGER=less

source ${HOME}/.dotfiles/extra/virtualenv
source ${HOME}/.dotfiles/extra/gpg-agent

source ${HOME}/.dotfiles/extra/chapel
source ${HOME}/.dotfiles/extra/functions

[ -f ${HOME}/.dotfiles/extra/local-functions ] && source ${HOME}/.dotfiles/extra/local-functions
[ -f ${HOME}/.dotfiles/extra/${OS}-functions ] && source ${HOME}/.dotfiles/extra/${OS}-functions
[ -f /usr/local/etc/bash_completion ] && source /usr/local/etc/bash_completion

[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

export PS1=":: "
eval $(opam env)
source ~/.gimme/envs/gotip.env
