#!/bin/sh

vimrc="$HOME/.vimrc"
thisDir="$(cd "$(dirname "$0")" && pwd)"
shellRc="$HOME/.${SHELL##*/}rc"

## Backup old .vimrc
if [ -f "$vimrc" ] && ! [ -f "$HOME/.vimrc.beforeMiniVim" ]; then
  echo "Backup old .vimrc to .vimrc.beforeMiniVim"
  mv "$vimrc" "$HOME/.vimrc.beforeMiniVim"
fi

## Install
# Create the destination dir
echo "Creating the .vim dir..."
mkdir -p "$HOME/.vim"
# Copying the MiniVim file
echo "Copying the MiniVim config..."
cp "${thisDir}/vimrc" "$HOME/.vim/MiniVim.vimrc"
# Sourcing in the main vimrc
touch "$vimrc"
if grep -q 'source $HOME/.vim/MiniVim.vimrc' "$vimrc"; then
  echo "Great, your already installed MiniVim."
else
  echo "Configuring the .vimrc..."
  cat <<- 'EOF' >> "$vimrc"
	""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" MiniVim
	" Details on : https://github.com/sd65/MiniVim
	let g:MiniVimVersion = "1.3.3"
	let g:UseCustomKeyBindings = 1
	source $HOME/.vim/MiniVim.vimrc
	""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	EOF
fi

## Set an option in your shell to ignore XOFF and XON signals
## (in order to use Ctrl S and Ctrl Q)
if [ -f "$shellRc" ]; then
  if fgrep -q "stty -ixon" "$shellRc"; then
    echo "Great, your shell is already ignoring XON signals."
  else
    echo "Ignoring XON signals...."
    echo "stty -ixon" >> "$shellRc"
    echo "> You need to reload your shell config by running :"
    echo "  source $shellRc"
    echo "Or by opening a new terminal prompt."
  fi
else
  echo "No shell configuration file found."
  echo "Add this line to your shell config (.bashrc, .zshrc, etc) :"
  echo "stty -ixon"
  echo "Then open a new terminal prompt"
fi

## Ready
echo
echo "> Installed !"
echo "Just open vim now."
