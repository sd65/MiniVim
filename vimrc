""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Details on : https://github.com/sd65/MiniVim
let MiniVimVersion = 1.0
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""" General options
start " Start in Insertion mode
syntax enable " Enable syntax highlights
set ttyfast " Faster refraw
set mouse=nv " Mouse activated in Normal and Visual Mode
set shortmess+=I " No intro when starting Vim
set smartindent " Smart... indent
set expandtab " Insert spaces instead of tabs
set softtabstop=2 " ... and insert two spaces
set shiftwidth=2 " Indent with two spaces
set incsearch " Search as typing
set hlsearch " Highlight search results
set cursorline " Highligt the cursor line
set showmatch " When a bracket is inserted, briefly jump to the matching one
set matchtime=3 " ... during this time
set virtualedit=onemore " Allow the cursor to move just past the end of the line
set history=100 " Keep 100 undo
set wildmenu " Better command-line completion
set scrolloff=10 " Always keep 10 lines after or before when scrolling
set sidescrolloff=5 " Always keep 5 lines after or before when side scrolling
set noshowmode " Don't display the current mode
set gdefault " The substitute flag g is on
set hidden " Hide the buffer instead of closing when switching
set backspace=indent,eol,start " The normal behaviour of backspace
set showtabline=2 " Always show tabs
set laststatus=2 " Always show status bar
set number " Show the line number
set updatetime=1000
set ignorecase " Search insensitive
set smartcase " ... but smart
set showbreak=↪ " See this char when wrapping text
set encoding=utf-8  " The encoding displayed.
set fileencoding=utf-8  " The encoding written to file.
set synmaxcol=300 " Don't try to highlight long lines
set guioptions-=T " Don't show toolbar in Gvim
" Open all cmd args in new tabs
execute ":silent :tab all" 

""" Colors and Statusline
let defaultAccentColor=161
let colorsAndModes= {
  \ 'i' : 39,
  \ 'v' : 82,
\}
let defaultAccentColorGui='#d7005f'
let colorsAndModesGui= {
  \ 'i' : '#00afff',
  \ 'v' : '#5fff00',
\}
function! ChangeAccentColor()
  let accentColor=get(g:colorsAndModes, mode(), g:defaultAccentColor)
  let accentColorGui=get(g:colorsAndModesGui, mode(), g:defaultAccentColorGui)
  execute 'hi User1 ctermfg=0 guifg=#000000 ctermbg=' . accentColor . ' guibg=' . accentColorGui
  execute 'hi User2 ctermbg=0 guibg=#2e3436 ctermfg=' . accentColor . ' guifg=' . accentColorGui
  execute 'hi User3 ctermfg=0 guifg=#000000 cterm=bold gui=bold ctermbg=' . accentColor . ' guibg=' . accentColorGui
  execute 'hi TabLineSel ctermfg=0 cterm=bold ctermbg=' . accentColor
  execute 'hi TabLine ctermbg=0 ctermfg=' . accentColor
  execute 'hi CursorLineNr ctermfg=' . accentColor . ' guifg=' . accentColorGui
  return ''
endfunction
function! ReadOnly()
  return (&readonly || !&modifiable) ? 'Read Only ' : ''
endfunction
function! Modified()
  return (&modified) ? 'Modified' : 'Not modified'
