# # Local Go Plugin
#
# Override some of the default Go settings.
#

# The default go highlighting incorrectly highlights interface and struct,
# so i've moved them to an attributes type.
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
        set window static_words '${keywords}:${attributes}:${types}:${values}:${functions}'
    }" | sed 's,|,:,g'

    # Highlight keywords
    printf %s "
        add-highlighter -group /go/code regex \b(${keywords})\b 0:keyword
        add-highlighter -group /go/code regex \b(${attributes})\b 0:attribute
        add-highlighter -group /go/code regex \b(${types})\b 0:type
        add-highlighter -group /go/code regex \b(${values})\b 0:value
        add-highlighter -group /go/code regex \b(${functions})\b 0:builtin
    "
}
