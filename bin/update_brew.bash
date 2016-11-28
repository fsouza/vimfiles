#!/bin/bash -le

brew update
brew upgrade

brew reinstall --HEAD neovim/neovim/neovim

brew cleanup -s
brew services cleanup
