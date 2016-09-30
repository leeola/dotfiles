" # Vim's Golang Language Settings
"
" This file contains settings specific to the given language, and is
" automatically loaded based on the filetype. Automatic loading is enabled in
" the main init.vim, with the setting `filetype plugin on`

" ## Plugin Settings

" ### vim-go
augroup filetype_go
  " Clear autocmds for this augroup when sourcing this file, so repeated
  " sources don't cause problems.
  autocmd!
  " Locate the current identifier
  autocmd FileType go nmap <Leader>dd <Plug>(go-def)
  autocmd FileType go nmap <Leader>ds <Plug>(go-def-split)
  autocmd FileType go nmap <Leader>dv <Plug>(go-def-vertical)
  autocmd FileType go nmap <Leader>dt <Plug>(go-def-tab)

  " Rename the current identifier
  autocmd FileType go nmap <Leader>r <Plug>(go-rename)

  " Info about the current identifier
  autocmd FileType go nmap <Leader>q <Plug>(go-info)

  " Open godoc for current identifier
  autocmd FileType go nmap <Leader>gd <Plug>(go-doc)
  autocmd FileType go nmap <Leader>gv <Plug>(go-doc-vertical)

  " Check what the current identifier implements
  autocmd FileType go nmap <Leader>s <Plug>(go-implements)
  autocmd FileType go nnoremap <silent> <leader>l :GoLint<cr>
  autocmd FileType go nnoremap <silent> <leader>e :GoImports<cr>
  autocmd FileType go nnoremap <silent> <leader>; :GoVet<cr>
augroup END
