#!/usr/bin/env -S nu --stdin

# Flat bold-color style, matching claude_model/claude_cost's default rendering
# (no overlay pill background - those modules don't use $style pill decoration)
def color_for [remaining: number] {
  if $remaining <= 10 {
    "\u{1b}[1;38;2;235;111;146m" # love: critical
  } else if $remaining <= 30 {
    "\u{1b}[1;38;2;246;193;119m" # gold: warn
  } else {
    "\u{1b}[1;38;2;156;207;216m" # foam: ok
  }
}

def rate_limit_segment [pct: any, label: string] {
  if ($pct | is-empty) {
    ""
  } else {
    let remaining = (100 - $pct | math round)
    let reset = "\u{1b}[0m"
    $" (color_for $remaining)($label) ($remaining)%($reset)"
  }
}

def main [] {
  let raw = ($in | default "{}")
  let input = (try { $raw | from json } catch { {} })
  let base = ($raw | starship statusline claude-code | str trim)

  let five_hour = ($input | get -o rate_limits.five_hour.used_percentage)
  let seven_day = ($input | get -o rate_limits.seven_day.used_percentage)

  let extra = (rate_limit_segment $five_hour "5h") + (rate_limit_segment $seven_day "7d")

  print $"($base)($extra)"
}
