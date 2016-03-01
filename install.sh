#!/bin/sh

# Backup old .vimrc
if [ -f "$HOME/.vimrc" ]; then
  echo "Backup old .vimrc to .vimrc.beforeMiniVim"
  mv $HOME/.vimrc $HOME/.vimrc.beforeMiniVim
fi

# Install
dir="$(dirname $(readlink -f "$0"))"
echo "Creating the .vimrc..."
cp "${dir}/vimrc"  $HOME/.vimrc

# Set an option in your shell to ignore XOFF and XON signals 
# (in order to use Ctrl S and Ctrl Q)
echo "Ignoring XON signals...."
echo "stty -ixon" >> $HOME/.${SHELL##*/}rc

# Ready
echo
echo "Installed!"
echo "You need to reload your shell config by running:"
echo "  source $HOME/.${SHELL##*/}rc"
echo "Or by opening a new terminal prompt."
echo
echo "Then you're ready to use MiniVim!"
