#!/usr/bin/env -S nu --stdin

def main [] {
  let raw = ($in | default "{}")
  let input = (try { $raw | from json } catch { {} })

  # 1. Parse Model Name (handle record or string safely)
  let model_val = ($input | get -o model)
  let model = if ($model_val | describe | str starts-with "record") {
    ($model_val | get -o display_name | default ($model_val | get -o id | default "Gemini"))
  } else if ($model_val | describe | str starts-with "string") {
    $model_val
  } else {
    "Gemini"
  } | str replace -r "(?i)^(Google |gemini-|Gemini )" ""

  # 2. Parse Quota (extract remaining_fraction from bucket map)
  let quota_val = ($input | get -o quota)
  let quota_fraction = if ($quota_val | describe | str starts-with "record") {
    let vals = ($quota_val | values)
    if ($vals | is-not-empty) and (($vals | first | describe | str starts-with "record")) {
      ($vals | first | get -o remaining_fraction | default 1.0)
    } else {
      ($quota_val | get -o remaining_fraction | default 1.0)
    }
  } else {
    1.0
  }
  let quota_pct = (if $quota_fraction <= 1.0 { $quota_fraction * 100 } else { $quota_fraction } | math round)

  # 3. Parse Context Window Usage
  let ctx_val = ($input | get -o context_window)
  let ctx_str = if ($ctx_val | is-not-empty) and ($ctx_val | describe | str starts-with "record") {
    if ($ctx_val | get -o used_percentage | is-not-empty) {
      let pct = ($ctx_val | get used_percentage)
      let num = if $pct <= 1.0 { $pct * 100 } else { $pct } | math round
      $"($num)%"
    } else if ($ctx_val | get -o total_input_tokens | is-not-empty) {
      let tokens = (($ctx_val | get total_input_tokens) + ($ctx_val | get -o total_output_tokens | default 0))
      let k = ($tokens / 1000 | math round)
      $"($k)k"
    } else {
      "0%"
    }
  } else {
    "0%"
  }

  # 4. Rose Pine Foreground Colors (bold)
  let fg_iris = "\u{1b}[1;38;2;196;167;231m" # #c4a7e7
  let fg_rose = "\u{1b}[1;38;2;234;154;151m" # #ea9a97
  let fg_foam = "\u{1b}[1;38;2;156;207;216m" # #9ccfd8
  let reset   = "\u{1b}[0m"

  # Render clean format
  print $"($fg_iris)󰧱 ($model)($reset)  ($fg_rose)󰴈 ($quota_pct)%($reset)  ($fg_foam)󰍛 ($ctx_str)($reset)"
}
