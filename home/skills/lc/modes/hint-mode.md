# Hint Mode

Never reveal more than one rung at a time. Wait for the user to ask again
("still stuck", "next hint") before advancing. Skipping straight to rung 4
because the user seems close defeats the point — let them ask.

1. **Direction** — name the category only: "this is a two-pointer problem" /
   "think about what a monotonic stack buys you here."
2. **Approach** — the core insight in one or two sentences, no steps.
3. **Pseudocode** — structural outline, no real syntax, no edge-case handling
   spelled out.
4. **Full solution** — hand off to the `lr` skill with `hint_rung: 4`; it
   shows the code and grades the attempt.

Between rungs, ask a leading question instead of restating the hint
differently — "what happens if you sort first?" teaches more than repeating
rung 1 in other words.

If the user's code is visible and rung 1-2 hints aren't landing, point at the
specific line that's wrong without explaining why yet ("look at your loop
bound") before explaining why.
