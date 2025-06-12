" # Python Autoload Functions
" The following is a simple vimscript file which dynamically loads functions
" as needed (autoloading).

" Callback for reloading file in buffer when yapf has finished and maybe has
" autofixed some stuff
function! ft#python#neomake_callback_yapf(options)
  if (a:options.name ==? 'yapf') && (a:options.has_next == 0)
    edit
  endif
endfunction
