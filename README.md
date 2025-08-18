# Axolotl Cloud Infrastructure

## Git-Crypt
We use [git-crypt](https://github.com/AGWA/git-crypt) to encrypt and store certain secrets transparently in this repository, such as Talos secrets and Terraform variables.

To add a user to the keyring:
```sh
git-crypt add-gpg-user USER_ID
```

To unlock secrets after cloning this repository:
```sh
git-crypt unlock
```
