def go-ext-jump-def %{
  %sh{
    guru_output=$(guru definition ${kak_bufname}:#${kak_cursor_byte_offset})
    file=$(echo $guru_output | cut -d ':' -f 1)
    line=$(echo $guru_output | cut -d ':' -f 2)
    column=$(echo $guru_output | cut -d ':' -f 3)
    printf "edit $file $line $column\n"
  }
}

# cuser-lang-mode defined/overridden for  Go language.
#
# NOTE(leeola): i've got no idea if this usage will work.
# The goal is to create a cuser mode that will be different
# for different languages, but with the same keybinds.
#
# Currently i'm trying to just override it if the hook WinSetOption
# is called.
hook global WinSetOption filetype=go %{
  def -hidden -allow-override cuser-lang-mode %{
    info -title "go mode" %{
      j: jump definition
    }
    on-key %{ %sh{
      case $kak_key in
        j) echo go-ext-jump-def ;;
      esac
    }}
  }
}
