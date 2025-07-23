#!/usr/bin/env bash

install_go_tools() {
  go install github.com/zyedidia/eget@latest
  go install github.com/jesseduffield/lazydocker@latest
  go install github.com/jesseduffield/lazygit@latest
  go install github.com/itchyny/mmv/cmd/mmv@latest
  go install github.com/maaslalani/nap@main
  go install github.com/junegunn/fzf@latest
  go install github.com/muesli/duf@latest
  ln -s /usr/bin/duf "$HOME"/.local/bin/df
  go install github.com/wagoodman/dive@latest
  go install github.com/mikefarah/yq/v4@latest
  go install github.com/direnv/direnv@latest
  go install code.gitea.io/tea@v0.10.1
}
