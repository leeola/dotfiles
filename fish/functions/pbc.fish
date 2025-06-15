function pbc
  if command -v pbcopy >/dev/null 2>&1
    pbcopy
  else if command -v wl-copy >/dev/null 2>&1
    wl-copy
  else if command -v xclip >/dev/null 2>&1
    xclip -i -selection c
  else
    echo "No clipboard utility found" >&2
    return 1
  end
end
