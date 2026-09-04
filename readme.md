# Nix Darwin Config

## Table of Contents

- [Overview](#overview)
- [Features](#features)
  - [Packages](#packages)
  - [Hosts](#hosts)
  - [System](#system)
  - [Home Manager](#home-manager)
- [Installation](#installation)

## Overview

This project is a Nix configuration for my Mac. It's based on the [NixOS Darwin configuration](https://mynixos.com/nix-darwin). The `darkstar`
flake is the base MacOS configuration I use across all my Macs. This is written in a declarative and extensible way to support
Linux machines as well.

## Features

### Packages

- **System Packages (pkgs/system.nix)**: All the system packages are installed in _/run/current-system/sw/bin_. Home manager will use these glboal packages unless user defined packages are provided.
- **Fonts (pkgs/fonts.nix)**: The Nerd Font(s) that will be used for terminals/editors. You can find them in Font Book.
- **Brew and AppStore Apps (pkgs/brew.nix)**: This will install commands not present in nixpkgs. Plus, we install most applications via casks and AppStore.

### Hosts

- **darkstar**: This is the base configuration which specifies the environment and home directory for my Mac. The supported shells are zsh, fish and nushell.

### System

- **mac.nix**: Basic configuration for macOS to automatically define NSGlobal and other settings for the system.
- **activation.nix**: Activation scripts for the system. Currently used to:
  - setup the default shell to [Nushell](https://www.nushell.sh/)
  - generate an SSH key if one does not exist
  - install language tools via [mise](https://mise.jdx.dev): node, deno, dotnet, bun, yarn, python, poetry, java, rust, go, ruby, spectral, terraform. Nushell init script sets up mise environment variables accordingly.

### Home Manager

> [!NOTE]
> Sets up the home directory for the user (_home/home.nix_).

It specifies the following configurations:

- **[Atuin](https://atuin.sh/)**: Helps with the history of commands.
- **AWS**: Configures AWS CLI profiles.
- **[Bat](https://github.com/sharkdp/bat)**: Syntax highlighting replacement for cat.
- **[btop](https://github.com/aristocratos/btop)**: Resource monitor in terminal. Rose pine colorscheme defined inline.
- **[Carapace](https://carapace.sh/)**: Autocomplete for the shell.
- **[Direnv](https://direnv.net/)**: Automatically loads environment variables.
- **Git**: Configures git with SSH signing, [delta](https://github.com/dandavison/delta) for better git diffs, and a comprehensive global gitignore.
- **[Nushell](https://www.nushell.sh/)**: Loads nushell configurations from home directory. Sources atuin, carapace, direnv, starship and tmux plugins. Loads mise environment variables and defines extra keybindings and aliases. Ctrl+T opens a [herdr](https://github.com/stelo-labs/herdr) session.
- **[Starship](https://starship.rs/)**: Rose pine themed prompt.
- **[Tmux](https://github.com/tmux/tmux)**: Configures tmux with rose pine status bar and custom keybindings and plugins.
- **[K9s](https://k9scli.io/)**: Kubernetes TUI with rose pine skin defined inline.
- **[Yazi](https://yazi-rs.github.io)**: Terminal file manager with rose pine colorscheme and a comprehensive inline icon theme.
- **[Lazygit](https://github.com/jesseduffield/lazygit)**: Git UI for the terminal with rose pine theme.
- **[Ripgrep](https://github.com/BurntSushi/ripgrep)**: Faster grep replacement, configured for smart-case and hidden files.
- **[Claude Code](https://claude.com/product/claude-code)**: Anthropic's CLI agent, configured with rose pine theme, engineering/technical-writing rules, `gh` read-only permissions, and Atuin history hooks.
- **[opencode](https://opencode.ai)**: Terminal coding agent, configured with the same rules and `gh` permissions as Claude Code, plus a matching rose pine theme.
- **[Antigravity](https://antigravity.google)**: Google's CLI agent, configured with the same engineering/technical-writing rules and `gh`/git read-only permissions.
- **[Ghostty](https://ghostty.org)**: GPU-accelerated terminal emulator, themed rose pine (light/dark), JetbrainsMono Nerd Font.

> [!NOTE]
> Home manager also uses activation scripts to setup ssh keys for git signing and authentication.

## Installation

To install Nix OS, you can use:

```sh
sh <(curl -L https://nixos.org/nix/install)
```

**(Optional)** To check if Nix is installed, you can use:

```sh
nix-shell -p neofetch --run neofetch
```

Once Nix is installed, you can check out this repo and run the following command to install all the system packages,
brew casks, fonts and AppStore apps defined in the `darkstar` flake:

```sh
nix run nix-darwin --extra-experimental-features "nix-command flakes"  -- switch --flake .#darkstar
```

This will add `darwin-rebuild` to your path, so for further updates you can simply run:

```sh
/run/current-system/sw/bin/darwin-rebuild switch --flake .#darkstar
```

> [!WARNING]
> This command needs to be run from the root of this repo folder. Otherwise, you can provide the path to folder where you cloned this repo (path to _flake.nix_).

This command will also setup the home directory _/Users/stelo_ but if you are making further changes to home configuration,
you will need to run this command:

```sh
home-manager switch --flake /path/to/flake.nix
```
