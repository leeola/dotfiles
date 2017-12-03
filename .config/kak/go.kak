# # Local Go Plugin
#
# Override some of the default Go settings.
#

# The default go highlighting incorrectly highlights interface and struct,
# so i've moved them to an attributes type.
#
# NOTE(leeola): this conflicts with the internal declaration of highlights in
# /usr/local/share/kak/rc/base/go.kak. So for now, it needs to be disabled.
# If i can't find a solution soon, i'll likely make an autoload and version
# control all of the files.
%sh{
    # Grammar
    attributes="interface|struct"
    keywords="break|default|func|interface|select|case|defer|go|map"
    keywords="${keywords}|chan|else|goto|package|switch|const|fallthrough|if|range|type"
    keywords="${keywords}|continue|for|import|return|var"
    types="bool|byte|chan|complex128|complex64|error|float32|float64|int|int16|int32"
    types="${types}|int64|int8|intptr|map|rune|string|uint|uint16|uint32|uint64|uint8"
    values="false|true|nil|iota"
    functions="append|cap|close|complex|copy|delete|imag|len|make|new|panic|print|println|real|recover"

    # Add the language's grammar to the static completion list
    printf %s\\n "hook global WinSetOption filetype=go %{
        set-option window static_words '${keywords}:${attributes}:${types}:${values}:${functions}'
    }" | sed 's,|,:,g'

    # Highlight keywords
    printf %s "
        add-highlighter shared/go/code regex \b(${keywords})\b 0:keyword
        add-highlighter shared/go/code regex \b(${attributes})\b 0:attribute
        add-highlighter shared/go/code regex \b(${types})\b 0:type
        add-highlighter shared/go/code regex \b(${values})\b 0:value
        add-highlighter shared/go/code regex \b(${functions})\b 0:builtin
    "
}
 

# Enable autocomplete for go files
hook global WinSetOption filetype=go %{go-enable-autocomplete}

# Enable Golang goimports on file save
hook global BufWritePost .*\.go %{go-format -use-goimports}