endfunction
let g:currentmode={
    \ 'n'  : 'Normal',
    \ 'no' : 'N·Operator Pending',
    \ 'v'  : 'Visual',
    \ 'V'  : 'V·Line',
    \ '^V' : 'V·Block',
    \ 's'  : 'Select',
    \ 'S'  : 'S·Line',
    \ '^S' : 'S·Block',
    \ 'i'  : 'Insert',
    \ 'R'  : 'Replace',
    \ 'Rv' : 'VReplace',
    \ 'c'  : 'Command',
    \ 'cv' : 'Vim Ex',
    \ 'ce' : 'Ex',
    \ 'r'  : 'Prompt',
    \ 'rm' : 'More',
    \ 'r?' : 'Confirm',
    \ '!'  : 'Shell',
    \ 't'  : 'Terminal',
\}
set statusline=
set statusline+=%{ChangeAccentColor()}
set statusline+=%1*\ ***%{toupper(g:currentmode[mode()])}***\  " Current mode
set statusline+=%2*\ %<%F\  " Filepath
set statusline+=%2*\ %= " To the right
set statusline+=%2*\ %{toupper((&fenc!=''?&fenc:&enc))}\[%{&ff}] " Encoding & Fileformat
set statusline+=%2*\ %{Modified()}\ %{ReadOnly()} " Flags
set statusline+=%1*\ \%l/%L-%c\  " Position
" Speed up the redraw
au InsertLeave * call ChangeAccentColor()
au CursorHold * let &ro = &ro

""" Prevent lag when hitting escape
set ttimeoutlen=0
set timeoutlen=1000 
au InsertEnter * set timeout
au InsertLeave * set notimeout

""" Reopen at last position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

""" Custom backup and swap files
let myVimDir = expand("$HOME/.vim")
let myBackupDir = myVimDir . '/backup'
let mySwapDir = myVimDir . '/swap'
function! EnsureDirExists (dir)
  if !isdirectory(a:dir)
    call mkdir(a:dir,'p')
  endif
endfunction
call EnsureDirExists(myVimDir)
call EnsureDirExists(myBackupDir)
call EnsureDirExists(mySwapDir)
set backup
set backupskip=/tmp/*
set backupext=.bak
let &directory = mySwapDir
let &backupdir = myBackupDir
set writebackup

""" Helper functions
function! CreateShortcut(keys, cmd, where, ...)
  let keys = "<" . a:keys . ">"
  if a:where =~ "i"
    let i = (index(a:000,"noTrailingIInInsert") > -1) ? "" : "i"
    let e = (index(a:000,"noLeadingEscInInsert") > -1) ? "" : "<esc>"
    execute "imap " . keys . " " . e .  a:cmd . i
  endif
  if a:where =~ "n"
    execute "nmap " . keys . " " . a:cmd
  endif    
  if a:where =~ "v"
    let k = (index(a:000,"restoreSelectionAfter") > -1) ? "gv" : ""
    let c = a:cmd
    if index(a:000,"cmdInVisual") > -1
      let c = ":<C-u>" . strpart(a:cmd,1)
    endif
    execute "vmap " . keys . " " . c . k
  endif
endfunction
function! TabIsEmpty()
    return winnr('$') == 1 && len(expand('%')) == 0 && line2byte(line('$') + 1) <= 2
endfunction
function! MyQuit()
  if TabIsEmpty() == 1
    q!
  else
    if &modified
      if (confirm("YOU HAVE UNSAVED CHANGES! Wanna quit anyway?", "&Yes\n&No", 2)==1)
        q!
      endif
    else
      q
    endif
  endif
endfunction
function! OpenLastBufferInNewTab()
    redir => ls_output
    silent exec 'ls'
    redir END
    let ListBuffers = reverse(split(ls_output, "\n"))
    for line in ListBuffers
      let title = split(line, "\"")[1]
      if title !~  "\[No Name"
        execute "tabnew +" . split(line, " ")[0] . "buf" 
        break
      endif       
    endfor  
endfunction

