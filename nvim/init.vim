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

" The color theme i'm using for Vim
Plug 'morhetz/gruvbox'

" Asynchronous building actions commonly used for linting and syntax checking
" for many languages. Quite useful, i even use a custom maker in Rust to
" handle the new (at this time) error format.
"
" host: https://github.com/neomake/neomake
Plug 'benekastah/neomake'

" File navigation made easy via NerdTree. This plugin
Plug 'scrooloose/nerdtree'

" A nice starting screen for easy opening of recent files, sessions, etc.
Plug 'mhinz/vim-startify'

" A nicer looking status bar at the bottom of vim.
"
" host: https://github.com/vim-airline/vim-airline
Plug 'vim-airline/vim-airline'

" Tmuxline is actually a bit strange. This is a vim plugin which configures a
" running tmux instance, to make it look like airline. Why this is a vim
" plugin is simply due to the developer deciding to use vimscript.
"
" Usage is basically running a Tmuxline command *(if needed)*, and
" snapshotting the current tmux settings onto a file. Then, adding an
" auto-source to tmux for that file. The commands for this are gone over in
" the documention [here](https://github.com/edkolev/tmuxline.vim#usage).
"
" host: https://github.com/edkolev/tmuxline.vim
Plug 'edkolev/tmuxline.vim'

" Tabular is an awesome plugin for aligning text. I don't normally use it, but
" i added it back _(after removing it)_ purely for the sake of automatically
" formatting markdown tables, which Tabular does. Without Tabular, it's a real
" pain to have nice looking formatted tables.
Plug 'godlygeek/tabular'

" This plugin automatically inserts a closing pair, nothing fancy.
"
" Previously i used to use [delimiMate](https://github.com/Raimondi/delimitMate),
" but every now and then it annoyed me... although i can't remember what it
" was exactly that bothered me. So, i'm trying out auto-pairs after a quick
" Google. We'll see how it goes.
"
" host: https://github.com/jiangmiao/auto-pairs
Plug 'jiangmiao/auto-pairs'

" A plugin for choosing windows in a tmux-like manner.
"
" It displays a letter in the status bar of each window (or overlayed in it)
" for you to choose from.
"
" host: https://github.com/t9md/vim-choosewin
Plug 't9md/vim-choosewin'


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


" ### Markdown Language Only
" vim-markdown is a nice plugin with a few surprising features for markdown
" editing. With that said, i'm not really using much of them atm, it just has
" good syntax highlighting.
"
" If i end up writing a lot, or figure out how to make comments in languages
" automatically use markdown and features of this plugin, i may expand usage
" of this.
"
" host: https://github.com/gabrielelana/vim-markdown
Plug 'gabrielelana/vim-markdown', {'for': 'markdown'}


" ### Go Language Only
" vim-go is a massive collection of golang tools for things like auto
" formatting, renaming, and auto imports.
"
" host: https://github.com/fatih/vim-go
Plug 'fatih/vim-go', {'for': 'go'}


" ### Toml Language Only
" A syntax highlighter, nothing fancy.
" Adding this because i'm using toml for a lot of my configs
" at home and work.
"
" host: https://github.com/cespare/vim-toml
Plug 'cespare/vim-toml', {'for': 'toml'}


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
" " snipMate and it's requirements
" Plug 'MarcWeber/vim-addon-mw-utils' " Dep for snipmate
" Plug 'tomtom/tlib_vim'              " Dep for snipmate
" Plug 'garbas/vim-snipmate'
" Plug 'honza/vim-snippets'
" Plug 'fatih/vim-go'
call plug#end()

" ## Vim Theme Settings
syntax enable

" Tell Solarized to use the dark themes
set background=dark

" Set the theme to Solarized
colorscheme gruvbox


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

" Show search highlights as you type.
"
" This is useful for checking your pattern matches as you type them. It can
" also be used to check substitute patterns via:
"
"     /pattern
"     :s//replacement
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

