# Using the `system/` configuration

This directory contains environment variables, aliases, and functions for Zsh.
The `zsh/.zshrc` configuration automatically loads `.env`, `.alias`, and
`.functions`, in that order. After installing the dotfiles, open a new Zsh
session to use them.

To load only these files in an existing Zsh session:

```zsh
source ~/.dotfiles/system/.env
source ~/.dotfiles/system/.alias
source ~/.dotfiles/system/.functions
```

If you cloned the repository elsewhere, adjust these paths.
You can also run these commands again after editing the files.

## Environment variables: `.env`

Sets `EDITOR=vim`, the default editor for tools that read this variable.
Vim must be installed to use it.

```zsh
echo "$EDITOR"
# vim
```

To choose another editor, change the assignment in `.env`, for example:

```zsh
export EDITOR="nano"
```

Git has its own editor configured in `git/.gitconfig`; changing `EDITOR`
here does not override that explicit setting.

## Aliases: `.alias`

| Alias | Equivalent command | Purpose |
| --- | --- | --- |
| `l` | `ls -la` | Lists files, including hidden files, with details. |
| `ld` | `ls -ld */` | Lists visible directories in the current location. |
| `..` | `cd ..` | Moves up one directory level. |
| `...` | `cd ../..` | Moves up two directory levels. |
| `....` | `cd ../../..` | Moves up three directory levels. |

```zsh
l
l ~/Downloads
ld
..
```

You can pass arguments to `l` just as you would to `ls`. With the usual Zsh
settings, `ld` reports a matching error when there are no visible directories.

## Functions: `.functions`

### `mk`: create a directory and enter it

Accepts exactly one path, creates any required parent directories, and
changes to the destination only if directory creation succeeds.

```zsh
mk projects/demo
mk "projects/my project"
pwd
```

If the directory already exists, the function enters it. Quote paths that
contain spaces. With no arguments or more than one argument, it returns
status `2` and prints usage instructions.

### `extract`: extract an archive or mount an image

Accepts exactly one file. Archives containing multiple entries are extracted
into the current working directory; the function does not create a destination
folder. To choose a destination, enter a folder first and pass the archive path:

```zsh
mk ~/Downloads/contents
extract ../package.tar.gz
extract "/path/with spaces/archive.zip"
```

| Extensions | Required tool | Behavior |
| --- | --- | --- |
| `.tar.bz2`, `.tbz2`, `.tar.gz`, `.tgz`, `.tar` | `tar` | Extracts entries into the current directory. |
| `.zip`, `.ZIP` | `unzip` | Extracts entries into the current directory. |
| `.bz2` | `bunzip2` | Decompresses alongside the original file and normally removes the compressed file. |
| `.gz` | `gunzip` | Decompresses alongside the original file and normally removes the compressed file. |
| `.Z` | `uncompress` | Decompresses alongside the original file and normally removes the compressed file. |
| `.pax` | `cat`, `pax` | Extracts entries into the current directory. |
| `.pax.Z` | `uncompress`, `pax` | Decompresses and extracts into the current directory. |
| `.dmg` | `hdiutil` (macOS) | Mounts the disk image. |

Tool selection depends on the file extension and is case-sensitive; ZIP
supports both variants shown above. Other formats, such as `.7z`, `.rar`,
and `.tar.xz`, are not supported. The required tools must be installed.

The function returns `1` if the file does not exist or the format is unsupported,
and `2` unless it receives exactly one argument. For supported formats, it
returns the executed command's status; for PAX pipelines, the status depends
on the `PIPE_FAIL` option in your Zsh session.

```zsh
extract package.zip
echo $?
# 0 if extraction completed successfully
```
