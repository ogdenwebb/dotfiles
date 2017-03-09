if dein#tap('indentLine')
  let g:indentLine_char = '┆'
  let g:indentLine_color_term = 239
  au InsertEnter * IndentLinesReset
endif

if dein#tap('ocp-indent-vim')
  autocmd FileType ocaml setlocal indentexpr=ocpindent#OcpIndentLine()
end

if dein#tap('haskell-vim')
  let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
  let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
  let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
  let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
  let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
  let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
endif

if dein#tap('sideways.vim')
  nnoremap g< :SidewaysLeft<CR>
  nnoremap g> :SidewaysRight<CR>
endif

if dein#tap('tagbar.vim')
  let g:tagbar_type_css = {
        \ 'ctagstype' : 'Css',
        \ 'kinds'     : [
        \ 'c:classes',
        \ 's:selectors',
        \ 'i:identities'
        \ ]
        \ }

  let g:tagbar_type_html = {
        \ 'ctagstype' : 'html',
        \ 'kinds'     : [
        \ 'c:classes',
        \ 'a:named anchors',
        \ 'f:js functions',
        \ 'i:ids'
        \ ]
        \ }
endif


" if dein#tap('vim-lua-ftplugin')
"   let g:lua_check_syntax = 0
"   let g:lua_complete_omni = 1
"   let g:lua_complete_dynamic = 0
"   let g:lua_define_completion_mappings = 0

"   let g:deoplete#omni#functions = {}
"   let g:deoplete#omni#functions.lua = 'xolox#lua#omnifunc'
"   "let g:deoplete#omni#functions.lua = 'xolox#lua#completefunc'
" endif
