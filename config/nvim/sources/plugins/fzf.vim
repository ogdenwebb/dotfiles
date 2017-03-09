" FZF:
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
let g:fzf_layout = { 'down': '~20%' }

" nnoremap <silent> <C-p> :FZF -m<CR>
nnoremap <silent> <Leader>p :FZF -m<CR>
nnoremap <silent> <Leader>f :History<CR>
nnoremap <silent> <Leader>k :Ag<CR>
nnoremap <silent> <Leader>o :Buffers<CR>
nnoremap <silent> <Leader>s :Sessions<CR>
nnoremap <silent> <Leader>. :BTags<CR>

" }}}
