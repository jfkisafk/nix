# AGENTS.md

`nix-darwin` + `home-manager` flake for one Mac: host `darkstar`, user `stelo`, `aarch64-darwin`. Rose-pine themed; language runtimes come from `mise`, not nixpkgs.

## Commands

```sh
sudo darwin-rebuild switch   # apply everything (system, brew, fonts, home)
sudo darwin-rebuild check    # evaluate without applying
nix eval --raw .#darwinConfigurations.darkstar.config.system.build.toplevel.drvPath   # evaluate without root; run from repo root
```

`darwin-rebuild` needs no `--flake`: `hosts/darkstar/configuration.nix` links `/etc/nix-darwin` to this repo and the hostname selects `darkstar`. There is no standalone `home-manager switch` — home-manager is a darwin module, so **every** change under `home/` needs `sudo darwin-rebuild switch`.

No tests, no linter. `nix fmt` runs `nixfmt`; `.githooks/pre-commit` runs it on staged `.nix` files and restages them (enable once per clone with `git config core.hooksPath .githooks`). CI is `.github/workflows/gitleaks.yml` (secret scan) only.

## home/

`home/home.nix` holds `home.file` (static dotfiles: rose-pine Claude theme, `scripts/claude-statusline.nu`, `.config/karabiner/karabiner.json`, `.config/nvim` as an out-of-store symlink to `/Volumes/nitro/nvim`, `.config/tuicr` from `home/tuicr/`) and a `programs` block of one-line imports.

`home/tuicr/` mirrors `~/.config/tuicr` (config plus the local `themes/rose-pine.toml`) and is linked with `recursive = true`, so the directory stays writable. tuicr has no home-manager module; its package is in `pkgs/system.nix`. New files there need `git add` before switching.

`home/claude-mods/` holds Claude Code mods (TypeScript hook plugins), each linked to `~/.claude/mods/<name>` and loaded through `CLAUDE_CODE_PLUGIN_DIRS` in `home/claude.nix`. Link a mod as a whole directory, never with `recursive = true`: Claude Code refuses to load plugin files that resolve outside the plugin directory, and per-file links resolve into the store. New files need `git add` before switching. `cost-ledger` adds each session's spend to `~/.claude/cost.db`, which `llm-cost.nu` reads; it calls the `sqlite` from `pkgs/system.nix` by absolute path. Run `claude plugin validate` and `claude plugin test` on a mod folder after editing it.

`home/scripts/` holds Nushell scripts referenced by path from modules: `claude-statusline.nu` (linked into `~/.claude`), `nu-base.nu` (sourced by `home/nu.nix`) and `llm-cost.nu` (sourced by the starship `custom.llm_cost` module). Put script bodies there rather than inline in a module.

`home/skills/` is `programs.claude-code.skills`: each subdirectory is one Claude Code skill, copied into `~/.claude/skills/<name>/`. Add a skill by adding a directory with a `SKILL.md`; no Nix edit needed, but `git add` it before switching or the flake won't see it. Edits need `sudo darwin-rebuild switch`. Claude Code triggers a skill from its frontmatter `description` alone, so treat edits to it as behavior changes. The `model:` pin applies only to the turn the skill loads in.

`lc` and `lr` are one LeetCode practice loop that operates on a separate repo (`$LEETCODE_DIR`, or an ancestor containing `template/solution.py`). `lc` (Sonnet) drives sessions and routes to `lc/modes/*.md`; `lr` (Opus) grades finished work and must finish review and bookkeeping in one response. Keep these invariants:

- Only `lr` writes `REVIEW.md` and computes intervals (ladder `1→3→7→14→30`, jitter at rung 7+). `PROBLEMS.md` has two writers: `lr` checks boxes, `pattern-mapper-mode` appends problems.
- `lc` hands off to `lr` through the labeled block defined in `lc/SKILL.md` "Handing off to `lr`", every field filled even when zero. Change both sides together.
- Each rule lives in one file, except `lr` keeps its own copy of repo resolution and the `REVIEW.md` schema because it can be invoked cold.
- `lc` never shows a full solution outside `tutor-mode` or the last `hint-mode` rung. Rung 4, tutor use on the problem in flight, and leaving an interview early are hard lapses.

`home/scripts/nu-base.nu` holds the Nushell config that repos building on this flake can reuse: external completers, herdr keybinding, superfile `y`. They `source` it from their own config, as `home/nu.nix` does. It must come after carapace's init, which also sets `completions.external`; a module's plain `extraConfig` already lands there. Machine-specific Nushell config (PATH, aliases, env) stays in `home/nu.nix`.

`home/karabiner.nix` is not a program module: it returns a `writeText` derivation linked as `.config/karabiner/karabiner.json` from `home.file`, leaving the directory writable for Karabiner-Elements.

Each `home/<file>.nix` is `{ ... }: { enable = true; ... }`, or `{ pkgs, ... }:` if it references `pkgs` — the attrset *is* the value of `programs.<name>`. The attr name is not always the filename: `claude-code`→`claude.nix`, `awscli`→`aws.nix`, `nushell`→`nu.nix`.

Add a program: write `home/<file>.nix`, then add `<name> = import ./<file>.nix { };` to `programs` in `home/home.nix`, passing `{ inherit pkgs; }` only if the module takes `pkgs`. Copy `home/bat.nix` (minimal) or `home/git.nix` (full) for shape.

`opencode.nix` reads the engineering and technical-writing rules from `claude.nix`; edit them there only.

`home/activation.nix` is the exception — `home.activation`, imported with `{ inherit pkgs lib; }`, entries are `lib.hm.dag.entryAfter ["writeBoundary"] ''…''`. Runs on every switch: SSH keygen + `gh ssh-key add`, `chsh` to `nu`, `mise upgrade`/`prune` against the tool list in `home/mise.nix`, and installing the `vim-herdr-navigation` herdr plugin that `home/herdr.nix` binds to ctrl+hjkl. Entries that read files written by home-manager use `entryAfter ["linkGeneration"]`.

## Conventions

- New package: nixpkgs CLI → `pkgs/system.nix`; GUI/brew-only → `pkgs/brew.nix`. Language runtimes go in `globalConfig.tools` in `home/mise.nix` — never in nixpkgs or brew.
- A tool with a `home/<file>.nix` module gets its package from `programs.<name>.enable`; don't also list it in `pkgs/system.nix`.
- Shell integrations (atuin, zoxide, mise, starship, carapace, direnv) come from the home-manager modules. Don't add `init`/`activate` calls to `home/nu.nix`.
- `pkgs/brew.nix` sets `onActivation.cleanup = "zap"` — deleting an entry uninstalls the app on next switch.
- Rose-pine hex values are duplicated inline per module (`btop`, `k9s`, `lazygit`, `atuin`, `herdr`, `git` delta styles, the theme in `home/home.nix`, `home/tuicr/themes/rose-pine.toml`). A palette change means editing each one; there is no shared color attrset.
- Shell is Nushell (`home/nu.nix` + `home/scripts/nu-base.nu`); prompt is `home/starship.nix`.
