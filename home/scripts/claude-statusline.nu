#!/usr/bin/env -S nu --stdin

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

def paint [rgb: string, text: string, --bold] { $"\u{1b}[(if $bold { '1;' })38;2;($rgb)m($text)\u{1b}[0m" }
def join [] { compact --empty | str join " " }
def width [] { ansi strip | str replace --all "⚡" "  " | str length --grapheme-clusters }

def rate_limit [window: any, label: string, date_format: string] {
  if ($window.used_percentage? | is-empty) { return }

  let remaining = (100 - $window.used_percentage | math round)
  let color = if $remaining <= 15 { $LOVE } else if $remaining <= 40 { $GOLD } else { $FOAM }
  let reset = if ($window.resets_at? | is-not-empty) {
    let hour = (($window.resets_at | into int) / 3600.0 | math round) * 3600
    paint $MUTED $"\(($hour * 1_000_000_000 | into datetime | date to-timezone local | format date $date_format)\)"
  }
  [(paint $color $"($label) ($remaining)%" --bold) $reset] | join
}

def main [] {
  let input = (try { $in | from json } catch { {} })

  let model_name = ($input.model?.display_name? | default "Claude")
  let family = (["opus" "sonnet" "haiku" "fable"] | where {|family| $model_name | str lowercase | str contains $family } | get -o 0)
  let model = if ($family | is-not-empty) { $family | str capitalize } else { $model_name }
  let effort = $input.effort?.level?
  let model_color = if ($effort | is-not-empty) { $EFFORT_COLORS | get -o $effort | default $LOVE } else { $IRIS }

  let cost = $input.cost?.total_cost_usd?
  let added = ($input.cost?.total_lines_added? | default 0)
  let removed = ($input.cost?.total_lines_removed? | default 0)
  let diff = [
    (if $added > 0 { paint $FOAM $"\u{f0fe} ($added)" })
    (if $removed > 0 { paint $LOVE $"\u{f146} ($removed)" })
  ] | join

  let left = [
    (paint $model_color $"\u{f09f1} ($model)" --bold)
    (if ($cost | is-not-empty) {
      let color = if $cost >= 15 { $LOVE } else if $cost >= 5 { $ROSE } else { $GOLD }
      paint $color $"⚡\$($cost | into string --decimals 2)" --bold
    })
    (if ($diff | is-not-empty) { $"(paint $MUTED '│') ($diff)" })
  ] | join

  let context = ($input.context_window?.used_percentage? | default 0)
  let context_size = $input.context_window?.context_window_size?
  let context_color = if $context >= 80 { $LOVE } else if $context >= 60 { $GOLD } else { $MUTED }
  let vim_mode = $input.vim?.mode?

  let right = [
    (if ($context_size | is-not-empty) and $context_size < 1_000_000 { paint $context_color "\u{f0875}" --bold })
    (if $context >= 60 { paint $context_color $"\u{f035b} ($context | math round)%" --bold })
    (rate_limit $input.rate_limits?.five_hour? "5h" "%-I%P")
    (rate_limit $input.rate_limits?.seven_day? "7d" "%a")
    (if ($vim_mode | is-not-empty) {
      let mode = match $vim_mode {
        "NORMAL" => [$ROSE "\u{e62b}"]
        "INSERT" => [$FOAM "\u{f040}"]
        "VISUAL" => [$IRIS "\u{f0485}"]
        "VISUAL LINE" => [$IRIS "\u{f0571}"]
        _ => [$ROSE ($vim_mode | str substring 0..0)]
      }
      paint $mode.0 $mode.1 --bold
    })
  ] | join

  let columns = ($env.COLUMNS? | default "0" | into int)
  let gap = ([1 ($columns - $EDGE_MARGIN - ($left | width) - ($right | width))] | math max)
  print $"($left)('' | fill --width $gap)($right)"
}
