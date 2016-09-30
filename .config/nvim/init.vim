" # leeo.la/dotfiles
"
" The following is the config for my main editor, Neovim. It is split up
" between multiple source files _(init.vim and files within ./ftplugin)_, and
" written in somewhat-literate programming.
"
" For ease of navigation, the following languages have custom settings files:
"
" - [Go][./ftplugin/go.vim]
" - [Markdown][./ftplugin/markdown.vim]
" - [Python][./ftplugin/python.vim]
" - [Rust][./ftplugin/rust.vim]

" ## Pre-Plugin Setup
" First we setup some pre-plugin settings
"
" TODO(leeola): Write meaningful docstring for each line here.
set nocompatible
filetype off

" ## Plugin Setup
" Next we install our plugins. These are grouped by file type in most cases.
call plug#begin('~/.config/nvim/plugged')

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

" File navigation made easy via NerdTree. This plugin
Plug 'scrooloose/nerdtree'


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


" ### Pyhton Language Only
" jedi-vim provides a lot of ide functionality for python. Including, but not
" limited to:
"   - autocomplete
"   - goto definition
"   - goto assignment
"   - pydoc popup
"   - refactoring
Plug 'davidhalter/jedi-vim', {'for': 'python'}


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


" ## Whitespace Matching
" TODO(leeola): document this and move it within the file to an appropriate
" location.
"highlight ExtraWhitespace ctermbg=red guibg=red
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
augroup whitespace_group
  autocmd!
  autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
  autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match ExtraWhitespace /\s\+$/
  autocmd BufWinLeave * call clearmatches()
augroup END


" ## Vim Settings
" This lets us split out vimrc *(init.vim for neovim)* into multiple files
" based on the filetype. This makes it easier to locate the settings you care
" about. If it's a filetype specific setting, it's in that filetype's config.
" Otherwise, it's in here.
filetype plugin on

" Remap Leader to the Space key. This is an important keybind, since
" Leader is what we hide the vast majority of "custom experience" behind.
"
" Note that we're setting this nice and early, because any <Leader> binding
" before this (ie, nmap <Leader>n) wouldn't work.
let mapleader=' '

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

" ## Plugin Settings
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


" ## Maps
" I'm not a fan of <C-f/b> behavior, where it moves the full screen.
" I feel like i lose context of where i am. I prefer <C-d> and <C-u>,
" because it keeps the cursor where it is on screen and moves half
" steps. However, C-d/u have awkward usage, and they're far apart.
" So i'm stealing the nice locations of f and b.
nmap <C-f> <C-d>
nmap <C-b> <C-u>

" ## Plugin Maps
" ### CtrlP Maps
" run ctrlp with leader p, and shift p to clear cache
nnoremap <silent> <Leader>p :CtrlP<cr>
nnoremap <silent> <Leader>P :ClearCtrlPCache<cr>\|:CtrlP<cr>
nnoremap <silent> <Leader>b :CtrlPBuffer<cr>
nnoremap <silent> <Leader>f :CtrlPLine<cr>

" ### NERDTree Maps
" Toggle the NERDTree window.
nnoremap <Leader>n :NERDTreeToggle<cr>
" Find the current file within the NERDTree window. It also opens up NERDTree
" if it is not yet open.
nnoremap <Leader>N :NERDTreeFind<cr>
