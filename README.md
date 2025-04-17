# Devcontainer (tmux based workflow)

<!--toc:start-->

- [Devcontainer (tmux based workflow)](#devcontainer-tmux-based-workflow)
  - [Usage](#usage)
  - [Tools](#tools)
  <!--toc:end-->

## Usage

###### docker run

```bash
docker run -v $HOME/.ssh/:/home/dev/.ssh:ro -v /var/run/docker.sock:/var/run/docker.sock -v $PWD/:/home/dev/host -e LANG="C.UTF-8" -e LC_ALL="C.UTF-8" --rm -it bfoerschner/devcontainer:latest
```

## Tools

- [visidata](https://www.visidata.org/)
  Interactive multitool for tabular data
  - apt
- [yq](https://github.com/mikefarah/yq)
  YAML, JSON and XML processor
  - installscript
- [lazygit](https://github.com/jesseduffield/lazygit)
  Git TUI
  - installscript
- [sysz](https://github.com/joehillen/sysz)
  An fzf terminal UI for systemctl
  - installscript
- [delta](https://github.com/dandavison/delta)
  Difftool
  - apt
- [harlequin](https://harlequin.sh/)
  SQL Manager
  - installscript
- [mitmproxy](https://mitmproxy.org/)
  Interactive HTTPS proxy
  - installscript
- [nap](https://github.com/maaslalani/nap)
  Snippet Manager
  - installscript
- [ctop](https://github.com/bcicen/ctop) (docker container metrics)
  Container metrics
  - installscript
- [jrnl](https://github.com/jrnl-org/jrnl)
  cli journal
  - installscript
- [pipx](https://github.com/pypa/pipx)
  Install python applications easier
  - apt
- [fjira](https://github.com/mk-5/fjira)
  Jira TUI application
  - installscript
- [hurl](https://hurl.dev/)
  HTTP Runner
  - installscript
- [pass](https://www.passwordstore.org/)
  CLI Password manager with totp
  [totp](https://news.ycombinator.com/item?id=39495378)
  - installscript
- [navi](https://github.com/denisidoro/navi)
  Interactive cheatsheet tool for cli
  - installscript
- [entr](https://github.com/eradman/entr)
  Utility for running arbitrary commands when files change
  - installscript
- [termscp](https://github.com/veeso/termscp)
  scp for cli
  - installscript
- [sen](https://github.com/TomasTomecek/sen)
  docker management tui
  - zsh docker alias
- [dive](https://github.com/wagoodman/dive)
  Docker filesystem viewer
  - zsh docker alias
- [fd](https://github.com/sharkdp/fd)
  Alternative to find
  - apt + symlink /usr/bin/fdfind -> ~/.local/bin/fd
- [bat](https://github.com/sharkdp/bat)
  A cat clone with syntax highlighting and Git integration
  - apt + symlink /usr/bin/batcat -> ~/.local/bin/bat
- [eza](https://github.com/eza-community/eza)
  eza is a modern alternative for ls
  - cargo
- [duf](https://github.com/muesli/duf)
  modern df alternative
  - apt
- [dust](https://github.com/bootandy/dust)
  modern du alternative
  - cargo
- [httpie](https://github.com/httpie/cli)
  cli http rest client
  - pipx
- [doggo](https://github.com/mr-karan/doggo)
  doggo is a modern command-line DNS client (like dig)
  - go install
- [lazydocker](https://github.com/jesseduffield/lazydocker)
  A simple terminal UI for both docker and docker-compose
  - go install
- [mmv](https://github.com/itchyny/mmv)
  mass rename files with $EDITOR
  - go install
