" # Vim's Golang Language Settings
"
" This file contains settings specific to the given language, and is
" automatically loaded based on the filetype. Automatic loading is enabled in
" the main init.vim, with the setting `filetype plugin on`

" ## Plugin Settings
" ### vim-go
" Automatically import the needed packages.
let g:go_fmt_command = "goimports"

" ## Plugin Maps
" ### vim-go
" Locate the current identifier
nmap <Leader>gg <Plug>(go-def)
nmap <Leader>gs <Plug>(go-def-split)
nmap <Leader>gv <Plug>(go-def-vertical)

" Rename the current identifier
nmap <Leader>r <Plug>(go-rename)

" Info about the current identifier
nmap <Leader>i <Plug>(go-info)

" Open godoc for current identifier
nmap <Leader>k k <Plug>(go-doc)
nmap <Leader>k v <Plug>(go-doc-vertical)

" Check what the current identifier implements
nmap <Leader>s <Plug>(go-implements)
nnoremap <silent> <leader>l :GoLint<cr>
nnoremap <silent> <leader>e :GoImports<cr>
nnoremap <silent> <leader>; :GoVet<cr>
