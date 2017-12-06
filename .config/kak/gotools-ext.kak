
# NOTE(leeola): this has plenty of limitations in implementation,
# improvements coming in the near future. this is just a hack.
def -allow-override go-ext-jump-def %{
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
      e: jump error line
      j: jump definition
      r: rename
    }
    on-key %{ %sh{
      case $kak_key in
        e) echo jump-code-err ;;
        j) echo go-ext-jump-def ;;
        r) echo go-ext-rename  ;;
      esac
    }}
  }
}

define-command go-ext-rename %{
  prompt "rename: " %{
    %sh{
      result=$(gorename -offset "${kak_buffile}:#${kak_cursor_byte_offset}" -to ${kak_text} 2>&1)
      status=$?
      if [ $status -ne 0 ]; then
        printf %s\\n 'go-ext-check-source "$result"'
        exit $status
      fi

      printf %s\\n "unset-code-err-line"
      printf %s\\n "echo ${result}"
    }
    edit!
  }
}

define-command -params ..1 go-ext-check-source %{
  %sh{
    result=$(go build $(dirname ${kak_bufname})/*.go 2>&1)
    status=$?

    if [ $status -ne 0 ]; then
      firstLine="true"
      echo "${result}" | while read err_line; do
        if [ ${firstLine} == "true" ]; then
          firstLine="false"
          continue
        fi

        # quote the err_line to ensure it's only a single argument.
        printf %s\\n "set-code-err-line \"${err_line}\""
      done
    else
      # go-ext-check-source allows the caller to check the source
      # if an error was encountered from things like goimports/gorename/etc.
      # If no actual syntax error is present though, go-ext-check-source
      # can print whatever error message those commands received, here.
      if [ -n "${1}" ]; then
        printf %s\\n "fail unknown error: \"${result}\""
      fi

      printf %s\\n "unset-code-err-line"
    fi
  }
}

define-command go-ext-imports %{
    %sh{
        dir=$(mktemp -d "${TMPDIR:-/tmp}"/kak-go.XXXXXXXX)
        printf %s\\n "set-option buffer go_format_tmp_dir ${dir}"
        printf %s\\n "evaluate-commands -no-hooks write ${dir}/buf"
    }
    %sh{
        dir=${kak_opt_go_format_tmp_dir}
        err_out=$(goimports -srcdir '${kak_buffile}' -e -w ${dir}/buf 2>&1)
        if [ $? -eq 0 ]; then
            cp ${dir}/buf "${kak_buffile}"

            printf %s\\n "unset-code-err-line"
        else
            printf %s\\n "go-ext-check-source \"${result}\""
        fi
        rm -r ${dir}
    }
    edit!
}
