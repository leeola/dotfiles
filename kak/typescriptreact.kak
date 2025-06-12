# copied / modified from:
#   https://github.com/mawww/kakoune/blob/master/rc/base/javascript.kak

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](tsx) %{
    set-option buffer filetype typescriptreact
}

# Commands
# ‾‾‾‾‾‾‾‾

init-javascript-filetype typescriptreact

# Highlighting specific to TypeScript
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
add-highlighter shared/typescriptreact/code/ regex \b(array|boolean|date|number|object|regexp|string|symbol)\b 0:type

# Keywords grabbed from https://github.com/Microsoft/TypeScript/issues/2536
add-highlighter shared/typescriptreact/code/ regex \b(as|constructor|declare|enum|from|implements|interface|module|namespace|package|private|protected|public|readonly|static|type)\b 0:keyword
