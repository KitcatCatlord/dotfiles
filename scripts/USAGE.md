## How to use these scripts

This folder contains custom command-line tools.

Add it to your PATH:

```sh
export PATH="$HOME/dotfiles/scripts:$PATH"
```
(Replace the path with your own path if you've changed it)

Reload your shell:

```sh
source ~/.zshrc
```

---

## Commands

### newcpp

Generates a C++ project using CMake.

Usage:

```sh
newcpp <name>
```

Creates a new folder called `<name>` with:

- `src/main.cpp`
- `CMakeLists.txt`
- `build/` (pre-configured)

Generate in the current directory:

```sh
newcpp <name> --here
```

Show help:

```sh
newcpp --help
```

---

## Notes

Make each script executable:

```sh
chmod +x scriptname
```

Place executable scripts directly in this folder if you want them to work as commands.
Don't create folders to organise scripts - you'll have to add each subfolder to PATH.
