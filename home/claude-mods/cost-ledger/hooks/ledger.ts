// total cost is a running per-session total, so only the delta since the last reading is added.
// A reading below the baseline means a resumed session, which is counted in full.
// home/scripts/llm-cost.nu reads monthly_cost directly; keep the schema in sync.
export const ledgerSql = (sessionId: string, costUsd: number): string => {
  if (!Number.isFinite(costUsd)) throw new Error(`bad cost: ${costUsd}`);
  const sid = sessionId.replaceAll("'", "''");
  const cost = costUsd;
  const month = "strftime('%Y-%m', 'now', 'localtime')";

  return `BEGIN IMMEDIATE;
CREATE TABLE IF NOT EXISTS session_state (session_id TEXT PRIMARY KEY, last_cost_usd REAL NOT NULL, last_month TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS monthly_cost (month TEXT PRIMARY KEY, cost_usd REAL NOT NULL);
INSERT INTO session_state (session_id, last_cost_usd, last_month) VALUES ('${sid}', 0, ${month})
ON CONFLICT(session_id) DO NOTHING;
INSERT INTO monthly_cost (month, cost_usd)
  SELECT ${month}, CASE WHEN ${cost} < last_cost_usd THEN ${cost} ELSE ${cost} - last_cost_usd END FROM session_state WHERE session_id = '${sid}'
ON CONFLICT(month) DO UPDATE SET cost_usd = cost_usd + excluded.cost_usd;
UPDATE session_state SET last_cost_usd = ${cost}, last_month = ${month} WHERE session_id = '${sid}';
DELETE FROM monthly_cost WHERE month < strftime('%Y-%m', 'now', '-12 months');
DELETE FROM session_state WHERE last_month < strftime('%Y-%m', 'now', '-12 months');
COMMIT;`;
};
