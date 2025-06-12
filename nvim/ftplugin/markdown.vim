" # Vim's Markdown Language Settings
"
" This file contains settings specific to the given language, and is
" automatically loaded based on the filetype. Automatic loading is enabled in
" the main init.vim, with the setting `filetype plugin on`

" ## Settings

augroup markdown_filetype
  " Clear autocmds for this augroup when sourcing this file, so repeated
  " sources don't cause problems.
  autocmd!
  " Set the auto-wrap at 80 characters for markdown.
  autocmd BufNewFile,BufRead *.md setlocal textwidth=73
  " Black magic from
  " http://vim.wikia.com/wiki/Automatic_formatting_of_paragraphs
  autocmd BufNewFile,BufRead *.md setlocal fo=aw2tq
augroup END

" ## Plugin Settings
