# Devcontainer

A Docker-based development environment accessed over SSH. The container runs an SSH daemon as its entrypoint, so you connect to it the same way you would connect to any remote machine. SSH agent forwarding is enabled by default.

The image is built on Ubuntu 25.10 and uses [chezmoi](https://www.chezmoi.io/) to bootstrap dotfiles and development tools at build time. It defaults to [BFoerschner/dotfiles](https://github.com/BFoerschner/dotfiles), but any chezmoi-managed dotfiles repository on GitHub will work.

## Quick start

Requires [mise](https://mise.jdx.dev/) on the host.

```sh
mise run build
mise run start
mise run connect
```

## Mise tasks

| Task | Description |
|------|-------------|
| `build` | Build the image. Passes `GITHUB_TOKEN` as a build secret for private dotfiles repos. |
| `build-no-cache` | Same as `build`, but with `--no-cache`. |
| `start` | Run the container in the background, mapping port 2222 to 22. |
| `start-with-x11` | Start with X11 forwarding (macOS, requires `xhost`). |
| `connect` | SSH into the running container (`ssh -A -p 2222 dev@localhost`). |
| `snapshot-date` | Print the APT snapshot date baked into the image. |
| `reproduce-build` | Extract the snapshot date from an existing container or image and rebuild with it. |
| `stop-and-remove` | Stop and remove the container. |

## How dotfiles and tools are installed

During the image build, if `USER_GITHUB` is set (it defaults to `BFoerschner`), the Dockerfile:

1. Downloads chezmoi and runs `chezmoi init --apply <USER_GITHUB>`, which clones `github.com/<USER_GITHUB>/dotfiles` and lays down all managed files.
2. Fetches the user's public SSH keys from `github.com/<USER_GITHUB>.keys` and writes them to `~/.ssh/authorized_keys`, so you can connect without a password.

Everything beyond that depends on what the dotfiles repository does during `chezmoi apply`.

### BFoerschner/dotfiles

The default dotfiles repo uses a chezmoi `run_once_after` script to install [mise](https://mise.jdx.dev/) and then run `mise install`, which pulls in a full development toolchain:

| Category | Tools |  
|----------|-------|  
| Languages | Go, Rust, Python, Lua, Java, Node.js |  
| Infrastructure | Terraform, kubectl, k9s, Docker CLI, Docker Compose, Ansible |  
| Editor | Neovim (LazyVim-based config with LSP, DAP, and language support for Go, Rust, Python, Java, SQL, Docker, Terraform, and others) |  
| Terminal | tmux, Zsh with Zinit, Starship prompt, fzf, zoxide, direnv |  
| CLI utilities | ripgrep, fd, bat, eza, delta, difftastic, lazygit, lazydocker, gh, jq, yq, httpie, dive, and more |  
| Bootstrap extras | Claude Code, tmux plugins (via TPM), Neovim Supermaven binary |  

## Using your own dotfiles

Set `GITHUB_USER` to your GitHub username before building:

```sh
GITHUB_USER=your-username mise run build
```

The only requirement is that your dotfiles repo lives at `github.com/<your-username>/dotfiles` and is managed by chezmoi. Whatever your chezmoi config does -- installing packages, configuring shells, setting up editors -- will run during the build.

You might want to export a [GITHUB_TOKEN/PAT](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens) to:

- avoid rate-limiting when installing a lot of packages via mise or github in general
- install private dotfiles

```sh
export GITHUB_TOKEN=ghp_...
GITHUB_USER=your-username mise run build
```

The token is passed as a [Docker build secret](https://docs.docker.com/build/building/secrets/) and does not persist in the final image.

## Reproducible builds

APT packages are installed from [snapshot.ubuntu.com](http://snapshot.ubuntu.com), which serves the state of the Ubuntu archive at a given point in time. By default, the build uses the current date. The chosen snapshot date is written to `/etc/apt-snapshot-date` inside the image.

To retrieve the snapshot date, pass a running container name/ID or an image name (defaults to `devcontainer`):

```sh
mise run snapshot-date              # running container or image named "devcontainer"
mise run snapshot-date -- myimage   # a different image or container
```

To reproduce a build from an existing container or image in one step:

```sh
mise run reproduce-build -- myimage
```

This extracts the snapshot date and runs `mise run build` with it. It fails if the snapshot date cannot be retrieved.

You can also set `SNAPSHOT_DATE` manually:

```sh
SNAPSHOT_DATE=20260314T000000Z mise run build
```

This pins all APT packages to the versions that were available on that date, making the base system layer fully reproducible regardless of when the build runs.

## Build arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `USERNAME` | `dev` | Username for the non-root user. |
| `USER_UID` | `1001` | UID for the non-root user. |
| `USER_SHELL` | `/bin/bash` | Default login shell. |
| `USER_GITHUB` | *(none)* | GitHub username. Drives dotfiles and SSH key import. |
| `SNAPSHOT_DATE` | *(current date)* | APT snapshot date (`YYYYMMDDTHHMMSSZ`) for reproducible builds. |

## License

[MIT](LICENSE)
