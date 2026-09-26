let db = $"($env.HOME)/.claude/cost.db"
let month = (date now | format date '%Y-%m')
# Real sqlite errors hide the module (exit 1); only "no db yet" is a genuine $0.00.
let val = if ($db | path exists) {
  # `-cmd ".timeout"`, not `PRAGMA busy_timeout`, so the timeout setting never writes to
  # stdout and gets mistaken for the query result.
  let out = (try { ^sqlite3 -cmd ".timeout 5000" $db $"SELECT cost_usd FROM monthly_cost WHERE month = '($month)';" e> /dev/null | str trim } catch { null })
  if $out == null { null } else if ($out | is-empty) { "0" } else { $out }
} else { "0" }
if $val == null { exit 1 }
let amount = (try { $val | into float } catch { null })
if $amount == null { exit 1 }
print ("$" + ($amount | into string -d 2))