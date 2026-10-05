#!/usr/bin/env -S nu --stdin

# Layout mirrors nvim's lualine: mode/branch pills, diff, dir | alerts, cost, effort pill.

const BASE = "25;23;36"
const TEXT = "224;222;244"
const MUTED = "110;106;134"
const LOVE = "235;111;146"
const GOLD = "246;193;119"
const ROSE = "234;154;151"
const FOAM = "156;207;216"
const IRIS = "196;167;231"
const PINE = "62;143;176"
const EFFORT_COLORS = {low: $PINE, medium: $FOAM, high: $IRIS, xhigh: $GOLD, max: $LOVE}

# Claude Code's own indent around the status row; COLUMNS is the full terminal width.
const EDGE_MARGIN = 4

const RESET = "\u{1b}[0m"

def fg [rgb: string, --bold] { $"\u{1b}[(if $bold { '1;' })38;2;($rgb)m" }

def pill [rgb: string, body: string, --italic] {
  $"(fg $rgb)\u{e0b6}\u{1b}[1;(if $italic { '3;' })48;2;($rgb);38;2;($BASE)m ($body) ($RESET)(fg $rgb)\u{e0b4}($RESET)"
}

def join [] { compact --empty | str join " " }

def width [] { ansi strip | str length --grapheme-clusters }

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
  let color = match $vim_mode { "INSERT" => $FOAM, "VISUAL" | "VISUAL LINE" => $IRIS, _ => $ROSE }
  let model = ($input.model?.display_name? | default "Claude")
  let dir = $input.workspace?.current_dir?
  let git = if ($dir | is-not-empty) { ^git -C $dir branch --show-current | complete }
  let added = ($input.cost?.total_lines_added? | default 0)
  let removed = ($input.cost?.total_lines_removed? | default 0)
  let context = $input.context_window?.used_percentage?
  let cost = $input.cost?.total_cost_usd?
  let effort = $input.effort?.level?

  let left = [
    (pill $color (if ($vim_mode | is-empty) { $model } else { $"($vim_mode | str substring 0..0) ($model)" }))
    (if $git.exit_code? == 0 and ($git.stdout | str trim | is-not-empty) { pill $color $"\u{f418} ($git.stdout | str trim)" })
    (if $added > 0 { $"(fg $FOAM)\u{f0fe} ($added)($RESET)" })
    (if $removed > 0 { $"(fg $LOVE)\u{f146} ($removed)($RESET)" })
    (if ($dir | is-not-empty) { $"(fg $TEXT)($dir | path basename)($RESET)" })
  ] | join

  let right = [
    (if ($context | is-not-empty) and $context >= 60 {
      $"(fg (if $context >= 80 { $LOVE } else { $GOLD }) --bold)\u{f035b} ($context | math round)%($RESET)"
    })
    (rate_limit $input.rate_limits?.five_hour? "5h" "%-I%P")
    (rate_limit $input.rate_limits?.seven_day? "7d" "%a")
    (if ($cost | is-not-empty) { $"(fg $GOLD --bold)\u{f0d08} \$($cost | into string --decimals 2)($RESET)" })
    (if ($effort | is-not-empty) { pill ($EFFORT_COLORS | get -o $effort | default $LOVE) $"\u{f09d1} ($effort)" --italic })
  ] | join

  if ($right | is-empty) { print $left; return }

  let columns = ($env.COLUMNS? | default "0" | into int)
  let gap = ([1 ($columns - $EDGE_MARGIN - ($left | width) - ($right | width))] | math max)
  print $"($left)('' | fill --width $gap)($right)"
}
