" Options:
syn on
set completeopt=menuone,noinsert,noselect

set foldmethod=marker
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.jpg,*.png,*.gif,*.jpeg,*.pdf,*.mp3,*.flac,*.mkv,*.mp4,*.xcf
set grepprg=ag
set path+=**

set background=dark
" colorscheme spacegray
" colorscheme iceberg
" colorscheme welpe
" colorscheme tender
" set termguicolors
" set termguicolors
let g:sierra_Twilight = 1
colorscheme sierra
" colorscheme sidonia

set laststatus=2 " enable status line

set nu " set number
" syn on " enable highlighting syntax

set backup
set noswapfile
set backupdir=~/.vim/backup/
set directory=~/.vim/swp/

set undofile
set undodir=~/.vim/undodir

set hidden " allow buffer switching without saving
set noerrorbells " No beeps.
set nojoinspaces " Prevents inserting two spaces after punctuation on a join (J)

set expandtab    " Use spaces instead of tabs
set smarttab     " Be smart when using tabs
set shiftwidth=4 " 1 tab == 4 spaces
set tabstop=4

set wrap " text options
set linebreak

" Fix slow wrap
set textwidth=0
set wrapmargin=0

set autoindent
set hlsearch " Highlight search results.
set ignorecase " Make searching case insensitive
set smartcase " ... unless the query has capital letters.
set incsearch " Incremental search.

" More natural splits
set splitbelow          " Horizontal split below current.
set splitright          " Vertical split to right of current.

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif

" Clipboard
set clipboard=unnamedplus,unnamed


" Auto :set paste
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" Customization:
" Highlight Current Line
set cursorline
hi cursorline cterm=none term=none
autocmd WinEnter * setlocal cursorline
autocmd WinLeave * setlocal nocursorline
highlight CursorLine guibg=#303030 ctermbg=236

" http://dhruvasagar.com/2013/03/28/vim-better-foldtext
function! FoldText()
	let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
	let lines_count = v:foldend - v:foldstart + 1
	let lines_count_text = '|' . printf('%10s', lines_count . ' lines') . ' |'
	let foldchar = matchstr(&fillchars, 'fold:\zs.')
	let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
	let foldtextend = lines_count_text . repeat(foldchar, 8)
	let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
	return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction

highlight Folded      ctermfg=Black      ctermbg=2
highlight FoldColumn  ctermfg=241 ctermbg=255

set foldtext=FoldText()
" }}}

" Autocomplete
set complete=.,w,b,u,t,i
set omnifunc=syntaxcomplete#Complete


