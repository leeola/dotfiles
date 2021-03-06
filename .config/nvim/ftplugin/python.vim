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
  "autocmd BufWritePost *.py Neomake python
augroup END

" Go to the definition, or the assignment if it's a module, if possible.
" See :help jedi-vim for further details.
let g:jedi#goto_command = "<Leader>gg"
" Go to the assignment of a variable if possible.
let g:jedi#goto_assignments_command = "<Leader>ga"
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

" ### Neomake
let g:neomake_python_yapf_maker = {
    \ 'args': ['--in-place'],
  \ }

" Adding this causes neomake to check the 'python' maker below with python3
" instead of python2.
"
" The cause for this was using a specific python3 syntax (`nonlocal foo`) and
" having the python maker say it was in error.
"
" This also has a downside that python2 will now show errors.. but i'm mainly
" working in python3 these days.
"
" Related threads:
"   https://github.com/neomake/neomake/issues/473
"   https://github.com/neomake/neomake/issues/449
let g:neomake_python_python_exe = 'python3'

" Replace the default makers list with our new maker, ensuring our cargo maker
" and not the default maker is what is run when we save.
let g:neomake_python_enabled_makers = ['python', 'yapf']

" Call neomake#Make directly instead of the Neomake provided command so we can
" inject the callback
augroup python_filetype
  autocmd!
  autocmd BufWritePost *.py call neomake#Make(1, [], function('ft#python#neomake_callback_yapf'))
augroup END
