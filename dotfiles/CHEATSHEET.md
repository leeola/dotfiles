
# Cheat Sheet

The following represents a cheat sheet for the leeo.la Dotfiles.

## Vim

### Navigation

`,p` - Opens CtrlP
`,P` - Clears the CtrlP cache, then opens CtrlP
`,b` - Opens CtrlP for the Vim Buffer.

### Git

`,gw` - Synonymous with `git add` on the current file. Also saves.

### Golang Files

`,dd` - Goto the definition of the given identitifer.
`,ds` - Goto the definition of the given identifier in a horizontally 
  split window.
`,dv` - Goto the definition of the given identifier in a vertically split
  window.

`,r` - Rename the current identifier with GoRename

`,gd` - Goto the Godoc for the given identifier in a horizontally split 
  window.
`,gv` - Goto the Godoc for the given identifier in a horizontally split 
  window.

`,q` - Show Info on the current identifier

`,e` - Run GoImports on the current file.
`,l` - Run GoLint


## Tmux

`C-a C-a` - Swap windows.

`C-a q <N>` - Show pane numbers, then select a number. Ie, `C-a q 1`

`C-a H,J,K,L` - Resize the pane left/down/up/right
