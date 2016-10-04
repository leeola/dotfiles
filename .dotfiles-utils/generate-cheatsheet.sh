#!/usr/bin/env fish
#
# # Generate the Dash Cheatsheet
# Just a little script to generate my dash dotfile cheatsheet and put it in
# the proper location.
set -l generated_name dotfiles.docset
set -l dest_parent ~/Library/Application Support/Dash/Cheat Sheets/dotfiles
echo "Generating cheatsheet..."
cheatset generate dotfiles-cheatsheet.rb
mkdir -p $dest_parent
echo "Moving $generated_name to $dest_parent/$generated_name"
mv "$generated_name" "$dest_parent"
