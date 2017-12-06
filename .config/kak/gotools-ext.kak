
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
        j) echo go-ext-jump-def ;;
        e) echo go-ext-jump-err-line ;;
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
        prefix=$(echo ${result} | cut -d ':' -f 1)
        cannotparse=$(echo ${result} | cut -d ':' -f 4)

        # in two scenarios we can parse the output and get
        # an error location.
        if [ ${cannotparse} == " cannot parse file" ]; then
          err_line=$(echo ${result} | cut -d ':' -f 5,6,7)
        elif [ ${prefix} != "gorename" ]; then

          # only use the first line. This is a bit hacky,
          # i hate bash.
          result=$(echo "${result}" | while read line; do echo ${line}; break; done)

          err_line=${result}
        fi

        if [ -n "${err_line}" ]; then
          # quote the err_line to ensure it's only a single argument.
          printf %s\\n "set-code-err-line \"${err_line}\""
        else
          printf %s\\n "fail unknown error: ${result}"
        fi
        exit $status
      fi

      printf %s\\n "echo ${result}"
    }
    edit!
  }
}

define-command go-ext-jump-err-line %{
  %sh{
    if [ ${kak_opt_code_err} == "true" ]; then
      # TODO(leeola): is there a better way to move the cursor?
      printf %s\\n "edit ${kak_buffile} ${kak_opt_code_err_line}"
    else
      printf %s\\n "echo no current line ${kak_opt_code_err}"
    fi
  }
}

# TODO(leeola): move these to somewhere .. sane? Not sure where is good.
# I just know that they error out if called repeatedly, ie on multile
# calls to go-ext-imports.
declare-option line-specs code_errors
declare-option bool code_err
declare-option int code_err_line
set-face CodeErrorFlags default,default

define-command -params 1 set-code-err-line %{
  %sh{
    line=$(echo ${1} | cut -d ':' -f 2)

    # get the timestamp for the set-option usage.
    # No idea why it wants a timestamp.
    timestamp=$(date +%s)

    if [ ${kak_opt_code_err} == "false" ]; then
      printf %s\\n "add-highlighter window/ flag_lines CodeErrorFlags code_errors"
      printf %s\\n "set-option buffer code_err true"
      printf %s\\n "set-option buffer code_err_line ${line}"
    fi


    # set whatever line this error was one.
    printf %s\\n "set-option global code_errors ${timestamp}:${line}|{red,default}x"

    # report the most recent error.
    printf %s\\n "fail ${1}"
  }
}

define-command unset-code-err-line %{
  set-option buffer code_err false
  remove-highlighter window/flag_lines
}

define-command go-ext-imports \
    -docstring "go-format [-use-goimports]: custom formatter for go files" %{
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

            printf %s\\n "set-option buffer code_err false"
            printf %s\\n "remove-highlighter window/flag_lines"
        else
            code_err_line=$(echo ${err_out} | cut -d ':' -f 2)

            # get the timestamp for the set-option usage.
            # No idea why it wants a timestamp.
            timestamp=$(date +%s)

            printf %s\\n "set-option buffer code_err_line ${code_err_line}"
            printf %s\\n "set-option buffer code_err true"

            printf %s\\n "remove-highlighter window/flag_lines"
            # this is super hacky and only supports a single line. To be improved later
            printf %s\\n "set-option global code_errors ${timestamp}:${code_err_line}|{red,default}x"
            printf %s\\n "add-highlighter window/ flag_lines CodeErrorFlags code_errors"

            printf %s\\n "fail ${err_out}"
        fi
        rm -r ${dir}
    }
    edit!
}
