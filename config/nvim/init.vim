" neovim config by 0rdy

" Env Settings:
let $VIM_PATH=expand('$HOME/.config/nvim')
let $DEIN_PATH=expand('$VIM_PATH/dein')
let $SOURCE_PATH=expand('$VIM_PATH/sources')
set runtimepath^=$VIM_PATH/dein/repos/github.com/Shougo/dein.vim
source $SOURCE_PATH/bindings.vim
"
" Dein:
if dein#load_state($DEIN_PATH)
  call dein#begin($DEIN_PATH, [expand('<sfile>'), expand('$SOURCE_PATH/plugins.vim')])
  source $SOURCE_PATH/plugins.vim

  call dein#end()
  call dein#save_state()

  if dein#check_install()
    call dein#install()
  endif
endif
call dein#call_hook('source')
" call dein#call_hook('post_source')

filetype plugin indent on
source $SOURCE_PATH/plugins/common.vim
source $SOURCE_PATH/settings.vim
source $SOURCE_PATH/filetype.vim
source $SOURCE_PATH/scripts.vim
source $SOURCE_PATH/terminal.vim

" TODO:
" Seems Good:
" 'osyo-manga/vim-watchdogs' " Async syntax checking.
" tweekmonster/django-plus.vim
" https://github.com/jpalardy/vim-slime
" https://github.com/jreybert/vimagit
" https://github.com/w0rp/ale

" (~ ^ . ^ ~)
