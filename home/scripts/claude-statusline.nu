#!/usr/bin/env -S nu --stdin

const BASE = "25;23;36"
const MUTED = "110;106;134"
const LOVE = "235;111;146"
const GOLD = "246;193;119"
const ROSE = "234;154;151"
const COPPER = "215;130;126"
const FOAM = "156;207;216"
const IRIS = "196;167;231"
const PINE = "62;143;176"
const OVERLAY = "38;35;58"
const EFFORT_COLORS = {low: $PINE, medium: $FOAM, high: $IRIS, xhigh: $GOLD, max: $LOVE}

# Claude Code's own indent around the status row; COLUMNS is the full terminal width.
const EDGE_MARGIN = 4
const RESET = "\u{1b}[0m"

def fg [rgb: string, --bold] { $"\u{1b}[(if $bold { '1;' })38;2;($rgb)m" }
def join [] { compact --empty | str join " " }
def width [] { ansi strip | str replace --all "⚡" "  " | str length --grapheme-clusters }

def pill [rgb: string, body: string, --solid] {
  let bg = if $solid { $rgb } else { $OVERLAY }
  let text = if $solid { $BASE } else { $rgb }
  $"(fg $bg)\u{e0b6}\u{1b}[1;48;2;($bg);38;2;($text)m($body)($RESET)(fg $bg)\u{e0b4}($RESET)"
}

def rate_limit [window: any, label: string, date_format: string] {
  if ($window.used_percentage? | is-empty) { return }

  let remaining = (100 - $window.used_percentage | math round)
  let color = if $remaining <= 15 { $LOVE } else if $remaining <= 40 { $GOLD } else { $FOAM }
  let reset = if ($window.resets_at? | is-not-empty) {
    let hour = (($window.resets_at | into int) / 3600.0 | math round) * 3600
    $" \u{1b}[22m(fg $MUTED)\(($hour * 1_000_000_000 | into datetime | date to-timezone local | format date $date_format)\)"
  }
  $"(fg $color --bold)($label) ($remaining)%($reset)($RESET)"
}

def main [] {
  let input = (try { $in | from json } catch { {} })
  let vim_mode = $input.vim?.mode?
  let model = ($input.model?.display_name? | default "Claude")
  let added = ($input.cost?.total_lines_added? | default 0)
  let removed = ($input.cost?.total_lines_removed? | default 0)
  let context = $input.context_window?.used_percentage?
  let cost = $input.cost?.total_cost_usd?
  let effort = $input.effort?.level?
  let model_color = if ($effort | is-not-empty) { $EFFORT_COLORS | get -o $effort | default $LOVE } else { $IRIS }

  let left = [
    (pill $model_color $"\u{f09f1} ($model)" --solid)
    (if ($cost | is-not-empty) { pill $COPPER $"⚡\$($cost | into string --decimals 2)" })
    (if $added > 0 { $"(fg $FOAM)\u{f0fe} ($added)($RESET)" })
    (if $removed > 0 { $"(fg $LOVE)\u{f146} ($removed)($RESET)" })
  ] | join

  let right = [
    (if ($context | is-not-empty) and $context >= 60 {
      $"(fg (if $context >= 80 { $LOVE } else { $GOLD }) --bold)\u{f035b} ($context | math round)%($RESET)"
    })
    (rate_limit $input.rate_limits?.five_hour? "5h" "%-I%P")
    (rate_limit $input.rate_limits?.seven_day? "7d" "%a")
    (if ($vim_mode | is-not-empty) {
      let color = match $vim_mode { "INSERT" => $FOAM, "VISUAL" | "VISUAL LINE" => $IRIS, _ => $ROSE }
      pill $color ($vim_mode | str substring 0..0) --solid
    })
  ] | join

  let columns = ($env.COLUMNS? | default "0" | into int)
  let gap = ([1 ($columns - $EDGE_MARGIN - ($left | width) - ($right | width))] | math max)
  print $"($left)('' | fill --width $gap)($right)"
}
