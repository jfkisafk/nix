import type { EngineInterface, Register } from 'claude-code'

import { ledgerSql } from './ledger'

// Absolute so sessions the desktop app starts, with a bare PATH, still find it.
const SQLITE = '/run/current-system/sw/bin/sqlite3'

const record = async ($: EngineInterface, sessionId: string) => {
  const { cost } = await $.session.usage()
  if (cost === undefined) return

  try {
    const home = await $.env.get('HOME')
    const { exitCode, stderr } = await $.process.run([SQLITE, '-cmd', '.timeout 5000', `${home}/.claude/cost.db`], {
      stdin: ledgerSql(sessionId, cost.usd),
    })
    $.ui.status(exitCode === 0 ? undefined : `cost ledger: ${stderr.trim().slice(0, 60)}`)
  } catch (error) {
    $.ui.status(`cost ledger: ${String(error).slice(0, 60)}`)
  }
}

export const register: Register = on => {
  on('turn.complete', async ($, e, next) => {
    await record($, await $.session.id())
    return next(e)
  })

  // Catches spend after the last turn, such as a /compact right before /exit.
  on('session.end', async ($, e, next) => {
    await record($, e.sessionId)
    return next(e)
  })
}
