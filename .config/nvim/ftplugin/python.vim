" # Vim's Python Language Settings
"
" This file contains settings specific to the given language, and is
" automatically loaded based on the filetype. Automatic loading is enabled in
" the main init.vim, with the setting `filetype plugin on`.

" ## Plugin Binds
augroup python_filetype
  " Clear autocmds for this augroup when sourcing this file, so repeated
  " sources don't cause problems.
  autocmd!
  " Automatically run this maker when we save python files.
  autocmd BufWritePost *.py Neomake python
augroup END

" Go to the definition, or the assignment if it's a module, if possible.
" See :help jedi-vim for further details.
let g:jedi#goto_command = "<Leader>dd"
" Go to the assignment of a variable if possible.
let g:jedi#goto_assignments_command = "<Leader>da"
" Because <Leader>dd goes to the definition with additional features, this is
" disabled. The empty value signifies disabled.
let g:jedi#goto_definitions_command = ""
" Go to the documentation for that command.
let g:jedi#documentation_command = "<Leader>k"
" Refactor the given command.
let g:jedi#rename_command = "<Leader>r"
" List the usages of the given command.
let g:jedi#usages_command = "<Leader>u"

" ## Plugin Settings
" ### jedi-vim
" jedi-vim will pop up a window detailing function arguments.
let g:jedi#show_call_signatures = 1