" ### Vim Airline Settings
" My current font setup (on my laptop) is using Powerline fonts, so we're
" enabling those here. This will allow nice looking arrows between the airline
" sections.
"
" I'm not sure if airline has it's own, non-powerline patched fonts, but for
" now powerline fonts will work fine.
let g:airline_powerline_fonts = 1

" ### Startify
" Modify the list order to show recent files in the current directory first.
"
" I'm doing this so that the nearby files are at a lower index and require
" less keystrokes to open, as these are likely the most desired ones.
let g:startify_list_order = [
  \ ['   Recent files in '. getcwd() .':'],
  \ 'dir',
  \ ['   Recent files elsewhere:'],
  \ 'files',
  \ ['   These are my bookmarks:'],
  \ 'bookmarks',
  \ ]

" This tells startify to set the working directory to the vcs root when
" opening a file. Otherwise it sets the working directory to the parent
" directory of the file you're opening, which is not desired.
let g:startify_change_to_vcs_root = 1


" ## Maps
" I'm not a fan of <C-f/b> behavior, where it moves the full screen.
" I feel like i lose context of where i am. I prefer <C-d> and <C-u>,
" because it keeps the cursor where it is on screen and moves half
" steps. However, C-d/u have awkward usage, and they're far apart.
" So i'm stealing the nice locations of f and b.
nmap <C-f> <C-d>
nmap <C-b> <C-u>

" Hide search highlighting until the next search.
"
" I was in a habit of clearing my search highlighting by typing `/zz`, which was
" proving to be quite annoying. Using `Shift /` is defaulted to searching
" backwards, but i can always use `/pattern` and `N`, to search backwards when
" desired - which is what i normally use anyway.
nmap <silent> ? :nohlsearch<cr>

" Search for and navigate to the next occurance of a visually selected block,
" in visual mode.
"
" This is useful for visually selecting a chunk of text, regardless of it is
" a vim word or not, and search for it. The * key was chosen because in
" normal mode * searches for the word under the cursor. So now * searches
" for the selected text in visual mode too. Seems logical.
" In the future i may want to add # for the reverse of this, just like normal
" mode.
vnoremap * y/<C-R>"<CR>


" ## Plugin Maps
" ### CtrlP Maps
" Bind `SPC p` to the main CtrlP bind. Note that we're using the variable
" assignment rather than a remap because otherwise CTRL-p *and* SPC p would be
" mapped to launch CtrlP
let g:ctrlp_map = '<Leader>p'

" Clear cache, and then search recent files.
nnoremap <silent> <leader>P :ClearCtrlPCache<cr>\|:CtrlP<cr>

" Search the files in buffers (eg, :ls)
nnoremap <silent> <Leader>[ :CtrlPBuffer<cr>

" Set the max number of most recentnly used files to something low.
"
" I don't need hundreds of files because i'm likely not even going to remember
" needing a specific file from a few hundred files ago. Most of the time my
" seeking in MRU will be some very recent file. By setting this number low, i
" should have an easier time finding those recent files.
"
" If it's too low, i can always make it bigger again.
let g:ctrlp_mruf_max = 30

" Search recent used files.
nnoremap <silent> <Leader>] :CtrlPMRUFiles<cr>

" Search CTags in the current Buffer
nnoremap <silent> <Leader>\ :CtrlPBufTag<cr>

" ### NERDTree Maps
" Toggle the NERDTree window.
nnoremap <Leader>n :NERDTreeToggle<cr>
" Find the current file within the NERDTree window. It also opens up NERDTree
" if it is not yet open.
nnoremap <Leader>N :NERDTreeFind<cr>

" Set the binding to Ctrl-w Ctrl-e for choosing vim windows.
"
" This is intended to be a nice common window chooser bind (Ctrl-e), and i
" plan to do the same with tmux. Eg, `PREFIX Ctrl-e` for tmux.
nmap <C-w><C-e> <Plug>(choosewin)
