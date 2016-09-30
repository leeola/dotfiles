" # Vim's Python Language Settings
"
" This file contains settings specific to the given language, and is
" automatically loaded based on the filetype. Automatic loading is enabled in
" the main init.vim, with the setting `filetype plugin on`

" ## Plugin Settings
"
augroup rust_filetype
  " Clear autocmds for this augroup when sourcing this file, so repeated
  " sources don't cause problems.
  autocmd!
  " Automatically run this maker when we save .rs files.
  autocmd BufWritePost *.rs Neomake python
augroup END
