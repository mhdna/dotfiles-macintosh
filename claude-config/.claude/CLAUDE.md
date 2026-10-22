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

## Safety

- Before committing to a public repo, check that no secrets, private files (ssh config, shell
  history, tokens, keys) or junk (build output, caches, media) are included.
- Push when asked to, or when the project's own instructions say to.