""" Key mappings

" Usefull shortcuts to inter insert mode
nnoremap <Enter> i<Enter>
nnoremap <Backspace> i<Backspace>
nnoremap <Space> i<Space>

" Ctrl A - Begin Line
call CreateShortcut("C-a", "0", "inv")

" Ctrl E - End Line
call CreateShortcut("C-e", "$<right>", "inv")

" Ctrl S - Save
call CreateShortcut("C-s", ":w<enter>", "nv", "cmdInVisual", "restoreSelectionAfter")
call CreateShortcut("C-s", ":w<enter>i<right>", "i", "noTrailingIInInsert")

" Home - Go To Begin
call CreateShortcut("Home", "gg", "inv")

" End - Go To End
call CreateShortcut("End", "G", "inv")

" Ctrl K - Delete Line
call CreateShortcut("C-k", "dd", "in")
call CreateShortcut("C-k", "d", "v")

" Ctrl Q - Duplicate Line
call CreateShortcut("C-q", "mjyyp`jjl", "i")
call CreateShortcut("C-q", "mjyyp`jj", "n")
call CreateShortcut("C-q", "yP", "v")

" Ctrl Down - Pagedown
call CreateShortcut("C-Down", "20j", "inv")

" Ctrl Up - Pageup
call CreateShortcut("C-Up", "20k", "inv")

" Ctrl Right - Next Word
call CreateShortcut("C-Right", "w", "nv")

" Ctrl Left - Previous Word
call CreateShortcut("C-Left", "b", "nv")

" Ctrl F - Find
call CreateShortcut("C-f", ":/", "in", "noTrailingIInInsert")

" Ctrl H - Search and Replace
call CreateShortcut("C-h", ":%s/", "in", "noTrailingIInInsert")

" Ctrl L - Delete all lines
call CreateShortcut("C-l", "ggdG", "in")

" Pageup - Move up Line
call CreateShortcut("PageUp", ":m-2<enter>", "in")
call CreateShortcut("PageUp", "dkP", "v")

" Pagedown - Move down Line
call CreateShortcut("PageDown", ":m+<enter>", "in")
call CreateShortcut("PageDown", "dp", "v")

" Ctrl C - Quit
call CreateShortcut("C-c", ":call MyQuit()<enter>", "inv", "cmdInVisual")

" Tab - Indent
call CreateShortcut("Tab", ">>", "n")
call CreateShortcut("Tab", ">", "v", "restoreSelectionAfter")

" Shift Tab - UnIndent
call CreateShortcut("S-Tab", "<<", "in")
call CreateShortcut("S-Tab", "<", "v", "restoreSelectionAfter")

" Ctrl Z - Undo
call CreateShortcut("C-z", "u", "in")

" Ctrl R - Redo
call CreateShortcut("C-r", "<C-r>", "in")

" Ctrl D - Suppr (the key)
call CreateShortcut("C-d", "<del>", "iv", "noLeadingEscInInsert", "noTrailingIInInsert")
call CreateShortcut("C-d", "x", "n")

" Ctrl T - New tab
call CreateShortcut("C-t", ":tabnew<enter>i", "inv", "noTrailingIInInsert", "cmdInVisual")


" Alt Right - Next tab
call CreateShortcut("A-Right", "gt", "inv")

" Alt Left - Previous tab
call CreateShortcut("A-Left", "gT", "inv")

" F2 - Paste toggle
function! MyPasteToggle()
  set invpaste
  echo "Paste" (&paste) ? "On" : "Off"
endfunction
call CreateShortcut("f2",":call MyPasteToggle()<Enter>", "n")

" F3 - Line numbers toggle
call CreateShortcut("f3",":set nonumber!<Enter>", "in")

" F4 - Panic Button
call CreateShortcut("f4","mzggg?G`z", "inv")

" Ctrl O - Netrw (:Explore)
call CreateShortcut("C-o",":Texplore<Enter>", "inv", "noTrailingIInInsert")
let g:netrw_banner=0 " Hide banner
let g:netrw_list_hide='\(^\|\s\s\)\zs\.\S\+' " Hide hidden files
autocmd filetype netrw call KeysInNetrw()
function! KeysInNetrw()
  " Right to enter
  nmap <buffer> <Right> <Enter>
  " Left to go up
  nmap <buffer> <Left> -
  " l - Display info
  nmap <buffer> l qf
  " N - Menu
  nmap <buffer> n :call MenuNetrw()<Enter>
endfunction
function! MenuNetrw()
  let c = input("What to you want to do? (M)ake a dir, Make a (F)ile, (R)ename, (D)elete : ")
  if (c == "m" || c == "M")
    normal d
  elseif (c == "f" || c == "F")
    normal %
  elseif (c == "r" || c == "R")
    normal R
  elseif (c == "d" || c == "D")
    normal D
  endif
endfunction


""" Custom commands

