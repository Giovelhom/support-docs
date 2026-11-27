# Git: push rejected with "fetch first"

**Environment:** Ubuntu Server in VirtualBox, Git, GitHub over SSH.

## Symptoms
`git push -u origin main` fails with:

```
 ! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'github.com:<user>/<repo>'
hint: Updates were rejected because the remote contains work that you do not
hint: have locally. This is usually caused by another repository pushing to
hint: the same ref. If you want to integrate the remote changes, use
hint: 'git pull' before pushing again.
```

## Cause
The GitHub repository already contains a commit that the local repository
does not have. In this case, the repo had been created with a README, so it
had its own first commit, while the local repo had made a different first
commit. The two histories diverged.

To confirm, run `git fetch origin` and then `git log --oneline origin/main`.
If it shows a commit you did not make locally, this is the cause.

## Resolution
1. Download the remote history and compare it with the local one:
   ```bash
   git fetch origin
   git log --oneline origin/main   # what is on GitHub
   git log --oneline main          # what is local
   ```
2. Choose one option:

   **Option A: the local commits are disposable.** Reset the local branch to
   match the remote:
   ```bash
   git reset --hard origin/main
   ```
   Warning: this permanently discards local commits and uncommitted changes.

   **Option B: keep the local commits.** Replay them on top of the remote:
   ```bash
   git pull --rebase origin main
   ```
   If both sides created the same file (for example `README.md`), Git stops
   with a conflict. Open the file, remove the `<<<<<<<`, `=======` and
   `>>>>>>>` markers, keep the text you want, then:
   ```bash
   git add README.md
   git rebase --continue
   ```
3. Push and set the upstream:
   ```bash
   git push -u origin main
   ```

## Follow-up error: no upstream branch
After a reset, a plain `git push` may fail with:

```
fatal: The current branch main has no upstream branch.
```

Fix it by running `git push -u origin main`. The `-u` flag links the local
branch to `origin/main`, and it is only needed once. After that, `git push`
and `git pull` work without arguments.

## Prevention
When starting from a local repo, create the GitHub repository empty (no
README, .gitignore, or license). Or clone the GitHub repo with `git clone`
instead of running `git init`.
