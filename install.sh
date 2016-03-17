#!/bin/sh

# Backup old .vimrc
if [ -f "$HOME/.vimrc" ] && ! [ -f "$HOME/.vimrc.beforeMiniVim" ]; then
  echo "Backup old .vimrc to .vimrc.beforeMiniVim"
  mv "$HOME/.vimrc" "$HOME/.vimrc.beforeMiniVim"
fi

# Install
dir="$(cd "$(dirname "$0")" && pwd)"
echo "Creating the .vimrc..."
cp "${dir}/vimrc" "$HOME/.vimrc"

# Set an option in your shell to ignore XOFF and XON signals 
# (in order to use Ctrl S and Ctrl Q)
rc="$HOME/.${SHELL##*/}rc"
if [ -f "$rc" ] && fgrep -q "stty -ixon" "$rc"; then
  echo "Ignoring XON signals...."
  echo "stty -ixon" >> "$HOME/.${SHELL##*/}rc"
else
  echo "No shell configuration file found."
  echo "You must have yourself this line :"
  echo "stty -ixon"
fi

# Ready
echo
echo "Installed!"
echo "You need to reload your shell config by running:"
echo "  source \"$HOME/.${SHELL##*/}rc\""
echo "Or by opening a new terminal prompt."
echo
echo "Then you're ready to use MiniVim!"
