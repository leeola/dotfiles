function pbp
  if command -v pbpaste >/dev/null 2>&1
    pbpaste
  else if command -v wl-paste >/dev/null 2>&1
    wl-paste
  else if command -v xclip >/dev/null 2>&1
    xclip -o -selection c
  else
    echo "No clipboard utility found" >&2
    return 1
  end
end
