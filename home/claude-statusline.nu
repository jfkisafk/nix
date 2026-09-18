#!/usr/bin/env -S nu --stdin

# Flat bold-color style, matching claude_model/claude_cost's default rendering
# (no overlay pill background - those modules don't use $style pill decoration)
def color_for [remaining: number] {
  if $remaining <= 15 {
    "\u{1b}[1;38;2;235;111;146m" # love: critical
  } else if $remaining <= 40 {
    "\u{1b}[1;38;2;234;154;151m" # rose: warn
  } else {
    "\u{1b}[1;38;2;156;207;216m" # foam: ok
  }
}

def pine [] { "\u{1b}[1;38;2;62;143;176m" } # pine: absolute reset time

def format_reset [resets_at: any, date_format: string] {
  if ($resets_at | is-empty) { return "" }

  let rounded_hour = (($resets_at | into int) / 3600.0 | math round) * 3600
  let dt = ($rounded_hour * 1_000_000_000 | into datetime | date to-timezone local)
  $" (pine)\(($dt | format date $date_format)\)"
}

def rate_limit_segment [pct: any, label: string, resets_at: any, date_format: string] {
  if ($pct | is-empty) { return "" }

  let remaining = (100 - $pct | math round)
  let reset = "\u{1b}[0m"
  $" (color_for $remaining)($label) ($remaining)%(format_reset $resets_at $date_format)($reset)"
}

def main [] {
  let raw = ($in | default "{}")
  let input = (try { $raw | from json } catch { {} })
  let base = ($raw | starship statusline claude-code | str trim)

  let five_hour = ($input | get -o rate_limits.five_hour)
  let seven_day = ($input | get -o rate_limits.seven_day)

  let extra = (rate_limit_segment ($five_hour | get -o used_percentage) "5h" ($five_hour | get -o resets_at) "%-I%P") + (rate_limit_segment ($seven_day | get -o used_percentage) "7d" ($seven_day | get -o resets_at) "%a")

  print $"($base)($extra)"
}
