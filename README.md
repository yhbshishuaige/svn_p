# svn_p

`svn_p` is a tiny wrapper around Git sparse checkout. It exports one directory
from a GitHub/Git repository into a local target directory, similar to the old
`svn export` workflow for GitHub subdirectories.

GitHub no longer supports Subversion access on `github.com`, so commands like
`svn export https://github.com/user/repo/trunk/path` no longer work. This tool
uses Git instead.

## Install

Clone this repository, then run:

```bash
./install.sh
```

By default, it installs the command to:

```text
/usr/bin/svn_p
```

`install.sh` uses `sudo`, so you may need to enter your password.

## Usage

```bash
svn_p <git-repo-url> <target-dir> --export=<repo-subdir>
```

Example:

```bash
svn_p https://github.com/sajjadium/ctf-archives.git ./try --export=/ctfs/L3HCTF/2025
```

This exports:

```text
ctfs/L3HCTF/2025
```

into:

```text
./try
```

So the result looks like:

```text
./try/misc
./try/pwn
./try/crypto
./try/web
./try/rev
./try/README.md
```

The leading slash in `--export=/ctfs/L3HCTF/2025` is optional. These two forms
are equivalent:

```bash
--export=/ctfs/L3HCTF/2025
--export=ctfs/L3HCTF/2025
```

## How It Works

Internally, `svn_p` does three things:

```bash
git clone --depth 1 --filter=blob:none --sparse "$repo" "$tmp"
git -C "$tmp" sparse-checkout set "$export_path"
cp -a "$tmp/$export_path/." "$target_dir/"
```

If `rsync` is available, it uses `rsync -a` for the copy step.

The temporary clone directory is created under `/tmp` and removed automatically
when the command exits.

## Bash Command Cache

If you remove or move an installed command, Bash may still remember the old path:

```bash
type svn_p
svn_p is hashed (/home/loo/.local/bin/svn_p)
```

This does not mean the file still exists. It only means Bash cached the old
lookup result. Clear the cache with:

```bash
hash -r
```

Then check again:

```bash
type svn_p
```

## Requirements

- `bash`
- `git`
- `cp`, or optionally `rsync`
