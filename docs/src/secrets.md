# Secrets Management

## Login Secrets Management

The password for a user can be set by encrypting a specific password with the host key on the target machine.

Use `ssh-to-age` to convert /etc/ssh/ssh_host_ed25519_key.pub to an age public key and add to .sops.yaml.
Run task sops:re-encrypt to re-encrypt secrets with the appropriate keys.

## Secrets

I store additional secrets in 1Password and fetch them through the script [fetch-secrets](./scripts/fetch-secrets). This ensures they are not out in the wild at all.

All secrets are stored as document-type entries with the file as the document. Secrets that are for machine alpha are tagged with "alpha".
As well, there must be a path for the secret and an optional script.

Paths are specified in the 1Password item as additional info text fields. The label is one of:

* `alpha:path`
* `Darwin:path`
* `default:path`

alpha:path will specify the path on machine alpha. If alpha:path is missing, then a Darwin machine will look for Darwin:path and use that.
Similarly, Linux:path will be used on a Linux (or NixOS) machine. If both of those are missing, default:path will be used.

Optional scripts are named the same way with `:script` as the suffix. The script will be executed after the secret is fetched to the specified path.

The combination of path and script is useful for tasks such as loading GPG secret keys. Set the path to `.` and then for a secret file named `secret-keys.asc`
the script

```sh
gpg --import ./secret-keys.asc
rm ./secret-keys.asc
```

will load the secrets into GPG and then erase the armoured file afterwards.
