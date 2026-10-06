#!/usr/bin/env -S nu --stdin

const MUTED = "110;106;134"
const LOVE = "235;111;146"
const GOLD = "246;193;119"
const ROSE = "234;154;151"
const FOAM = "156;207;216"
const IRIS = "196;167;231"

# Claude Code's own indent around the status row; COLUMNS is the full terminal width.
const EDGE_MARGIN = 4
const SEVEN_DAY_SHOW_BELOW = 40

def paint [rgb: string, text: string, --bold] { $"\u{1b}[(if $bold { '1;' })38;2;($rgb)m($text)\u{1b}[0m" }
def join [] { compact --empty | str join " " }
def width [] { ansi strip | str replace --all "⚡" "  " | str length --grapheme-clusters }

def remaining [window: any] { 100 - ($window.used_percentage? | default 0) | math round }
def quota_color [remaining: number] { if $remaining <= 15 { $LOVE } else if $remaining <= 40 { $GOLD } else { $FOAM } }

def rate_limit [window: any, label: string, date_format: string] {
  if ($window.used_percentage? | is-empty) { return }

  let left = (remaining $window)
  let reset = if ($window.resets_at? | is-not-empty) {
    let hour = (($window.resets_at | into int) / 3600.0 | math round) * 3600
    paint $MUTED ($hour * 1_000_000_000 | into datetime | date to-timezone local | format date $date_format | str replace --regex 'm$' '')
  }
  [(paint (quota_color $left) $"($label) ($left)%" --bold) $reset] | join
}

def main [] {
  let input = (try { $in | from json } catch { {} })

  let model_name = ($input.model?.display_name? | default "Claude")
  let family = (["opus" "sonnet" "haiku" "fable"] | where {|family| $model_name | str lowercase | str contains $family } | get -o 0)
  let model = if ($family | is-not-empty) { $family | str capitalize } else { $model_name }

  let cost = $input.cost?.total_cost_usd?
  let five_hour = $input.rate_limits?.five_hour?
  let seven_day = $input.rate_limits?.seven_day?
  let quotas = [
    (rate_limit $five_hour "5h" "%-I%P")
    (if (remaining $seven_day) <= $SEVEN_DAY_SHOW_BELOW { rate_limit $seven_day "7d" "%a" })
  ] | join

  let left = [
    (paint $IRIS $"\u{f09f1} ($model)" --bold)
    (if ($cost | is-not-empty) {
      let color = if $cost >= 15 { $LOVE } else if $cost >= 5 { $ROSE } else { $GOLD }
      paint $color $"⚡\$($cost | into string --decimals 2)" --bold
    })
    (if ($quotas | is-not-empty) {
      let lowest = ([(remaining $five_hour) (remaining $seven_day)] | math min)
      [(paint (quota_color $lowest) "\u{f04c5}" --bold) $quotas] | join
    })
  ] | join

  let context = ($input.context_window?.used_percentage? | default 0)
  let context_color = if $context >= 80 { $LOVE } else if $context >= 60 { $GOLD } else { $MUTED }
  let added = ($input.cost?.total_lines_added? | default 0)
  let removed = ($input.cost?.total_lines_removed? | default 0)
  let vim_mode = $input.vim?.mode?

  let right = [
    (if ($input.context_window?.context_window_size? | default 1_000_000) < 1_000_000 { paint $context_color "\u{f0875}" --bold })
    (if $context >= 60 { paint $context_color $"\u{f035b} ($context | math round)%" --bold })
    (if $added > 0 { paint $FOAM $"\u{f0fe} ($added)" })
    (if $removed > 0 { paint $LOVE $"\u{f146} ($removed)" })
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