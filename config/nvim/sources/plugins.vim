" Dein: {{{
call dein#add('Shougo/dein.vim')
call dein#add('haya14busa/dein-command.vim')
" }}}

" Appearance: {{{
" call dein#add('hallzy/lightline-iceberg')
call dein#add('gavocanov/vim-paramount-lightline')
call dein#local('$VIM_PATH/local/')
call dein#add('itchyny/lightline.vim', {
    \ 'hook_add': 'source ' . $SOURCE_PATH . '/plugins/lightline.vim',
    \ })

call dein#add('flazz/vim-colorschemes')
" call dein#add('tstelzer/welpe.vim')
call dein#add('AlessandroYorba/Sierra')
call dein#add('AlessandroYorba/Sidonia')
call dein#add('jacoborus/tender.vim')
call dein#add('trevordmiller/nova-vim')
" call dein#add('owickstrom/vim-colors-paramount')
"
call dein#add('Yggdroot/indentLine')
" }}}

" Behavior: {{{
" call dein#add('bgrohman/vim-bg-sessions')
" call dein#add('airblade/vim-rooter')

call dein#add('mbbill/undotree', {
    \ 'on_cmd' :  'UndotreeToggle',
    \ 'hook_add' : 'nmap <F2> :UndotreeToggle<CR>' })

call dein#add('majutsushi/tagbar', {
    \ 'on_cmd' : 'TagbarToggle',
    \ 'hook_add' : 'nmap <F4> :TagbarToggle<CR>' })

call dein#add('tpope/vim-commentary', {
      \ 'hook_add' : join(
      \ [ 'autocmd FileType vim set commentstring=\"%s',
      \ 'autocmd FileType ocaml set commentstring=\(*%s*)'], "\n")
      \ })

call dein#add('junegunn/vim-easy-align', {
    \ 'on_map' : { 'nx' : '<Plug>(EasyAlign)' },
    \ 'hook_add' : join(
        \ ['nmap ga <Plug>(EasyAlign)',
        \ 'xmap ga <Plug>(EasyAlign)'], "\n")
    \ })

call dein#add('cloudhead/neovim-fuzzy')

" call dein#add('junegunn/fzf', { 'build': './install', 'merged': 0})
" call dein#add('junegunn/fzf.vim', {
"    \ 'hook_add': 'source ' . $SOURCE_PATH . '/plugins/fzf.vim',
"    \ 'depends': 'junegunn/fzf',
"    \ })
" call dein#add('dominickng/fzf-session.vim', {
"       \ 'hook_add' : 'let g:fzf_session_path = "$HOME/.vim/sessions"'
"       \ })

call dein#add('machakann/vim-sandwich', {
    \ 'on_map': [
    \   [ 'o', 'ib', 'is'],
    \   [ 'n', 'sa', 'sr', 'sd' ],
    \   [ 'v', 'sa', 'sd', 'sr' ],
    \ ],
    \ })

call dein#add('ntpeters/vim-better-whitespace', {
      \ 'hook_add' : "let g:better_whitespace_filetypes_blacklist=['calendar']"
      \ })
call dein#add('tpope/vim-repeat')
call dein#add('luochen1990/rainbow', {
    \ 'hook_source' : 'let g:rainbow_active = 1' })

call dein#add('svermeulen/vim-easyclip')

" call dein#add('kassio/neoterm', {
"    \ 'hook_add': 'source ' . $SOURCE_PATH . '/plugins/neoterm.vim' })

" call dein#add('rking/ag.vim')
"
" call dein#add('machakann/vim-swap', {
"     \ 'on_map' : [ 'g<', 'g>', 'gs' ],
"     \ })
call dein#add('AndrewRadev/sideways.vim', {
      \ 'on_cmd' : [ 'SidewaysLeft', 'SidewaysRight' ] }) " Auto close parentheses and repeat by dot
call dein#add('cohama/lexima.vim')

" call dein#add('guns/vim-sexp', {
    " \ 'on_ft' : [ 'lisp', 'scheme', 'racket' ] })
" call dein#add('tpope/vim-sexp-mappings-for-regular-people', {
    " \ 'on_ft' : [ 'lisp', 'scheme', 'racket' ] })

" }}}

" Text Objects: {{{
" Motion And Navigation:
call dein#add('junegunn/vim-pseudocl')
call dein#add('junegunn/vim-oblique') " improving search

call dein#add('wellle/targets.vim', {
    \ 'on_map': [
    \   [ 'o', 'i', 'I', 'a', 'A' ],
    \   [ 'v', 'i', 'I', 'a', 'A' ],
    \ ],
    \ })

call dein#add('chaoren/vim-wordmotion', {
    \ 'on_map' : ['w', 'b', 'ge', 'aw', 'iw', 'W', 'B', 'E'] })

call dein#add('gregsexton/MatchTag', { 'on_ft' : [ 'html', 'xml' ]})
" call dein#add('jeetsukumaran/vim-indentwise')

call dein#add('haya14busa/vim-asterisk', {
    \ 'on_map' : { 'n' : '<Plug>' },
    \ 'hook_add' : join([
        \ 'map *  <Plug>(asterisk-z*)',
        \ 'map #  <Plug>(asterisk-z#)',
        \ 'map g* <Plug>(asterisk-gz*)',
        \ 'map g# <Plug>(asterisk-gz#)'], "\n")
    \ })
" }}}

