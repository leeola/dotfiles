"
" # leeo.la/dotfiles
"

" ## Pre-Plugin Setup
" First we setup some pre-plugin settings
"
" TODO(leeola): Write meaningful docstring for each line here.
let g:python_host_prog = '/usr/bin/python2.7'
set nocompatible
filetype off

" ## Plugin Setup
" Next we install our plugins. These are grouped by file type in most cases.
call plug#begin('~/.vim/plugged')

" ### Always Enabled
" CtrlP provides a convenient ui for opening files and buffers. A heavily used
" plugin.
"
" host: https://github.com/ctrlpvim/ctrlp.vim
Plug 'ctrlpvim/ctrlp.vim'

" An autocompletion plugin that is very fast and language agnostic.
Plug 'Valloric/YouCompleteMe', { 'do': './install.py' }

" vim-colors-solarized is my vim theme. Though, i'm seeking to change it up
" and try something different.
Plug 'altercation/vim-colors-solarized'
" Asynchronous building actions commonly used for linting and syntax checking
" for many languages. Quite useful, i even use a custom maker in Rust to
" handle the new (at this time) error format.
"
" host: https://github.com/neomake/neomake
Plug 'benekastah/neomake'

" ### Rust Language Only
" rust.vim is the official Rust language plugin for vim. I use it mainly for
" syntax highlighting _(i believe it offers syntax highlighting...?)_ and
" automatic rustfmt calling on file write.
"
" host: https://github.com/rust-lang/rust.vim
Plug 'rust-lang/rust.vim', {'for': 'rust'}

" vim-racer is a plugin which provides syntax checking and ...
"
" note sure if this provides syntax checking at all. Need to confirm that.
" host: https://gitlab.com/racer-rust/vim-racer
Plug 'racer-rust/vim-racer', {'for': 'rust'}


" ### The Cemetery
" The following is a series of plugins that have been removed due to
" inactivity but are quite useful nonetheless. Sometime soon they may be
" integrated back into the list properly.
"
" TODO(leeola): drop the ban hammer.
"
" " Automatic alignment of text
" Plug 'godlygeek/tabular'
" " Automatic closing tags
" Plug 'Raimondi/delimitMate'
" " Cool starting screen!
" " Bundle 'mhinz/vim-startify'
" " snipMate and it's requirements
" Plug 'MarcWeber/vim-addon-mw-utils' " Dep for snipmate
" Plug 'tomtom/tlib_vim'              " Dep for snipmate
" Plug 'garbas/vim-snipmate'
" Plug 'honza/vim-snippets'
" Plug 'fatih/vim-go'
" Plug 'tpope/vim-markdown'
" Plug 'dag/vim-fish'
" Plug 'scrooloose/syntastic'
" " Don't think i was using Ag at all directly.
" Plug 'rking/ag.vim'
call plug#end()


" ## Vim Theme Settings
syntax enable

" Tell Solarized to use the dark themes
set background=dark

" Set the theme to Solarized
colorscheme solarized



"
" ## Whitespace Matching
"
"highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()


" ## Vim Settings
set shell=sh                        " Set the default shell to sh, this
                                    " fixes my bash->fish in Vim.

" Enable automatic comment insertion
set formatoptions+=r
" Modeline Support
set modeline
set modelines=5

" Enables the autocomplete menu when you have some menus up like the `:e foo`
" menu.
set wildmenu

" Vim Searching will search as you type.
set incsearch

set laststatus=2                    " Show the Airline Line

" The following two options enable 'hybrid mode'
set number                          " Show line numbers
set relativenumber                  " Show Relative numbers

set ruler                           " Show cursor position

set backupdir-=.                    " Remove current dir from the list
set backupdir+=.                    " Append it to the list (so it's checked last)
set backupdir-=~                    " Remove home, if it's in there.. not sure it is?
set backupdir^=~/.config/nvim/tmp/bkp//     " Prepend the bkp dir. Not sure if // syntax
                                    " works with backups.
set backup                          " Turn backup on

set directory=~/.config/nvim/tmp/swp//   	  " Keep swap files in one location.
set directory+=.                    " Add the current directory as a fallback

set tabstop=2       				        " Global tab width
set shiftwidth=2			              " Something involving tab width.
set expandtab				                " Spaces instead of tabs

set backspace=2                     " From Wiki: Make backspace work like most
                                    " other apps. In practice, it lets me
                                    " backspace through newlines on osx.

set foldmethod=indent               " Magic
set foldlevel=20                    " Magic
set foldlevelstart=20               " Magic

