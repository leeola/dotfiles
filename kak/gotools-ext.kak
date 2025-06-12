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
