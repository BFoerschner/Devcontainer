#!/usr/bin/env bash

# why is go installing via github so convoluted with appending v2,v3 etc. for no
# reason making it hard to do dynamic install scripts
go_install_helper() {
  repo="$1"
  latest_tag=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | jq -r '.tag_name')
  
  if [[ -z "$latest_tag" || "$latest_tag" == "null" ]]; then
    echo "Error: Could not fetch latest tag for $repo"
    return 1
  fi
  
  module_path=$(curl -s "https://raw.githubusercontent.com/$repo/$latest_tag/go.mod" | head -1 | awk '{print $2}')
  
  if [[ -z "$module_path" || "$module_path" == "null" ]]; then
    echo "Error: Could not fetch module path for $repo"
    return 1
  fi

  echo "Installing $module_path@$latest_tag"
  go install "$module_path@$latest_tag"
}

install_go_tools() {
  go_install_helper zyedidia/eget
  go_install_helper jesseduffield/lazydocker
  go_install_helper jesseduffield/lazygit
  go_install_helper itchyny/mmv
  go_install_helper maaslalani/nap
  go_install_helper junegunn/fzf
  go_install_helper muesli/duf
  ln -s /usr/bin/duf "$HOME"/.local/bin/df
  go_install_helper wagoodman/dive
  go_install_helper mikefarah/yq
  go_install_helper direnv/direnv

  go install code.gitea.io/tea@v0.10.1
}
