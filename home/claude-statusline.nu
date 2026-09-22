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

# Upsert this session's latest cumulative cost (idempotent; no double-counting on repeat renders).
# MTD is SUM(cost_usd) at read time in home/starship.nix -> custom.llm_cost. Keep both paths in sync.
def update_cost_mtd [input: record] {
  let cost_usd = ($input | get -o cost.total_cost_usd)
  let session_id = ($input | get -o session_id)
  if ($cost_usd | is-empty) or ($session_id | is-empty) { return null }

  let db = $"($env.HOME)/.claude/cost.db"
  mkdir ($db | path dirname)
  let sid = ($session_id | str replace --all "'" "''")
  let month = (date now | format date '%Y-%m') # fixed at first write; a session spanning a month boundary stays in its starting month

  ^sqlite3 $db $"CREATE TABLE IF NOT EXISTS session_cost \(session_id TEXT PRIMARY KEY, month TEXT NOT NULL, cost_usd REAL NOT NULL\);
INSERT INTO session_cost VALUES\('($sid)', '($month)', ($cost_usd | into float)\) ON CONFLICT\(session_id\) DO UPDATE SET cost_usd = excluded.cost_usd;"
  true
}

def cache_icon [status: any] {
  if $status == null {
    ""
  } else if $status {
    $" (color_for 100)󰹍\u{1b}[0m"
  } else {
    $" (color_for 0)󰹍\u{1b}[0m"
  }
}

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

  let cache_status = (try { update_cost_mtd $input } catch { false })

  let five_hour = ($input | get -o rate_limits.five_hour)
  let seven_day = ($input | get -o rate_limits.seven_day)

  let extra = (rate_limit_segment ($five_hour | get -o used_percentage) "5h" ($five_hour | get -o resets_at) "%-I%P") + (rate_limit_segment ($seven_day | get -o used_percentage) "7d" ($seven_day | get -o resets_at) "%a")

  print $"($base)(cache_icon $cache_status)($extra)"
}
