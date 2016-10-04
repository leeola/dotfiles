
# Cheat Sheet

The following represents a cheat sheet for the leeo.la Dotfiles.

## Vim

### Open Files

| Command | Name                          | Notes |
| ------- | ----------------------------- | ----- |
| SPC p   | Search files                  |       |
| SPC P   | Clear cache then search files |       |
| SPC [   | Search buffers                |       |
| SPC ]   | Search recent files (MRU)     |       |

### General Code Language

| Command | Name                                 | Notes |
| ------- | ------------------------------------ | ----- |
| SPC g d | Goto definition                      |       |
| SPC g s | Goto definition in horizontal split  |       |
| SPC g v | Goto definition in vertical split    |       |
| SPC r   | Rename known instances of identifier |       |
| SPC k   | Goto documentation for identifier    |       |


## Tmux

| Command | Name            | Notes                                          |
| ------- | --------------- | ---------------------------------------------- |
| CTRL-a  | The tmux prefix | This precedes **all** documented tmux commands |
| $       | Rename session  |                                                |
| ,       | Rename Window   |                                                |

### Navigation

| Command | Name                             | Notes                  |
| ------- | -------------------------------- | ---------------------- |
| CTRL-a  | Switch to recent window          |                        |
| q <N>   | Show pane numbers, switch to <N> |                        |
| H,J,K,L | Resize pane left,down,up,right   |                        |
| CTRL-s  | Open new horizontal pane         | Mirrors Vim's CTRL-w s |
| CTRL-v  | Open new vertical pane           | Mirrors Vim's CTRL-w v |
