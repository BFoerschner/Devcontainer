#!/usr/bin/env bash

get_latest_tag() {
  local repo="$1"

  local tag=$(curl -s "https://api.github.com/repos/$repo/releases/latest" | jq -r '.tag_name')

  if [[ -z "$tag" || "$tag" == "null" ]]; then
    echo "Error: Could not fetch latest tag for $repo" >&2
    return 1
  fi

  echo "$tag"
}

get_main_path() {
  local repo="$1"

  # Find the first main.go file location in the repo
  local main_path=$(curl -s "https://api.github.com/repos/$repo/git/trees/main?recursive=1" |
    jq -r '.tree[]? | select(.path | test("main\\.go$")) | .path' |
    head -1 |
    sed 's|/main.go$||')

  if [[ -n "$main_path" && "$main_path" != "main.go" ]]; then
    echo "/$main_path"
  fi
}

go_install_helper() {
  local repo="$1"
  local tag=$(get_latest_tag "$repo")
  local main_path=$(get_main_path "$repo")

  if [[ -z "$tag" ]]; then
    echo "Error: No tag provided for $repo"
    return 1
  fi

  module_path=$(curl -s "https://raw.githubusercontent.com/$repo/$tag/go.mod" | head -1 | awk '{print $2}')
  echo "module_path: $module_path"

  if [[ -z "$module_path" || "$module_path" == "null" ]]; then
    echo "Error: Could not fetch module path for $repo"
    return 1
  fi

  echo "Installing $module_path@$tag"
  if go install "$module_path@$tag" 2>/dev/null; then
    echo "Successfully installed $module_path@$tag"
    return 0
  fi

  # If first attempt fails and we have a main_path, try with it
  if [[ -n "$main_path" ]]; then
    echo "Trying $module_path$main_path@$tag"
    if go install "$module_path$main_path@$tag" 2>/dev/null; then
      echo "Successfully installed $module_path$main_path@$tag"
      return 0
    fi
  fi

  echo "Error: Could not install $repo" >&2
  return 1
}

install_tea() {
  # Install tea with latest version from Gitea
  echo "Installing code.gitea.io/tea (latest)"
  local tea_tag=$(curl -s "https://gitea.com/api/v1/repos/gitea/tea/releases" | jq -r '.[0].tag_name' 2>/dev/null)
  if [[ -n "$tea_tag" && "$tea_tag" != "null" ]]; then
    if ! go install code.gitea.io/tea@"$tea_tag" 2>/dev/null; then
      echo "Warning: Failed to install tea@$tea_tag" >&2
    else
      echo "Successfully installed tea@$tea_tag"
    fi
  else
    echo "Warning: Could not fetch latest tea version, falling back to known version" >&2
    return 1
  fi
}

install_go_tools() {
  local repos=(
    "zyedidia/eget"
    "jesseduffield/lazydocker"
    "jesseduffield/lazygit"
    "maaslalani/nap"
    "junegunn/fzf"
    "muesli/duf"
    "wagoodman/dive"
    "mikefarah/yq"
    "direnv/direnv"
    "getsops/sops"
    "itchyny/mmv"
  )

  for repo in "${repos[@]}"; do
    go_install_helper "$repo" || echo "Warning: Failed to install $repo" >&2
  done
  install_tea

  # Create duf symlink if it doesn't exist
  if command -v duf &>/dev/null && [[ ! -L "$HOME/.local/bin/df" ]]; then
    ln -sf "$(command -v duf)" "$HOME/.local/bin/df"
  fi
}
