def -hidden cuser-mode %{
  info -title "customer user mode" %{
    p: fuzzy find
    b: buffer
    a: tmux
    ": copy
  }
  #"
  # This random quote fixes the bad highlighting caused by the open quote,
  # above.

  on-key %{ %sh{
    case $kak_key in
      p) echo exec ":find<space><tab>" ;;
      b) echo cuser-buffer-mode ;;
      a) echo cuser-tmux-mode ;;
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
      p) buffer-previous ;;
      n) buffer-next ;;
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

def -hidden cuser-tmux-mode %{
  info -title "tmux mode" %{
    s: horizontal pane
    v: vertical pane
  }
  on-key %{ %sh{
    case $kak_key in
      s) echo tmux-new-horizontal ;;
      v) echo tmux-new-veronical ;;
    esac
  }
}}

