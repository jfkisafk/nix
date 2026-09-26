# AGENTS.md

`nix-darwin` + `home-manager` flake for one Mac: host `darkstar`, user `stelo`, `aarch64-darwin`. Rose-pine themed; language runtimes come from `mise`, not nixpkgs.

## Commands

```sh
darwin-rebuild switch --flake .#darkstar   # apply everything (system, brew, fonts, home)
sudo darwin-rebuild check --flake .#darkstar   # evaluate without applying; needs root
nix eval --raw .#darwinConfigurations.darkstar.config.system.build.toplevel.drvPath   # evaluate without root
```

Run from the repo root. There is no standalone `home-manager switch` — home-manager is a darwin module, so **every** change under `home/` needs `darwin-rebuild switch`.

No tests, no linter. CI is `.github/workflows/gitleaks.yml` (secret scan) only.

## home/

`home/home.nix` holds `home.file` (static dotfiles: rose-pine Claude theme, `scripts/claude-statusline.nu`, `.config/karabiner/karabiner.json`, `.config/nvim` as an out-of-store symlink to `/Volumes/nitro/nvim`) and a `programs` block of one-line imports.

`home/scripts/` holds Nushell scripts referenced by path from modules: `claude-statusline.nu` (linked into `~/.claude`) and `llm-cost.nu` (sourced by the starship `custom.llm_cost` module). Put script bodies there rather than inline in a module.

`home/karabiner.nix` is not a program module: it returns a `writeText` derivation linked as `.config/karabiner/karabiner.json` from `home.file`, leaving the directory writable for Karabiner-Elements.

Each `home/<file>.nix` is `{ pkgs, ... }: { enable = true; ... }` — the attrset *is* the value of `programs.<name>`. The attr name is not always the filename: `claude-code`→`claude.nix`, `awscli`→`aws.nix`, `nushell`→`nu.nix`.

Add a program: write `home/<file>.nix`, then add `<name> = import ./<file>.nix { inherit pkgs; };` to `programs` in `home/home.nix`. Copy `home/bat.nix` (minimal) or `home/git.nix` (full) for shape.

`opencode.nix` reads the engineering and technical-writing rules from `claude.nix`; edit them there only.

`home/activation.nix` is the exception — `home.activation`, imported with `{ inherit pkgs lib; }`, entries are `lib.hm.dag.entryAfter ["writeBoundary"] ''…''`. Runs on every switch: SSH keygen + `gh ssh-key add`, `chsh` to `nu`, `mise upgrade`/`prune` against the tool list in `home/mise.nix`, and installing the `vim-herdr-navigation` herdr plugin that `home/herdr.nix` binds to ctrl+hjkl. Entries that read files written by home-manager use `entryAfter ["linkGeneration"]`.

## Conventions

- New package: nixpkgs CLI → `pkgs/system.nix`; GUI/brew-only → `pkgs/brew.nix`. Language runtimes go in `globalConfig.tools` in `home/mise.nix` — never in nixpkgs or brew.
- A tool with a `home/<file>.nix` module gets its package from `programs.<name>.enable`; don't also list it in `pkgs/system.nix`.
- Shell integrations (atuin, zoxide, mise, starship, carapace, direnv) come from the home-manager modules. Don't add `init`/`activate` calls to `home/nu.nix`.
- `pkgs/brew.nix` sets `onActivation.cleanup = "zap"` — deleting an entry uninstalls the app on next switch.
- Rose-pine hex values are duplicated inline per module (`btop`, `k9s`, `yazi`, `lazygit`, `atuin`, `herdr`, `git` delta styles, the theme in `home/home.nix`). A palette change means editing each one; there is no shared color attrset.
- Shell is Nushell (`home/nu.nix`); prompt is `home/starship.nix`.
