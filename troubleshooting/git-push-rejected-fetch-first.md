# Git: "Updates were rejected because the remote contains work that you do not have locally"

## Symptoms
`git push -u origin main` fails with:

```
! [rejected]        main -> main (fetch first)
error: failed to push some refs to 'github.com:<user>/<repo>'
```

## Cause
The GitHub repository already had a commit that the local repository didn't.
This often happens when the repo is created with "Add a README" ticked
and a local repo with its own first commit is pushed to it.

## Resolution
1. Download the remote history:
   ```bash
   git fetch origin
   git log --oneline origin/main
   ```
2. If the local commits are disposable, reset to the remote:
   ```bash
   git reset --hard origin/main
   ```
   Otherwise, integrate them instead:
   ```bash
   git pull --rebase origin main
   ```
3. Push and set the upstream:
   ```bash
   git push -u origin main
   ```

## Prevention
Create the GitHub repo empty (no README) when starting from a local repo,
or `git clone` it instead of running `git init`.

## Notes
`git reset --hard` discards local work. Only use it when nothing important is uncommitted or unpushed.
