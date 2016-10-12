
# Cheat Sheet

The following represents a cheat sheet for the leeo.la Dotfiles.

## Vim

### File Navigation

| Command      | Name                                 | Notes |
| ------------ | ------------------------------------ | ----- |
| SPC p        | Search files                         |       |
| SPC [        | Search buffers                       |       |
| SPC ]        | Search recent files (MRU)            |       |
| SPC p CTRL-p | Clear CtrlP Cache                    |       |
| SPC n        | Open file tree                       |       |
| SPC N q      | Close file tree                      |       |
| SPC N c d q  | Change the CWD to current file's dir |       |

### Code Navigation

| Command | Name                                 | Notes |
| ------- | ------------------------------------ | ----- |
| SPC g g | Goto definition                      |       |
| SPC g s | Open definition in horizontal split  |       |
| SPC g v | Open definition in vertical split    |       |
| SPC r   | Rename known instances of identifier |       |
| SPC k k | Goto documentation for identifier    |       |
| SPC k v | Open documentation for identifier    |       |


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
