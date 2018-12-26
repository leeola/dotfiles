# cuser-lang-mode defined/overridden for  Go language.
#
# NOTE(leeola): i've got no idea if this usage will work.
# The goal is to create a cuser mode that will be different
# for different languages, but with the same keybinds.
#
# Currently i'm trying to just override it if the hook WinSetOption
# is called.
# hook global WinSetOption filetype=go %{
#   def -hidden -override cuser-lang-mode %{
#     info -title "go mode" %{
#       e: jump error line
#       j: jump definition
#       i: show documentation
#       r: rename
#     }
#     on-key %{ %sh{
#       case $kak_key in
#         e) echo jump-code-err ;;
#         j) echo gokakoune-jump-def ;;
#         i) echo gokakoune-show-doc ;;
#         r) echo gokakoune-rename  ;;
#       esac
#     }}
#   }
# }

define-command go-ext-imports %{
    evaluate-commands %sh{
        dir=$(mktemp -d "${TMPDIR:-/tmp}"/kak-go.XXXXXXXX)
        printf %s\\n "set-option buffer go_format_tmp_dir ${dir}"
        printf %s\\n "evaluate-commands -no-hooks write ${dir}/buf"
    }
    evaluate-commands %sh{
        dir=${kak_opt_go_format_tmp_dir}
        err_out=$(goimports -srcdir '${kak_buffile}' -e -w ${dir}/buf 2>&1)
        if [ $? -eq 0 ]; then
            cp ${dir}/buf "${kak_buffile}"

            #printf %s\\n "gokakoune-compile-check"
        #else
            #printf %s\\n "gokakoune-compile-check \"${result}\""
        fi

        # TODO(leeola): enable error reporting like above.
        # The new Go method doesn't support error reporting,
        # though i'll likely rewrite this command to properly
        # handle this stuff anyway.
        printf %s\\n "gokakoune-compile-check"


        rm -r ${dir}
    }
    edit!
}
