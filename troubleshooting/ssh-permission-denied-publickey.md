# SSH: "Permission denied (publickey)" when connecting to GitHub

**Environment:** Ubuntu Server in VirtualBox, OpenSSH, ed25519 key.

## Symptoms
Running `ssh -T git@github.com` returns:

```
git@github.com: Permission denied (publickey).
```

On GitHub (Settings → SSH and GPG keys), the key appeared in the list but was marked "Never used".

## Cause
The public key registered on GitHub did not match the key on the machine.
The SHA256 fingerprints were different. In this case, the most likely reason was
a copy error when pasting the key from the VM console.

Other common causes of this error:
- The key was added to a different GitHub account
- The key was never added to GitHub
- The remote URL or username is wrong (it must be `git@github.com`)
- SSH is not offering the key (see Diagnostics below)

## Resolution
1. Show the fingerprint of the key on the machine:
   ```bash
   ssh-keygen -lf ~/.ssh/id_ed25519.pub
   ```
2. Compare it with the fingerprint GitHub shows for the key
   (Settings → SSH and GPG keys, it starts with `SHA256:`).
3. If they differ, delete the old key on GitHub and add the output of:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   ```
   Copy the whole line, from `ssh-ed25519` to the end. If no key exists on the
   machine, generate one first with `ssh-keygen -t ed25519 -C "your-email"`.
4. Test again:
   ```bash
   ssh -T git@github.com
   ```
   Expected: `Hi <username>! You've successfully authenticated...`

## Diagnostics
If it still fails, run SSH in verbose mode:
```bash
ssh -vT git@github.com
```
Look for a line like `Offering public key: /home/<user>/.ssh/id_ed25519`.
- If it appears, the key is being sent and GitHub does not recognize it.
- If it does not appear, SSH is not finding the key. Check `ls -la ~/.ssh`.

## Prevention
Copy the public key from an SSH session on your host machine, not from the
VM console, where selecting text is unreliable.

## Security note
Only share the public key (`id_ed25519.pub`). Never share the private key
(`id_ed25519`).
