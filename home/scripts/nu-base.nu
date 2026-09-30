let carapace_completer = {|spans|
  carapace $spans.0 nushell ...$spans | from json
}

let fish_completer = {|spans|
  fish --command $'complete "--do-complete=($spans | str join " ")"'
    | from tsv --flexible --noheaders --no-infer
    | rename value description
}

let zoxide_completer = {|spans|
  $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

# This completer will use carapace by default
let external_completer = {|spans|
  let expanded_alias = scope aliases
  | where name == $spans.0
  | get -o 0.expansion

  let spans = if $expanded_alias != null {
    $spans
    | skip 1
    | prepend ($expanded_alias | split row ' ' | take 1)
  } else {
    $spans
  }

  match $spans.0 {
    # carapace completions are incorrect for nu
    nu => $fish_completer
    # fish completes commits and branch names in a nicer way
    git => $fish_completer
    # use zoxide completions for zoxide commands
    __zoxide_z | __zoxide_zi | cd | cdi => $zoxide_completer
    # carapace only bridges commands with a completion file; fish also
    # parses --help on the fly (e.g. claude), so fall back to it
    _ => {|spans|
      let completions = do $carapace_completer $spans
      if ($completions | is-empty) { do $fish_completer $spans } else { $completions }
    }
  } | do $in $spans
}

# assign fields, not the whole record, to keep hooks added by integrations (mise)
$env.config.show_banner = false
$env.config.completions.external = { enable: true, completer: $external_completer }
$env.config.keybindings ++= [
  {
    name: open_herdr_session
    modifier: Control
    keycode: char_t
    mode: [emacs, vi_normal, vi_insert]
    event: { send: executehostcommand, cmd: "herdr" }
  }
]

# superfile writes `cd '<dir>'` on quit (cd_on_quit in superfile.nix).
# --print-last-dir can't be used: capturing stdout swallows the TUI.
def --env y [...args] {
  ^superfile ...$args
  let lastdir = (^superfile pl --lastdir-file | str trim)
  if ($lastdir | path exists) {
    cd (open --raw $lastdir | str replace -r "^cd '(.*)'$" '$1')
    rm $lastdir
  }
}
