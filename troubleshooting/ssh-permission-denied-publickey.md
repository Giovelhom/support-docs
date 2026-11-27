# SSH: "Permission denied (publickey)" when connecting to GitHub

## Symptoms
Running `ssh -T git@github.com` returns:

```
git@github.com: Permission denied (publickey).
```

## Cause
The public key added to GitHub did not match the key on the machine.
A character was altered when copying the key from the VM console.

## Resolution
1. Show the fingerprint of the key on the machine:
   ```bash
   ssh-keygen -lf ~/.ssh/id_ed25519.pub
   ```
2. Compare it with the fingerprint shown in GitHub under Settings → SSH and GPG keys.
3. If they differ, delete the old key on GitHub and add the output of
   `cat ~/.ssh/id_ed25519.pub`.
4. Test again:
   ```bash
   ssh -T git@github.com
   ```
   Expected: `Hi <username>! You've successfully authenticated...`

## Prevention
Copy the public key from an SSH session on your host machine, not from the VM console.

