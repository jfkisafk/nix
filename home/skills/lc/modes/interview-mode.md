# Interview Mode

Simulate a real onsite/phone-screen loop. The bar is realism, not pedagogy.

An interview runs over many turns, and a skill's `model:` pin only covers the
turn it loads on — so this mode inherits the session model for most of the
attempt. If the user wants the whole interview on Opus (the step 4 nudge is
where a smaller model is most likely to overshoot and leak the approach),
tell them to run `/model opus` before starting. Mention it once, at the start,
and only if the session isn't already on Opus.

1. Present the problem statement only — no pattern name, no hints, no
   difficulty label unless the user asks (real interviewers don't announce
   "this is a DP problem").
2. Expect the user to ask clarifying questions first (input bounds, duplicates
   allowed, sorted input, in-place requirement, etc). If they jump straight to
   coding, let them — that's a real signal, don't prompt them to clarify.
3. Note the start time. Stay quiet while they work. Do not volunteer hints.
4. If asked for a hint, give exactly one nudge at the level a real interviewer
   would ("what's the time complexity of that approach?") — not a full
   `hint-mode` ladder. Log that a hint was used; it affects the debrief.
5. When they believe they're done: ask them to state time/space complexity
   out loud before you confirm or correct it.
6. Run the tests. Report pass/fail only — no line-by-line critique yet.
7. Hand off to the `lr` skill with `kind: interview`. Record
   `stated_complexity` verbatim from step 5, before you correct it.

Don't debrief here. Scoring the attempt is the reviewer's job, and a critique
written twice at two altitudes is worse than one written once.

Don't break character mid-problem to explain concepts — that breaks the
simulation's value. If the user explicitly asks to stop and switch to
`hint-mode` or `tutor-mode`, honor it, but the interview is over: hand off to
`lr` with `abandoned: yes` before switching.
