#!/usr/bin/env fish
#
#
#


for f in (ls -A /docker-shared)
  set -l src /docker-shared/$f
  set -l dst /root/$f
  echo "====== Linking $src to $dst"
  ln -s $src $dst
end
