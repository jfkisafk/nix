# CLAUDE.md

`nix-darwin` + `home-manager` flake for one Mac: host `darkstar`, user `stelo`, `aarch64-darwin`. Rose-pine themed; language runtimes come from `mise`, not nixpkgs.

## Commands

```sh
darwin-rebuild switch --flake .#darkstar   # apply everything (system, brew, fonts, home)
darwin-rebuild check  --flake .#darkstar   # evaluate without applying
```

Run from the repo root. There is no standalone `home-manager switch` — home-manager is a darwin module, so **every** change under `home/` needs `darwin-rebuild switch`.

No tests, no linter. CI is `.github/workflows/gitleaks.yml` (secret scan) only.

## Layout

`flake.nix` → `darwinConfigurations.darkstar`, composed of:

| Module | Contents |
|---|---|
| `hosts/darkstar/configuration.nix` | host settings; imports the three files below |
| `system/mac.nix` | `system.defaults` only (Finder, Dock, trackpad…). No packages. |
| `pkgs/system.nix` | nixpkgs CLI tools → `/run/current-system/sw/bin` |
| `pkgs/brew.nix` | `casks` (GUI apps) + `brews` (formulae not in nixpkgs) |
| `pkgs/fonts.nix` | Nerd Fonts |
| `home/home.nix` | wired in `flake.nix` as `home-manager.users.stelo`, **not** in `configuration.nix` |

`pkgs/brew.nix` sets `onActivation.cleanup = "zap"` — deleting an entry uninstalls the app on next switch.

## home/

`home/home.nix` holds `home.file` (static dotfiles: rose-pine Claude theme, `statusline.nu`) and a `programs` block of one-line imports.

Each `home/<file>.nix` is `{ pkgs, ... }: { enable = true; ... }` — the attrset *is* the value of `programs.<name>`. The attr name is not always the filename: `claude-code`→`claude.nix`, `awscli`→`aws.nix`, `nushell`→`nu.nix`, `antigravity-cli`→`antigravity.nix`.

Add a program: write `home/<file>.nix`, then add `<name> = import ./<file>.nix { inherit pkgs; };` to `programs` in `home/home.nix`. Copy `home/bat.nix` (minimal) or `home/git.nix` (full) for shape.

`home/activation.nix` is the exception — `home.activation`, imported with `{ inherit pkgs lib; }`, entries are `lib.hm.dag.entryAfter ["writeBoundary"] ''…''`. Runs on every switch: SSH keygen + `gh ssh-key add`, `chsh` to `nu`, and the `mise` global toolchain list (node, go, python, rust, java, terraform…).

## Conventions

- New package: nixpkgs CLI → `pkgs/system.nix`; GUI/brew-only → `pkgs/brew.nix`. Language runtimes go in the `installMiseTools` tool list in `home/activation.nix` — never in nixpkgs or brew.
- Rose-pine hex values are duplicated inline per module (`btop`, `k9s`, `yazi`, `lazygit`, `git` delta styles, the theme in `home/home.nix`). A palette change means editing each one; there is no shared color attrset.
- Shell is Nushell (`home/nu.nix`); prompt is `home/starship.nix`.