" Disable the competion preview window. This is mainly
" apparent with YouCompleteMe, but overall i dislike it. So, i'm disabling
" it from ever showing up.
set completeopt-=preview

" Disable mouse interaction with vim.
"
" I find this setting endlessly annoying. I believe this is normally disabled
" by default in vim, but with neovim it was set as default true.
"
" Setting this to mouse= sets the value to empty, since mouse is not a toggle.
" It takes values like n, v, a, etc.
set mouse=

" Allow buffers to have unwritten changes when not in focus. This is very
" useful for plugins that go to a method definition in another file.
set hidden


"
" ## Autocmds
"

augroup markdown
  autocmd!
  " Set the auto-wrap at 80 characters for markdown.
  autocmd BufNewFile,BufRead *.md setlocal textwidth=73
  " Black magic from
  " http://vim.wikia.com/wiki/Automatic_formatting_of_paragraphs
  autocmd BufNewFile,BufRead *.md setlocal fo=aw2tq
augroup END


"
" ## Plugin Settings
"

" TODO(leeola): prune or document
" " Jump to error after saving
" " Disabled currently. Not sure i want that.
" " let g:syntastic_auto_jump=1
" " Open error list after saving
" let g:syntastic_auto_loc_list=1
" " The line height of the error list
" let g:syntastic_loc_list_height=5

" ### CtrlP Settings
let g:ctrlp_root_markers = ['.ctrlp', '.git']
let g:ctrlp_user_command = 'ag %s -l --nocolor --skip-vcs-ignores --hidden -g ""'
let g:ctrlp_extensions = ['line']
let g:ctrlp_prompt_mappings = {
  \ 'PrtHistory(-1)': ['<c-up>'],
  \ 'PrtHistory(1)':  ['<c-down>'],
  \ 'ToggleType(1)':  ['<c-p>'],
  \ 'ToggleType(-1)': ['<c-l>'],
  \ 'PrtCurRight()':  ['<right>']
  \ }


" TODO(leeola): prune or document
" ### Markdown Plugin
" Syntax highlighting for given languages
" let g:markdown_fenced_languages = [
"       \ 'coffee', 'css', 'erb=eruby', 'javascript',
"       \ 'js=javascript', 'json=javascript', 'ruby', 'sass', 'xml'
"       \ ]
"
" DEPRECATED:
" These are commented out because i added the Markdown plugin, which should
" take care of this.
"autocmd BufNewFile,BufRead *.md set filetype=markdown " Set md to markdown


" TODO(leeola): prune or document
" ### Startify
" let g:startify_custom_header =
"       \ map(split(system('fortune | cowsay'), '\n'), '"   ". v:val') + ['','']

" TODO(leeola): move these rust settings to a rust specific file.
" ### vim-rust config
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

augroup filetype_rust
  " Clear the autocommands in this group, for safe repeated sourcing of this
  " file
  autocmd!
  " In normal mode, map Leader key combinations to vim-racer plugin methods.
  autocmd FileType rust nmap <Leader>dd <Plug>RacerGoToDefinitionDrect
  autocmd FileType rust nmap <Leader>ds <Plug>RacerGoToDefinitionSplit
  autocmd FileType rust nmap <Leader>dv <Plug>RacerGoToDefinitionVSplit
  autocmd FileType rust nmap <Leader>dk <Plug>RacerShowDocumentation
augroup END

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
" Automatically run this maker when we save .rs files.
autocmd! BufWritePost *.rs Neomake cargo



"
" ## Maps
"

" I'm not a fan of <C-f/b> behavior, where it moves the full screen.
" I feel like i lose context of where i am. I prefer <C-d> and <C-u>,
" because it keeps the cursor where it is on screen and moves half
" steps. However, C-d/u have awkward usage, and they're far apart.
" So i'm stealing the nice locations of f and b.
nmap <C-f> <C-d>
nmap <C-b> <C-u>


" ## Leaders

" Remap Leader to the Space key. This is an important keybind, since
" Leader is what we hide the vast majority of "custom experience" behind.
let mapleader=' '

" run ctrlp with leader p, and shift p to clear cache
nnoremap <silent> <Leader>p :CtrlP<cr>
nnoremap <silent> <Leader>P :ClearCtrlPCache<cr>\|:CtrlP<cr>
nnoremap <silent> <Leader>b :CtrlPBuffer<cr>
nnoremap <silent> <Leader>f :CtrlPLine<cr>

nnoremap <Leader>w :write<cr>

" ### vim-go
augroup filetype_go
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



" ### Chrome Specific Remaps
" (For in browser use)

