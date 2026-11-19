# Rules for every project

## Git: commit as you go

- Commit your changes yourself as soon as a change is done and works (it builds, and tests pass
  where there are tests). Don't wait to be asked, and don't leave finished work uncommitted.
- One commit per change: a fix, a feature, a refactor each get their own commit, with a message
  that says what changed and why. Don't bundle unrelated changes together.
- Commit in every repo you touched, each on its own.
- Never add Claude as a co-author or any "Generated with Claude" line, in commits or PRs.

## Git: branches for anything big

- Breaking changes, big features, and big bug fixes go on their own branch (named for the work,
  like `launcher` or `fix-vpn-lockdown`), never straight onto the main branch.
- Commit on that branch as you go, then merge it into the main branch with `git merge --no-ff`
  once it works, so the history shows it as one piece of work.
- Small changes and small fixes can go straight onto the current branch.
- Keep each branch to one piece of work. At the start of every new request, check which branch
  you're on (a hook prints it with each message). If the request isn't part of that branch's
  work, don't add it there: start a new branch from the base branch (the one the current
  feature branched off), or ask me when it's unclear where it belongs. Finished feature
  branches get merged and deleted, not reused for the next thing.

## Never ship a refusal of something the screen lets people do

- If a screen lets a person build it (a cart, an exchange, a return, a form), the backend
  must accept it. Never write or ship code that rejects a valid combination: two of the same
  item, the same product at two prices, several "unknown" or custom-priced lines, a line
  added twice, lines in any order, an empty optional field, the biggest and smallest values.
- Any code that merges, groups or de-duplicates by a key (code, barcode, name, id) must be
  checked against every way two different things share that key. Placeholders ("UNKNOWN"
  items, walk-in clients, "No salesperson") share it by design: keep them apart.
- Every such path gets a strong randomized test: hundreds of combinations built the way the
  screen builds them, each one taken all the way through (quote, checkout, save), asserting
  it is accepted and that what is stored equals what was shown, line for line. Write it in
  the same change, prove it bites by breaking the code once, and never call work done
  without it. When you touch a path that lacks such a test, add one.
- Errors people can see are words for them ("Pick a size first"), never developer notes
  ("send X as a single line"). An internal-sounding error reaching a screen is a bug.

## Keep a log of fixed bugs

- Every project keeps a `docs/FIXED_BUGS.md` (make it if it isn't there). Whenever you fix a
  bug, add an entry there in the same commit as the fix, newest first.
- Each entry is short: the date and a title, then **Symptom** (what the user saw), **Cause**
  (why it happened) and **Fix** (what changed, with the files and the test that covers it).
- Only bug fixes go in it, not features or refactors.

## No long dashes or dot separators in text people see

- Never write an em dash (—) or en dash (–) in any user-facing text: UI titles, dialog headers,
  labels, buttons, messages, copy, release notes, in Arabic or English. Use a colon, comma or
  period instead («تعديل الرموز: فئة الطبيب», not «تعديل الرموز — فئة الطبيب»).
- Never separate items with a middle dot (·) or bullet (•) ("5 events · last 24h"). Use a comma,
  a line break or real space in the layout.
- This holds for every UI change, with or without the design-without-ai-look skill loaded.
