---
name: lr
description: Reviews a finished LeetCode/DSA solution — time and space complexity, whether it's optimal, what approach beats it — then grades the attempt and updates the spaced-repetition schedule. Use when the user says they're done and asks to "review my solution" or "grade this", pastes a finished solution cold, or when the `lc` skill hands off a completed, abandoned, or rung-4 attempt or an interview debrief. Complexity or optimality questions about code the user is still working on belong to `lc`.
model: opus
effort: medium
---

# LeetCode Solution Review — `/lr`

The judgment half of the practice loop — `lc` drives the session, this skill
does the part that degrades on a smaller model: complexity analysis, the
optimality verdict, and the grade that moves the review schedule. Input is a
finished attempt, either as `lc`'s handoff block or pasted in cold with no
session behind it.

The review and the bookkeeping happen in a single response — this skill's
Opus pin lasts for the current turn only, so anything deferred to a follow-up
turn drops back to the session model. Never stop to ask a question or for
permission before bookkeeping; each gap below has a default instead.

## Locating the repo

State lives in the practice repo, not here. Resolve its root:

1. If `LEETCODE_DIR` is set, use it.
2. Else if the current directory (or an ancestor) contains
   `template/solution.py`, use that directory.
3. Else do the review only, skip bookkeeping, and tell the user to set
   `LEETCODE_DIR` and re-run `/lr`.

`REVIEW.md` at that root is the spaced-repetition table:

| Problem    | Pattern    | Last Done  | Next Review | Interval (d) | Streak |
| ---------- | ---------- | ---------- | ----------- | ------------ | ------ |
| 1. Two Sum | Hash Table | 2026-09-01 | 2026-09-04  | 3            | 2      |

`PROBLEMS.md` is the queue, one checkbox per problem. Create either with
headers if missing — don't block on it. Get today's date from
`date +%Y-%m-%d`, never from memory.

## Cold pastes

With no handoff block there is no session record:

- Identify the problem and its slug. If `test/test_<slug>.py` exists and
  `src/<slug>.py` is tracked with no uncommitted changes (or doesn't exist),
  write the pasted code to `src/<slug>.py` so the tests run against it.
  Otherwise don't overwrite anything — review by reasoning and say the tests
  weren't run.
- Hint usage is unknown, so grade it as a **soft lapse** and say so in the
  one-line schedule note, so the user can correct it.

## Review

Skip to "Rung 4 and abandoned attempts" below if the handoff says
`hint_rung: 4` or `abandoned: yes`.

1. Run the tests (`poetry run pytest test/test_<slug>.py -v`). If they fail,
   report the failing case and stop — the attempt is still open, so don't
   grade it or touch the tracking files; control goes back to `lc`.
2. If they pass, state:
   - Time complexity (best/average/worst if they differ) and space complexity,
     with the one-line reason a simpler approach doesn't hit the same bound.
   - Whether this is optimal for the problem, and if not, the approach that
     is and why (name it; only show its code if asked).
   - One concrete thing done well — skip if genuinely nothing stands out,
     don't manufacture praise.
3. The committed tests use tiny inputs, so a passing suite says nothing about
   behaviour at the problem's stated constraints. Before calling a solution
   correct, check the worst case yourself — recursion depth against the
   maximum input size, and any bound that only bites at 10^4+ elements.
   Run it if it's cheap to construct; say so explicitly if you only reasoned
   about it.
4. Compare against the user's own prior attempts at this problem if
   `REVIEW.md` shows one — "faster than your July attempt" is more useful
   than an isolated verdict.

## Rung 4 and abandoned attempts

The tests are failing by definition here, so skip the test gate.

- **`hint_rung: 4`** — show the optimal solution's code with the complexity
  analysis from step 2 above, then point at where the user's attempt
  diverged from it.
- **`abandoned: yes`** — name the optimal approach; show code only if asked.

## Bookkeeping

The ladder is `1 → 3 → 7 → 14 → 30` days, capped at 30. Always move along
it; never compute the next interval by doubling.

Grade from the handoff fields, taking the worst row that applies:

| Grade           | What happened                                                         | Interval       | Streak |
| --------------- | --------------------------------------------------------------------- | -------------- | ------ |
| **Clean**       | No hints, no nudges, no tutor-mode                                    | up one rung    | `+= 1` |
| **Soft lapse**  | Highest hint rung 1, or one interview nudge                           | down one rung  | `0`    |
| **Lapse**       | Highest hint rung 2 or 3, or two or more interview nudges             | down two rungs | `0`    |
| **Hard lapse**  | Hint rung 4, tutor-mode during the attempt, or abandoned the attempt  | `1`            | `0`    |

Moving down bottoms out at rung 1: down one is `30 → 14 → 7 → 3 → 1`; down
two is `30 → 7`, `14 → 3`, `7 → 1`, `3 → 1`.

Grade only material the user forgot. A defect that earlier passes never
flagged (weak naming, a missing edge case nobody raised) is feedback, not a
lapse; it doesn't move the interval down.

A new row is always `Interval = 1`, since first exposure has no rung to fall
from. `Streak` is `1` if the first attempt was clean, else `0`.

### Jitter

For rungs **7 and above** (1 and 3 are too short to fuzz), offset the due
date by the problem's own number, scaled to the rung:

    spread = max(1, round(Interval / 10))     # 1 at rungs 7 and 14, 3 at rung 30
    offset = ((problem_number mod 5) - 2) * spread
    Next Review = today + Interval + offset

Keep `Interval (d)` as the **unjittered** rung so the ladder position stays
readable — only `Next Review` carries the offset.

### Writing the rows

- `PROBLEMS.md`: check the box for this problem if unchecked.
- `REVIEW.md`: upsert the row — `Last Done = today`, plus the `Interval`,
  `Next Review`, and `Streak` from the rules above. `Streak` counts
  consecutive clean solves, so `Interval` doesn't imply it; write both.
- Mention the update in one line: "Next review: 2026-09-19 (rung 7, streak 3)."

## Interview debrief

When the handoff has `kind: interview`, the review above is the back half of
the debrief. Add, before it:

- Time taken vs. a reasonable interview budget (~25-35 min for medium).
- Whether they asked clarifying questions.
- Number of nudges used.
- Correctness of their **stated** complexity vs. actual — the gap is the
  signal. If the handoff has no stated complexity, report it as not stated;
  don't ask.
- One or two things a real interviewer would flag (naming, untested edge
  case, communication gaps) — skip if there's nothing worth saying, don't
  invent filler feedback.

## Handing back

After bookkeeping, control returns to `lc` for the next problem. Don't pick
one yourself — say the attempt is closed out and let the user ask for what's
next.