" Applications: {{{
" call dein#add('arecarn/selection.vim')
" call dein#add('arecarn/crunch.vim', {
"     \ 'on_cmd' : 'Crunch',
"     \ 'on_map' : [
"     \   ['n', 'g=', 'g=='],
"     \   ['v', 'g='],
"     \ ],
"     \ 'depends' : 'selection.vim'
"     \ })
" call dein#add('itchyny/calendar.vim', { 'on_cmd' : 'Calendar' })

" call dein#add('nhooyr/neoman.vim', {
"    \ 'on_cmd' : [ 'Nman', 'Vman', 'Sman', 'Tman' ] })

call dein#add('t9md/vim-choosewin', {
    \ 'on_map' : { 'n' : '<Plug>(choosewin)' },
    \ 'hook_add' : join(
        \ ['nmap  -  <Plug>(choosewin)',
        \ 'let g:choosewin_overlay_enable = 1',
        \ ], "\n")})

" call dein#add('dhruvasagar/vim-open-url')
" call dein#add('waiting-for-dev/vim-www', {
"     \ 'hook_add' : 'let g:www_launch_browser_command = "firefox {{URL}} &"',
"     \ })
" " }}}

" Development: {{{
call dein#add('thinca/vim-quickrun', {
    \ 'on_cmd' : 'QuickRun',
    \ 'hook_add' : 'nnoremap <leader>r :QuickRun<CR>',
    \ })

" Filetypes:
call dein#add('PotatoesMaster/i3-vim-syntax', { 'on_ft' : 'i3' })
" call dein#add('plasticboy/vim-markdown', {
      " \ 'on_ft' : 'markdown',
      " \ 'hood_source' : 'autocmd FileType markdown setlocal nofoldenable' })
" call dein#add('suan/vim-instant-markdown', { 'on_ft' : 'markdown' })

" call dein#add('xolox/vim-misc', { 'on_ft' : 'lua' })
" call dein#add('xolox/vim-lua-ftplugin', {
"       \ 'on_ft' : 'lua',
"       \ 'depends' : 'vim-misc' })

" call dein#add('wlangstroth/vim-racket', {
"     \  'on_ft' : [ 'lisp', 'scheme', 'racket' ] })
" call dein#add('MicahElliott/vrod', { 'on_ft' : 'racket' })
"
call dein#add('baabelfish/nvim-nim', { 'on_ft' : 'nim' })
call dein#add('othree/html5.vim', { 'on_ft' : 'html' })
call dein#add('hail2u/vim-css3-syntax', { 'on_ft': [ 'html', 'css' ] })
    " \ 'on_ft' : [ 'html', 'css' ],
    " \ 'hook_source' : join(
    "     \ ['augroup VimCSS3Syntax',
    "     \    'autocmd!',
    "     \    'autocmd FileType css setlocal iskeyword+=-',
    "     \ 'augroup END'], "\n")
    " \ })
    "
" call dein#add('peterhoeg/vim-qml', { 'on_ft' : 'qml' })

" Lisp
call dein#add('neovim/node-host', { 'build': 'npm install' })
call dein#add('snoe/nvim-parinfer.js', {
    \ 'on_ft' : [ 'lisp', 'scheme', 'racket', 'clojure' ] })

" OCaml:
"call dein#add('rgrinberg/vim-ocaml', { 'on_ft': [ 'ocaml', 'omake', 'ocamlbuild', 'oasis', 'opam', 'ocamlbuild_tags' ] })
" call dein#add('def-lkb/ocp-indent-vim', { 'on_ft' : [ 'ocaml' ] })
" let s:merlindir = substitute(system('opam config var share'),'\n$','','''') . "/merlin"
"call dein#local(s:merlindir, { 'on_ft' : [ 'ocaml', 'merlin' ] })

call dein#add('vim-perl/vim-perl',
    \ { 'on_ft' : 'perl', 'build': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' })

" Haskell: {{{
" call dein#add('Shougo/vimproc.vim', {
"       \ 'build' : 'make',
"       \ 'on_ft' : 'haskell' })
" call dein#add('eagletmt/ghcmod-vim', {
"       \ 'on_ft' : 'haskell',
"       \ 'depends' : 'vimproc.vim' })
" WW_WARNING: 100% CPU and RAM load
" call dein#add('eagletmt/neco-ghc', { 'on_ft' : 'haskell' })
" if dein#tap('neco-ghc')
  " let g:haskellmode_completion_ghc = 0
  " autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc
" endif
call dein#add('neovimhaskell/haskell-vim', { 'on_ft' : 'haskell' })
" }}}
" }}}

" Completion: {{{
" call dein#add('Shougo/context_filetype.vim')
    " \ 'lazy' : 1,
" call dein#add('Shougo/deoplete.nvim', {
"     \ 'on_i': 1,
"     \ 'hook_source': 'let g:deoplete#enable_at_startup = 1'
"     \ .' | source ' . $SOURCE_PATH . '/plugins/deoplete.vim' })
" call dein#add('Shougo/neco-vim', { 'on_ft': 'vim' })
" call dein#add('Shougo/neco-syntax', {
"     \ 'on_source' : 'deoplete.nvim' })
call dein#add('othree/csscomplete.vim', {
    \ 'on_ft': 'css',
    \ 'hook_add' : 'autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci' })
call dein#add('c9s/perlomni.vim', { 'on_ft' : 'perl' })

" }}}
