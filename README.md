# MiniVim

*Click to launch a YouTube video demo:*

[![A screenshot](https://raw.githubusercontent.com/sd65/MiniVim/master/Screenshot.png)](https://www.youtube.com/watch?v=n0h_3e0FfYk)

A longer and more up to date demo is available here : [Demo](https://youtu.be/3kX7GdCIjrk)

## Goals

- No bullshit default key mappings
- Mimic Sublime Text / Shell key mappings
- Minimal: one file, **no plugin needed!**

## Automated setup

- Clone this repo to the folder of your choice:

`git clone https://github.com/sd65/MiniVim.git`

- Go inside this repo:

`cd MiniVim`

- Launch the install script and follow the instructions:

`./install.sh`

- It's ready! :smile: Launch Vim:

`vim`

## Manual setup

If you can't clone the repo and do the above steps, just download the .vimrc to your home dir (backup your current .vimrc before).

`wget https://raw.githubusercontent.com/sd65/MiniVim/master/vimrc -O ~/.vimrc`

And then add `stty -ixon` to your .zshrc or .bashrc (your shell will ignore XON/XOFF signals. Needed to remap Ctrl S, Ctrl Q). It will prevent the terminal from "freezing" when saving a file or duplicating a line.

## How to use

- **The key mappings can be used in Insert, Normal and Visual mode (yes, no need to exit Insert or Visual mode)**
- The mouse can be used in Normal and Visual mode to scroll, select, change tab and more.
- There are clear visual hints on which mode you currently using. Like pink=normal, blue=insert and green=visual...

### General Mappings

**You hate those mappings? No problem, change this in your .vimrc : `UseCustomKeyBindings=0`.**

Keys | Action | Comments         
| :---: | :---: | :---: |
| **Moving** | **----------** | **----------**
`Arrows` | Move the cursor | Like every editor
`Ctrl Arrows` | Move the cursor *fast*. | Ctrl is a booster!
`Ctrl A` | Go to the beginning of the line | As in Nano/Shell
`Ctrl E` | Go to the end of the line | As in Nano/Shell, remember as **E**nd
`Home` | Go to the beginning of the file | Self explanatory
`End` | Go to the end of the file | Self explanatory too 
| **Tabs** | **----------** | **----------**
`Ctrl T` | Open a new tab | Like Sublime, remember as **T**ab
`Alt Arrows` | Switch between tabs. | `Ctrl Tab` cannot be mapped...
| **History** | **----------** | **----------**
`Ctrl Z` | Undo | Like Sublime
`Ctrl R` | Redo | Like no other, remember as **R**edo
| **Editing** | **----------** | **----------**
`Tab` | Indent | Like Sublime
`Shift Tab` | Unindent | Like Sublime
`Ctrl F` | Find | Like Sublime, remember as **F**Ind
`Ctrl H` | Search and Replace | Like Sublime
`Ctrl G` | Search and Replace on the line | Useful when duplicating a line and editing the new one
`PageUp` | Move the line up | Usefull function so dedicated key (don't trust me ? Try it.)
`PageDown` | Move the line down | Same as above             
`Ctrl K` | Delete the whole line/block | Like in nano, inspired by Sublime too, remember as **K**ill the line
`Ctrl Q` | Duplicate the line/block | Remember as "dupli**q**ate"?
`Ctrl L` | Clear/Delete all lines | Like in a shell, remember as C**l**ear
`Ctrl D` | Delete char from the left, as `Del` | Like in a shell, remember as **D**elete
`Ctrl N` | Autocomplete word | Default VIM mapping but interesting one 
| **Vital** | **----------** | **----------**
`Ctrl S` | Save | Like Sublime, remember as **S**ave
`Ctrl C` | Quit | Like in a shell
| **Miscellaneous** | **----------** | **----------**
`F2` | Set paste toggle | With paste on you can paste more easily
`F3` | Show line numbers toggle | Show or hide line numbers
`F4` | Panic Button! Toggle garbage screen | Remember as "I need to alt-**F4**!"
`F6` | Toggle color column at 80th char | A visual helper to write clean code

### Mappings in Explorer

Keys | Action | Comments
| :---: | :---: | :---: |
`Ctrl O` | Open the Explorer | Remember as **O**pen
`Enter` or `Right Arrow` | Enter a file/dir | Easy one
`Left Arrow` | Go up a dir | Easy one too
`l` | Display info on file/dir | Remember as **l**s
`n` | Open a menu to make an action (Create file/dir, Rename, Delete) | Remember as ... **N**ew action?
`a` | Toggle 'Show Hidden files only, Show All, Hide hidden files (default)' | Default mapping
`Ctrl C` | Quit | Like in a shell

### Custom commands

You can enter those command in normal mode.

Cmd | Action
| :---: | :---:
`:UndoCloseTab` | Reopen the last close buffer/tab in a new tab
`:RemoveTrailingSpaces` | Remove the unwanted spaces at the end of lines

## How to add plugins to MiniVim

The [automated setup](#automated-setup) source in the main Vim configuration file *(.vimrc)* MiniVim.
This means that you have a clean and standard .vimrc. 

**To keep MiniVim, don't delete the `source [...]/MiniVim` instruction in the .vimrc file.**

To add plugins, simply follow the plugin's instructions. You should manage them with a plugin manager as [Vundle](https://github.com/VundleVim/Vundle.vim) or the old [Pathogen](https://github.com/tpope/vim-pathogen).

## How to use MiniVim with *sudo*

First, you could install MiniVim as root. Or better soft link your .vimrc.
But it's sometimes not the best solution, like in a company where the root user is shared.

So, you can configure your system to use MiniVim when you `sudo vim [file]`.
There are 2 solutions :
- `sudo -E vim [file]` as `-E ` preserve your existing environment variables (as $HOME here and therefore your ~/.vimrc).
- `sudoedit [file]` or `sudo -e [file]` (synonyms). To use this, you must have set your `$EDITOR` environment variable. Then, this command will make a copy of the designated file and you will edit the copy. Note that the original file will only be modified when you exit your editor ! 

## How to update MiniVim ?

First, you have to fetch the latest MiniVim. If you had cloned the repo, simply `git pull`. Else, re-download the lastest version on GitHub.

If you setup MiniVim automatically, simply re-run the installer. It will take care of everything.

If not, copy again the vimrc file to `~/.vimrc`

## Other info

The file is **heavily** commented. You're welcome to open, read and change what you want. *It's easy.*

- Work with Vim and GVim.
- Please keep in mind that some keys **cannot** be mapped as `Ctrl Shift Something` or `Ctrl Tab` because of Terminals limitations. I have to compose with this :confused: **If you're on Windows with Putty or similar, you may experience problems because of key codes.** [Look at this tip for PuTTY numeric keypad problems](http://vim.wikia.com/wiki/PuTTY_numeric_keypad_mappings) and [this one for other mappings that doesn't work](http://unix.stackexchange.com/questions/1709/how-to-fix-ctrl-arrows-in-vim).
- The color scheme is based on [https://github.com/sickill/vim-monokai](Monokai).
- Smart Paste system is based on [https://github.com/ConradIrwin/vim-bracketed-paste](ConradIrwin/vim-bracketed-paste).
- In the bottom right-hand corner, you have numbers `115/142(90%)-10`. Line `115`, total lines `142`, position at 90% in the file and column `10`.
- Tabulations will be expanded into two spaces, the default indent size.
- UTF-8 by default.
- Backups and Swapfiles are stored in `$HOME/.vim/`.
- Pressing Enter, Space or Backspace in normal mode will enter insert mode and do action.
- When re-opening a file, Vim will remember the last position.
- When opening multiple file (as `vim file1 file2`), Vim will open those files in new tabs automatically.

## Changelog

### 1.3.3

- Smart paste
- The default mode is "Normal"

### 1.3.2

- Configuration is kept in .vimrc to persist between updates
- Better README

### 1.3.1

- New clean install with the [automated setup](#automated-setup)
- Small fixes

### 1.3

- Custom save function
- Complete words containing a dash
- Replace on the line
- Better cursor position after duplicating a block
- Added percentage in statusline
- Added the 'Remove Trailing Spaces' function
- Small fixes and typos fixed

### 1.2

- Fix the visual block mode
- Fix the incremental search
- Install.sh is now POSIX
- Fixed typos

### 1.1

- Better code organisation
- Toggle custom key bindings easily
- Toggle 80th column char
- Open file browser in new tab only if tab is empty
- Fix typos

### 1.0

Initial release.
