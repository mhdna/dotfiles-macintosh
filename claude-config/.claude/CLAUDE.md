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
- Always merge a feature I asked for yourself, as soon as its tests pass: merge, delete the
  branch, remove any worktree. Never stop to ask "should I merge?" and never wait for me to
  check it on screen first. Releasing and publishing are still mine.
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

## Keep a log of performance work

- Every project keeps a `docs/PERFORMANCE.md` (make it if it isn't there). Whenever you make
  something faster or lighter (startup, a slow screen, a query, bundle/APK size, memory), add an
  entry there in the same commit, newest first.
- Each entry is short: the date and a title, then **Symptom** (what felt slow), **Finding** (what
  you measured or traced, with numbers if you have them; say so if you couldn't measure) and
  **Change** (what changed, with the files). Add **Not done** for ideas you ruled out or left.
- Also note measured slow spots you did NOT fix, under a "Known slow spots" heading at the top.

## Keep a list of feature ideas

- Every project keeps a `docs/FEATURE_IDEAS.md` (make it if it isn't there). When I mention an
  idea or wish for later ("it'd be nice if...", "maybe we can...") that you aren't building now,
  add a line there instead of losing it. Group as Ideas / In progress / Done; move a line to Done
  (with the date) when it ships.
- Don't build ideas from this file unless I ask.

## Keep the changelog current

- Every change a user could notice (a feature, a fix, a behaviour change, a layout tweak, an
  installer change) gets a line in the project's changelog / release notes, in the same commit as
  the change, without being asked. Before each commit, ask "would a user notice this?"; if yes,
  check the line is there.
- Follow the project's own rules for where it lives and what language and tone it uses (in
  aman-lomr: the in-progress entry at the top of `frontend/src/data/releaseNotes.ts`, in Arabic).
- Purely internal work (refactors, tests, build tooling) needs no line.

## Keep APKs small

- Android release APKs must stay small (about 20 MB for a Flutter app, not 50+). Build them
  arm64-only: `flutter build apk --release --target-platform android-arm64`, and keep
  `ndk { abiFilters += listOf("arm64-v8a") }` in `android/app/build.gradle.kts` so the manifest
  doesn't also list 32-bit/x86 (that makes some phones crash on launch). Never switch to a
  fat/all-ABI APK to fix a problem without asking me first.
- Check the size of every APK you build or publish and tell me if it grew noticeably.
- Don't add big assets or dependencies without saying what they cost in APK size.

## No long dashes or dot separators in text people see

- Never write an em dash (—) or en dash (–) in any user-facing text: UI titles, dialog headers,
  labels, buttons, messages, copy, release notes, in Arabic or English. Use a colon, comma or
  period instead («تعديل الرموز: فئة الطبيب», not «تعديل الرموز — فئة الطبيب»).
- Never separate items with a middle dot (·) or bullet (•) ("5 events · last 24h"). Use a comma,
  a line break or real space in the layout.
- This holds for every UI change, with or without the design-without-ai-look skill loaded.

## No filled or tinted chips

- Never use a chip with a background fill or tint (Vuetify/k-chip `variant="tonal"` or `flat`,
  or any pill with a coloured background) for amounts, balances, discounts or statuses. Show the
  value as plain coloured text (red `error` colour for money owed or discounts), with no
  background. Same for a chip you are asked to restyle: "no bg, just fg" is the default.
- If a real control needs a chip shape (a removable filter, a toggle), say so and ask first.

## Token economy

- The prompt cache expires after about 5 minutes idle. Never leave a turn waiting on something open-ended: every Bash call gets an explicit `timeout`, and long jobs run in the background.
- Replies must be quick to read and answer: at most one short paragraph, no walls of text. Put detail in files or commits, not chat.
- Delegate bulk work to Haiku subagents (`model: "haiku"`): summarizing, searching and reading many files, research, and well-specified small implementation tasks. Tell each one to keep its context under 100k tokens and to return only the conclusion. Keep design decisions and tricky edits in the main session.
- Keep sessions small. Past roughly 150k tokens of context, tell me so and suggest wrapping up and starting a fresh session, since that is cheaper than continuing.
- One task per session: when a task is done and committed, say so and suggest clearing context before the next unrelated task.
