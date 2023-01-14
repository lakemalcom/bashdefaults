syntax on
set expandtab
set tabstop=4
set nocompatible
set autoindent
set smartindent
set pastetoggle=<F2>
set autowriteall
set vb
set directory=/tmp
set hlsearch
set scrolloff=5 " Keep 5 lines below and above the cursor
set backspace=indent,eol,start
set cmdheight=2

colorscheme ir_black

filetype plugin on
filetype indent on
hi CursorLine guibg=#222222 cterm=NONE ctermbg=darkgrey
nnoremap <F3> :set cursorline!<CR>

set ts=4
set sw=4
"call pathogen#runtime_append_all_bundles()
map <C-t> :FufFile<CR>


" vmap <C-c><C-c> "ry :call Send_to_Screen(@r)<CR>
vmap <C-c><C-c> "ry :call chimp#SendToCurrent(@r)<CR>
nmap <C-c><C-c> vip<C-c><C-c>
nmap <C-c>v :call chimp#ResetChimp()<CR>

let maplocalleader = ","

"-----------------------------------------------------------------------------
"" SnipMate Settings
"-----------------------------------------------------------------------------
"source ~/.vim/snippets/support_functions.vim
"let g:snips_author = 'Luke McCollum'

"-----------------------------------------------------------------------------
"" FuzzyFinder Settings
"-----------------------------------------------------------------------------
nmap ,fb :FufBuffer<CR>
nmap ,ff :FufFile<CR>
nmap ,ft :FufTag<CR>

"-----------------------------------------------------------------------------
" Fix constant spelling mistakes
"-----------------------------------------------------------------------------

iab teh       the
iab Teh       The
iab taht      that
iab Taht      That
iab alos      also
iab Alos      Also
iab aslo      also
iab Aslo      Also
iab becuase   because
iab Becuase   Because
iab bianry    binary
iab Bianry    Binary
iab bianries  binaries
iab Bianries  Binaries
iab charcter  character
iab Charcter  Character
iab charcters characters
iab Charcters Characters
iab exmaple   example
iab Exmaple   Example
iab exmaples  examples
iab Exmaples  Examples
iab shoudl    should
iab Shoudl    Should
iab seperate  separate
iab Seperate  Separate
iab fone      phone
iab Fone      Phone

"-----------------------------------------------------------------------------
" NERD Tree Plugin Settings
"-----------------------------------------------------------------------------
" Toggle the NERD Tree on an off with F7
nmap <F7> :NERDTreeTabsToggle<CR>

" Close the NERD Tree with Shift-F7
nmap <S-F7> :NERDTreeClose<CR>

" Store the bookmarks file in perforce
let NERDTreeBookmarksFile="~/.vim/NERDTreeBookmarks"

" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1

" Don't display these kinds of files
let NERDTreeIgnore=[ '\.ncb$', '\.suo$', '\.vcproj\.RIMNET', '\.obj$',
            \ '\.ilk$', '^BuildLog.htm$', '\.pdb$', '\.idb$',
            \ '\.embed\.manifest$', '\.embed\.manifest.res$',
            \ '\.intermediate\.manifest$', '^mt.dep$', '\.class$' ]


" Tagbar toggle
nmap <F8> :TagbarToggle<CR>


" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Use the arrows to something usefull
map <right> :bn<cr>
map <left> :bp<cr>

" Fast exiting
map XX :qa!<cr>

" Delete a character in insert mode:
imap  [3~

"Move a line of text using ALT+[jk] or Comamnd+[jk] on mac
nmap <M-j> mz:m+<cr>`z
nmap <M-k> mz:m-2<cr>`z
vmap <M-j> :m'>+<cr>`<my`>mzgv`yo`z
vmap <M-k> :m'<-2<cr>`>my`<mzgv`yo`z

""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH

" The Silver Searcher
if executable('ag')
   " Use ag over grep
     set grepprg=ag\ --nogroup\ --nocolor

     " Use ag in CtrlP for listing files. Lightning fast and respects
     " .gitignore
     let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

     " ag is fast enough that CtrlP doesn't need to cache
     let g:ctrlp_use_caching = 0
endif


""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""
" Really useful!
"  In visual mode when you press * or # to search for the current selection
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>

" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSearch('gv')<CR>
map <leader>g :vimgrep // **/*<left><left><left><left><left><left>


map <F4> :execute "vimgrep /" . expand("<cword>") . "/j **" <Bar> cw<CR>

" From an idea by Michael Naumann
function! VisualSearch(direction) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", '\\/.*$^~[]')
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'b'
        execute "normal ?" . l:pattern . "^M"
    elseif a:direction == 'gv'
        call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
    elseif a:direction == 'f'
        execute "normal /" . l:pattern . "^M"
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

"""""""""""""""""""""""""""""""
" => Vimclojure
"""""""""""""""""""""""""""""""
"let vimclojure#NailgunClient = "/Users/luke_mccollum/vimclojure-2.1.2/ngclient/ng"
"let clj_want_gorilla = 1
"let g:clj_highlight_builtins=1      " Highlight Clojure's builtins
"let g:clj_paren_rainbow=1           " Rainbow parentheses'!

" Here's the vimclojure stuff. You'll need to adjust the NailgunClient
" setting if you're on windows or have other problems.
let vimclojure#FuzzyIndent=1
let vimclojure#HighlightBuiltins=1
let vimclojure#HighlightContrib=1
let vimclojure#DynamicHighlighting=1
let vimclojure#ParenRainbow=1
let vimclojure#WantNailgun = 1
let vimclojure#NailgunClient = $HOME . "/.vim/lib/vimclojure-nailgun-client/ng"
let vimclojure#SplitPos = "bottom"

function! ToggleVerbose()
    if !&verbose
        set verbosefile=~/.log/vim/verbose.log
        set verbose=15
    else
        set verbose=0
        set verbosefile=
    endif
endfunction

au BufRead,BufNewFile *.as set filetype=actionscript

" DBExt stuff
let g:dbext_default_profile_mysql_local_DBI_aac = 'type=DBI:user=root:passwd=:driver=mysql:conn_parms=database=aac;host=localhost'
let g:dbext_default_profile_mysql_local_DBI_aac2 = 'type=DBI:user=root:passwd=:driver=mysql:conn_parms=database=aac2;host=localhost'
let g:dbext_default_DBI_max_rows=0

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

let g:EclimCompletionMethod = 'omnifunc'

let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'objc' : ['->', '.'],
  \   'ocaml' : ['.', '#'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'cs,java,javascript,d,vim,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'ruby' : ['.', '::'],
  \   'lua' : ['.', ':'],
  \   'erlang' : [':'],
  \ }
