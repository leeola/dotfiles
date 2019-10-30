def -hidden cuser-mode %{
  info -title "customer user mode" %{
    p: fuzzy find
    b: buffer
    a: tmux
    ": copy
    l: language mode
  }
  #"
  # This random quote fixes the bad highlighting caused by the open quote,
  # above.

  on-key %{
    require-module fzf
    evaluate-commands %sh{
      case $kak_key in
        p) echo execute-keys ":fzf-mode<ret>f" ;;
        b) echo cuser-buffer-mode ;;
        a) echo cuser-tmux-mode ;;
        \") echo cuser-copy-mode ;;
        l) echo cuser-lang-mode ;;
      esac
    }
  }
}

def -hidden cuser-buffer-mode %{
  info -title "buffer mode" %{
    b: find buffer
    d: delete buffer
    s: search buffer
    n: next
    p: previous
  }
  on-key %{ evaluate-commands %sh{
    case $kak_key in
      b) echo execute-keys ":fzf-mode<ret>b";;
      d) echo delete-buffer ;;
      p) echo buffer-previous ;;
      n) echo buffer-next ;;
      s) echo execute-keys ":fzf-mode<ret>s";;
    esac
  }
}}

def -hidden cuser-copy-mode %{
  info -title "copy mode" %{
    p: paste from clipboard
    y: yank to clibpard
  }
  on-key %{ evaluate-commands %sh{
    case $kak_key in
      p) echo execute-keys '!pbpaste<ret>' ;;
      y) echo execute-keys '<a-|>pbcopy<ret>' ;;
    esac
  }
}}

def -hidden cuser-tmux-mode %{
  info -title "tmux mode" %{
    s: horizontal pane
    v: vertical pane
  }
  on-key %{ evaluate-commands %sh{
    case $kak_key in
      s) echo tmux-terminal-horizontal kak -c $kak_session ;;
      v) echo tmux-terminal-vertical kak -c $kak_session ;;
    esac
  }
}}

def -hidden -override cuser-lang-mode %{
  info -title "go mode" %{
    c: show lsp capabilities
    e: jump error line
    j: jump definition
    i: show information
    f: format
    h: highlight references
    r: rename
    `: diagnostics
  }
  on-key %{ evaluate-commands %sh{
    case $kak_key in
      c) echo lsp-capabilities ;;
      e) echo lsp-find-error ;;
      j) echo lsp-definition ;;
      i) echo lsp-hover ;;
      f) echo lsp-formatting ;;
      h) echo lsp-highlight-references ;;
      r) echo prompt "rename?" %{ lsp-rename %val{text} }  ;;
      \`) echo lsp-diagnostics  ;;
    esac
  }}
}
