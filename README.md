
# Lee's Dotfiles

These are my dotfiles. There are many dotfiles like them, but these are mine.


##  Installation

A preinstalled Node is required to install this.

1. Run `npm install`
2. Run `./install.coffee`
3. That's it!


## Destructive and Dumb

This is a *destructive and dumb* installation. It doesn't attempt to install
missing components, it will install everything every time. If you're files
are in the way, say goodbye to them. You have been warned.

If a file/directory is in the way, it will be moved to
`/tmp/dotfiletrash/DATETIME`. So, if you're missing something that you didn't
expect to be removed, check there. Otherwise, you have already been warned.


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

