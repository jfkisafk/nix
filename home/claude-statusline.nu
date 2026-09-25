#!/usr/bin/env -S nu --stdin

# Bold flat colors to match starship's claude_model/claude_cost modules.
def color_for [remaining: number] {
  if $remaining <= 15 {
    "\u{1b}[1;38;2;235;111;146m" # love
  } else if $remaining <= 40 {
    "\u{1b}[1;38;2;234;154;151m" # rose
  } else {
    "\u{1b}[1;38;2;156;207;216m" # foam
  }
}

def pine [] { "\u{1b}[1;38;2;62;143;176m" } # pine

# total_cost_usd is a running per-session total, so only the delta since the last reading is added.
# A reading below the baseline means a resumed session, which is counted in full.
# starship.nix (custom.llm_cost) reads monthly_cost directly; keep the schema in sync.
def update_cost_mtd [input: record] {
  let cost_usd = ($input | get -o cost.total_cost_usd)
  let session_id = ($input | get -o session_id)
  if ($cost_usd | is-empty) or ($session_id | is-empty) { return null }

  let db = $"($env.HOME)/.claude/cost.db"
  mkdir ($db | path dirname)
  let sid = ($session_id | str replace --all "'" "''")
  let month = (date now | format date '%Y-%m')
  let new_cost = ($cost_usd | into float)

  ^sqlite3 $db $"PRAGMA busy_timeout = 5000;
BEGIN IMMEDIATE;
CREATE TABLE IF NOT EXISTS session_state \(session_id TEXT PRIMARY KEY, last_cost_usd REAL NOT NULL, last_month TEXT NOT NULL\);
CREATE TABLE IF NOT EXISTS monthly_cost \(month TEXT PRIMARY KEY, cost_usd REAL NOT NULL\);
INSERT INTO session_state \(session_id, last_cost_usd, last_month\) VALUES\('($sid)', 0, '($month)'\)
ON CONFLICT\(session_id\) DO NOTHING;
INSERT INTO monthly_cost \(month, cost_usd\)
  SELECT '($month)', CASE WHEN ($new_cost) < last_cost_usd THEN ($new_cost) ELSE ($new_cost) - last_cost_usd END FROM session_state WHERE session_id = '($sid)'
ON CONFLICT\(month\) DO UPDATE SET cost_usd = cost_usd + excluded.cost_usd;
UPDATE session_state SET last_cost_usd = ($new_cost), last_month = '($month)' WHERE session_id = '($sid)';
DELETE FROM monthly_cost WHERE month < strftime\('%Y-%m', 'now', '-12 months'\);
DELETE FROM session_state WHERE last_month < strftime\('%Y-%m', 'now', '-12 months'\);
COMMIT;" o+e> /dev/null
  true
}

def cache_icon [status: any] {
  if $status == false {
    $" (color_for 0)󰀩\u{1b}[0m"
  } else {
    ""
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
