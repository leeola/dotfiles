" # Vim's Rust Language Settings
"
" This file contains settings specific to the given language, and is
" automatically loaded based on the filetype. Automatic loading is enabled in
" the main init.vim, with the setting `filetype plugin on`

" ## Plugin Settings
" ### rust-vim
" Enable running rustfmt when the file is saved.
let g:rustfmt_autosave = 1

" This changes the completion popup to show function signatures as well.
let g:racer_experimental_completer = 1

" ### vim-racer config

" I'm not a fan of the default racer mappings (seen below) so by setting this
" we can disable them entirely, and define our own.
"
" Default bindings can be found at:
" https://github.com/racer-rust/vim-racer/blob/master/plugin/racer.vim#L302
let g:racer_no_default_keymappings = 1

" In normal mode, map Leader key combinations to vim-racer plugin methods.
nmap <buffer> <Leader>gg <Plug>RacerGoToDefinitionDrect
nmap <buffer> <Leader>gs <Plug>RacerGoToDefinitionSplit
nmap <buffer> <Leader>gv <Plug>RacerGoToDefinitionVSplit
nmap <buffer> <Leader>kk <Plug>RacerShowDocumentation

" this seems a bit crazy, but for some reason system() is returning a newline
" to the output of the system call. I cannot find any sanity in this.. but it
" is what it is. To deal with it i'm simply subbing any trailig newlines for
" nothing, and then appending the libsrc.
"
" Note that this requires rustup, and the rust-src component, which can be
" added with:
"
"   rustup component add rust-src
let $RUST_SRC_PATH=substitute(system('rustc --print sysroot'), '\(.\+\)\n', '\1', '')
let $RUST_SRC_PATH.='/lib/rustlib/src/rust/src'

" Because i'm using neomake and cargo for my error detection, i don't want
" rustfmt to tell me if it ran into an error. The UI (provided by rust.vim) is
" distracting, similar to Syntastic. So i'm ignoring all rustfmt errors.
"
" .. for the sake of documentation, i find that window distracting because it
" pops up in the buffer, and often opening up many times. Meaning that
" navigating around to fix the problem can open up many of these error
" windows, quite the PITA.
let g:rustfmt_fail_silently=1

" create our actual neomake maker for cargo. Note that neomake ships with a
" default maker, but it is not using the new error format which resides in
" nightly.
"
" I'm using an explicit 'cargo' exe name incase i want to change the maker
" name without affecting the binary. `append_file` is used because neomake
" will automatically append the file path to the end of the full command,
" which causes cargo to fail. Finally, the errorformat was pulled from
" a rust.vim PR[1] attempting to fix the problem that causes me to add
" this whole neomake maker. Thanks to them!!
"
" [1]: https://github.com/rust-lang/rust.vim/pull/99#issuecomment-244954595
let g:neomake_rust_cargo_maker = {
    \ 'exe': 'cargo',
    \ 'args': ['build'],
    \ 'append_file': 0,
    \ 'errorformat': '%Eerror%m,%Z\ %#-->\ %f:%l:%c',
  \ }

" Replace the default makers list with our new maker, ensuring our cargo maker
" and not the default maker is what is run when we save.
let g:neomake_rust_enabled_makers = ['cargo']

augroup neomake
  " Clear autocmds for this augroup when sourcing this file, so repeated
  " sources don't cause problems.
  autocmd!
  " Automatically run this maker when we save .rs files.
  autocmd BufWritePost *.rs Neomake cargo
augroup END