" :W - To write with root rights
command W :execute ':silent w !sudo tee % > /dev/null' | :edit!

" :UndoCloseTab - To undo close tab
command UndoCloseTab call OpenLastBufferInNewTab()

"""" Color Scheme

"" Placed here for convenience.
"" Copied from sickill Monokai on Github,
"" and slightly modified.

set background=dark
highlight clear
syntax reset
set t_Co=256
hi Cursor ctermfg=235 ctermbg=231 cterm=NONE guifg=#272822 guibg=#f8f8f0 gui=NONE
hi Visual ctermfg=NONE ctermbg=59 cterm=NONE guifg=NONE guibg=#49483e gui=NONE
hi CursorLine ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#3c3d37 gui=NONE
hi CursorColumn ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#3c3d37 gui=NONE
hi ColorColumn ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#3c3d37 gui=NONE
hi LineNr ctermfg=102 ctermbg=237 cterm=NONE guifg=#90908a guibg=#3c3d37 gui=NONE
hi VertSplit ctermfg=241 ctermbg=241 cterm=NONE guifg=#64645e guibg=#64645e gui=NONE
hi MatchParen ctermfg=197 ctermbg=NONE cterm=underline guifg=#f92672 guibg=NONE gui=underline
hi StatusLine ctermfg=231 ctermbg=241 cterm=bold guifg=#f8f8f2 guibg=#64645e gui=bold
hi StatusLineNC ctermfg=231 ctermbg=241 cterm=NONE guifg=#f8f8f2 guibg=#64645e gui=NONE
hi Pmenu ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi PmenuSel ctermfg=NONE ctermbg=59 cterm=NONE guifg=NONE guibg=#49483e gui=NONE
hi IncSearch ctermfg=235 ctermbg=186 cterm=NONE guifg=#272822 guibg=#e6db74 gui=NONE
hi Search ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi Directory ctermfg=161 ctermbg=NONE cterm=NONE guifg=#d7005f guibg=NONE gui=NONE
hi Folded ctermfg=242 ctermbg=235 cterm=NONE guifg=#75715e guibg=#272822 gui=NONE
hi SignColumn ctermfg=NONE ctermbg=237 cterm=NONE guifg=NONE guibg=#3c3d37 gui=NONE
hi Normal ctermfg=231 ctermbg=235 cterm=NONE guifg=#f8f8f2 guibg=#272822 gui=NONE
hi Boolean ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
hi Character ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
hi Comment ctermfg=242 ctermbg=NONE cterm=NONE guifg=#75715e guibg=NONE gui=NONE
hi Conditional ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
hi Constant ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi Define ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
hi DiffAdd ctermfg=231 ctermbg=64 cterm=bold guifg=#f8f8f2 guibg=#46830c gui=bold
hi DiffDelete ctermfg=88 ctermbg=NONE cterm=NONE guifg=#8b0807 guibg=NONE gui=NONE
hi DiffChange ctermfg=NONE ctermbg=NONE cterm=NONE guifg=#f8f8f2 guibg=#243955 gui=NONE
hi DiffText ctermfg=231 ctermbg=24 cterm=bold guifg=#f8f8f2 guibg=#204a87 gui=bold
hi ErrorMsg ctermfg=231 ctermbg=197 cterm=NONE guifg=#f8f8f0 guibg=#f92672 gui=NONE
hi WarningMsg ctermfg=231 ctermbg=197 cterm=NONE guifg=#f8f8f0 guibg=#f92672 gui=NONE
hi Float ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
hi Function ctermfg=148 ctermbg=NONE cterm=NONE guifg=#a6e22e guibg=NONE gui=NONE
hi Identifier ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=italic
hi Keyword ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
hi Label ctermfg=186 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
hi NonText ctermfg=59 ctermbg=236 cterm=NONE guifg=#49483e guibg=#31322c gui=NONE
hi Number ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
hi Operator ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
hi PreProc ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
hi Special ctermfg=231 ctermbg=NONE cterm=NONE guifg=#f8f8f2 guibg=NONE gui=NONE
hi SpecialKey ctermfg=59 ctermbg=237 cterm=NONE guifg=#49483e guibg=#3c3d37 gui=NONE
hi Statement ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
hi StorageClass ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=italic
hi String ctermfg=186 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
hi Tag ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
hi Title ctermfg=231 ctermbg=NONE cterm=bold guifg=#f8f8f2 guibg=NONE gui=bold
hi Todo ctermfg=95 ctermbg=NONE cterm=inverse,bold guifg=#75715e guibg=NONE gui=inverse,bold
hi Type ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
hi Underlined ctermfg=NONE ctermbg=NONE cterm=underline guifg=NONE guibg=NONE gui=underline
hi rubyClass ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
hi rubyFunction ctermfg=148 ctermbg=NONE cterm=NONE guifg=#a6e22e guibg=NONE gui=NONE
hi rubyInterpolationDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubySymbol ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
hi rubyConstant ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=italic
hi rubyStringDelimiter ctermfg=186 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
hi rubyBlockParameter ctermfg=208 ctermbg=NONE cterm=NONE guifg=#fd971f guibg=NONE gui=italic
hi rubyInstanceVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyInclude ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
hi rubyGlobalVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRegexp ctermfg=186 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
hi rubyRegexpDelimiter ctermfg=186 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
hi rubyEscape ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
hi rubyControl ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
hi rubyClassVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyOperator ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
hi rubyException ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
hi rubyPseudoVariable ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi rubyRailsUserClass ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=italic
hi rubyRailsARAssociationMethod ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
hi rubyRailsARMethod ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
hi rubyRailsRenderMethod ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
hi rubyRailsMethod ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
hi erubyDelimiter ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi erubyComment ctermfg=95 ctermbg=NONE cterm=NONE guifg=#75715e guibg=NONE gui=NONE
hi erubyRailsMethod ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
hi htmlTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlEndTag ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlTagName ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlArg ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi htmlSpecialChar ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
hi javaScriptFunction ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=italic
hi javaScriptRailsFunction ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
hi javaScriptBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlKey ctermfg=197 ctermbg=NONE cterm=NONE guifg=#f92672 guibg=NONE gui=NONE
hi yamlAnchor ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlAlias ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi yamlDocumentHeader ctermfg=186 ctermbg=NONE cterm=NONE guifg=#e6db74 guibg=NONE gui=NONE
hi cssURL ctermfg=208 ctermbg=NONE cterm=NONE guifg=#fd971f guibg=NONE gui=italic
hi cssFunctionName ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
hi cssColor ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
hi cssPseudoClassId ctermfg=148 ctermbg=NONE cterm=NONE guifg=#a6e22e guibg=NONE gui=NONE
hi cssClassName ctermfg=148 ctermbg=NONE cterm=NONE guifg=#a6e22e guibg=NONE gui=NONE
hi cssValueLength ctermfg=141 ctermbg=NONE cterm=NONE guifg=#ae81ff guibg=NONE gui=NONE
hi cssCommonAttr ctermfg=81 ctermbg=NONE cterm=NONE guifg=#66d9ef guibg=NONE gui=NONE
hi cssBraces ctermfg=NONE ctermbg=NONE cterm=NONE guifg=NONE guibg=NONE gui=NONE
hi TabLineFill cterm=bold ctermbg=0
