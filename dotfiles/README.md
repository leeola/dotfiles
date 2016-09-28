
# leeo.la/dotfiles

These are my dotfiles. There are many dotfiles like them, but these are mine.

## Big Dragon Warning

These dotfiles are a bit crazy. Why? Well, the entire development
environment is setup inside of Docker. I won't bother outlining the 
motivations for doing this here *(seems better suited for a blog post)*, 
but just understand the following bullets, before you proceed to 
installation:

1. This repo will likely eat your dog.
2. This repo will likely eat your code.
3. This repo will likely kick you in the shin.
4. I don't know what i'm doing *(clearly)*.

## Requirements

Docker.

If you want to use the helper scripts, you'll need Fish Shell as well.

## Installation

Clone the repo.

```
git clone https://github.com/leeola/dotfiles
cd dotfiles
```

*\[optional\]* Install the helper tool

```
./misc/dotfiles.fish link
```

## Build

To run a container, you must first build the image.

```
dotfiles build
```

## Notes

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

