def -hidden cuser-mode %{
  info -title "customer user mode" %{
    p: fuzzy find
    b: buffer
    a: window
    ": copy
  }
  #"
  # This random quote fixes the bad highlighting caused by the open quote,
  # above.

  on-key %{ %sh{
    case $kak_key in
      p) echo exec ":find " ;;
      b) echo cuser-buffer-mode ;;
      \") echo cuser-copy-mode ;;
    esac
  }
}}

def -hidden cuser-buffer-mode %{
  info -title "buffer mode" %{
    p: previous
    n: next
  }
  on-key %{ %sh{
    case $kak_key in
      p) echo exec '!pbpaste<ret>' ;;
      y) echo exec '<a-|>pbcopy<ret>' ;;
    esac
  }
}}

def -hidden cuser-copy-mode %{
  info -title "copy mode" %{
    p: paste clipboard
    y: yank clibpard
  }
  on-key %{ %sh{
    case $kak_key in
      p) echo exec '!pbpaste<ret>' ;;
      y) echo exec '<a-|>pbcopy<ret>' ;;
    esac
  }
}}

def -hidden cuser-window-mode %{
  info -title "window mode" %{
    s: horizontal window
    v: vertical window
  }
  on-key %{ %sh{
    case $kak_key in
      s) echo tmux-new-horizontal ;;
      v) echo tmux-new-veronical ;;
    esac
  }
}}

