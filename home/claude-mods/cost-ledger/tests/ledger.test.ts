import { expect, test } from 'claude-code/testing'

import { ledgerSql } from '../hooks/ledger'

test('session ids are quoted as SQL literals', async () => {
  const sql = ledgerSql("a'b", 1.5)
  expect(sql).toContain("'a''b'")
  expect(sql).not.toContain("'a'b'")
})

test('cost is written as a number in every statement', async () => {
  const sql = ledgerSql('s', 0.25)
  expect(sql).toContain('WHEN 0.25 < last_cost_usd THEN 0.25 ELSE 0.25 - last_cost_usd')
  expect(sql).toContain('SET last_cost_usd = 0.25')
})

test('non-finite costs are rejected', async () => {
  expect(() => ledgerSql('s', NaN)).toThrow()
  expect(() => ledgerSql('s', Infinity)).toThrow()
})
