# Ma DotFiles

| Hostname     | Description |
|--------------|-------------|
| Lion         | Main PC     |
| Chi          | TP T14s     |
| Lynx         | TP T430     |
| Ferret       | Yoga C630   |
| Abyssinian   | OnePlus 9   |

## Planned names

* Cymric
* Manx
* Korat
* Toyger

## Deps

...

## Headscale

Hosted on Rex, release installed manually and will likely need manual updates.

```sh
sudo tailscale up --operator cas --login-server https://rex.connolly.tech
```

## Set up dotfiles on new machine

1. Add ssh key to github
2. Clone bare repo

```sh
git clone --bare git@github.com:calebccff/dotfiles.git .gitdotfiles
```

3. Checkout

```sh
alias config='/usr/bin/git --git-dir=$HOME/.gitdotfiles/ --work-tree=$HOME'
config checkout
config config --local status.showUntrackedFiles no
```

4. Install deps

Arch:

```sh
TODO
```

Alpine:

```sh
sudo apk add zsh zsh-theme-powerlevel10k zsh-autosugguestions zsh-syntax-highlighting py3-argcomplete
```

5. Set shell

```sh
chsh
 # /usr/bin/zsh
```

