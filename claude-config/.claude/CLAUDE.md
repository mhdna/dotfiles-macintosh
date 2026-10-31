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

## Keep a log of fixed bugs

- Every project keeps a `docs/FIXED_BUGS.md` (make it if it isn't there). Whenever you fix a
  bug, add an entry there in the same commit as the fix, newest first.
- Each entry is short: the date and a title, then **Symptom** (what the user saw), **Cause**
  (why it happened) and **Fix** (what changed, with the files and the test that covers it).
- Only bug fixes go in it, not features or refactors.
