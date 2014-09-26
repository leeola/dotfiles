
# Lee's Dotfiles

These are my dotfiles. There are many dotfiles like them, but these are mine.


README TODO

## Useful Tidbits

### Symbolic Links and Readonly Filesystems

VirtualBox has an [ongoing 
issue](https://www.virtualbox.org/ticket/10085) where symlinks fail to be 
created. The solution for that is running the following command:

```
VBoxManage setextradata boot2docker-vm VBoxInternal2/SharedFoldersEnableSymlinksCreate/docker-shared 1
```

If you have a different VM name or sharename, follow the below 
instructions.

```
VBoxManage setextradata VM_NAME VBoxInternal2/SharedFoldersEnableSymlinksCreate/SHARE_NAME 1
```

To find your `VM_NAME`, run the following.

```
VBoxManage list vms
```

And to find your `SHARE_NAME`, run the following command and look for the 
`Shared folders:` section towards the bottom.

```
VBoxManage showvminfo VM_NAME
```

