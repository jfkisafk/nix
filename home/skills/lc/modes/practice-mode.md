# Practice Mode

Goal: zero decisions between the user opening the session and writing code.

1. Get today's date via `date +%Y-%m-%d`.
2. Read `REVIEW.md` → **due reviews**, and `PROBLEMS.md` → **next new
   problem**, per `SKILL.md`. This mode writes neither, so it's safe to re-run.
3. Output, in this order, nothing else:

```
Progress: M/Total done

Due for review (K):
  - <problem> (<pattern>) — last done <date>

Next new problem: <number>. <title> (<pattern>, <X>/<Y> in this pattern)
```

   `M` is the count of checked boxes in `PROBLEMS.md`. Do not report a
   consecutive-days-practiced streak — neither data file records session
   dates, so any such number would be invented. `Streak` in `REVIEW.md` is
   per-problem, not per-day.

4. If there are due reviews, ask which the user wants to tackle first — new
   problem or a review — instead of picking for them silently, since reviews
   without pressure lose their spaced-repetition value if skipped repeatedly.
5. Once the user picks: state the problem (title + full statement +
   constraints + examples, no hints, no approach discussion), then set up the
   files per `SKILL.md` — "Per-problem scaffold" for a new problem,
   "Re-solving a due review" for a review.
6. Stop. Let the user write code. Don't discuss approach unless asked — that's
   `hint-mode`. When they say they're done, run the tests and follow
   `SKILL.md` "Handing off to `lr`".

If `PROBLEMS.md` has no unchecked boxes left, say so and suggest pure review
days or ask the user to add more problems to the queue.
