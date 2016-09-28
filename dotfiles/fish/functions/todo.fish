# Use SilverSearcher to search the current directory for the
# `TODO:` string in the beginning of comments.
function todo
  set -l regExp '(//|#|<!--|")\s?TODO:'
  # --skip-vcs-ignores  Skip vcs ignores
  # --hidden            Include hidden files
  # --ignore-case       Ignore case
  ag --skip-vcs-ignores --hidden --ignore-case "$regExp" $argv
end
