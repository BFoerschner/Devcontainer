#!/usr/bin/env bash
set -eo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"/logging.sh

confirm_proceed() {
  local flag=${1:-}
  if [[ "$flag" != "-y" && "$flag" != "--yes" ]]; then
    read -rp "Proceed with updating and installing developer tools? (y/N): " response
    if [[ ! "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
      log "Aborted by user"
      exit 0
    fi
  fi
}

# Install common packages
install_packages() {
  local pkg_mgr_cmd="$1"
  local -n pkg_list=$2

  mkdir -p "$HOME/.local/bin"
  export PATH="$HOME/.local/bin:$PATH"

  $pkg_mgr_cmd "${pkg_list[@]}"
}

# TODO: refactor
clean_package_cache() {
  local id=$1
  local before after
  before=$(df --output=avail / | tail -n1)

  if [[ "$id" == "ubuntu" || "$id" == "debian" ]]; then
    apt-get clean && apt-get autoclean && apt-get autoremove -y
  elif [[ "$id" == "fedora" ]]; then
    dnf clean all
  elif [[ "$id" == "centos" ]]; then
    yum clean all
  elif [[ "$id" == "arch" || "$id" == "manjaro" ]]; then
    pacman -Scc --noconfirm
  elif [[ "$id" == opensuse* ]]; then
    zypper clean --all
  else
    log "Skipping cache deletion: unsupported distro $id"
    return
  fi

  after=$(df --output=avail / | tail -n1)
  local saved_kb=$((after - before))
  local saved_mb=$((saved_kb / 1024))
  log "Cache deletion complete. Disk space saved: ${saved_mb} MB"
}

# Update & install for each distro family
update_distro() {
  local id=$1
  local raw_update=$2
  local raw_install=$3

  if ((EUID == 0)); then
    update_cmd="$raw_update"
    install_cmd="$raw_install"
  else
    update_cmd="sudo $raw_update"
    install_cmd="sudo $raw_install"
  fi

  log "Detected $id"

  # System update
  eval "$update_cmd"

  # Development group/tools
  if [[ "$id" == "ubuntu" || "$id" == "debian" ]]; then
    eval "$install_cmd software-properties-common build-essential pkg-config libevent-dev libncurses-dev bison pass"
    # silicon deps
    eval "$install_cmd expat libxml2-dev libssl-dev libfreetype6-dev libexpat1-dev libxcb-composite0-dev libharfbuzz-dev libfontconfig1-dev g++ libsmbclient libsmbclient-dev libclang-dev"
    if grep -q docker /proc/1/cgroup 2>/dev/null; then
      log "Container detected: installing unminimize"
      eval "$install_cmd unminimize"
      log "Unminimizing..."
      yes | unminimize 2>/dev/null || log "unminimize unavailable, skipping"
    fi
  elif [[ "$id" == "fedora" ]]; then
    eval "$install_cmd gcc make pkgconfig libevent-devel ncurses-devel bison pass"
    eval "$install_cmd groupinstall 'Development Tools' 'Development Libraries'"
    # silicon deps
    eval "$install_cmd expat-devel fontconfig-devel libxcb-devel freetype-devel libxml2-devel harfbuzz libsmbclient-devel libsmbclient clang-devel llvm-devel"
  elif [[ "$id" == "centos" ]]; then
    eval "$install_cmd libevent-devel ncurses-devel bison pkgconfig pass"
    eval "$install_cmd groupinstall 'Development Tools'"
    # silicon deps
    eval "$install_cmd expat-devel fontconfig-devel libxcb-devel freetype-devel libxml2-devel harfbuzz-devel gcc-c++ libsmbclient clang-devel llvm-devel"
  elif [[ "$id" == "arch" || "$id" == "manjaro" ]]; then
    eval "$update_cmd --noconfirm"
    eval "$install_cmd --noconfirm base base-devel pkgconf libevent ncurses pass openssh"
    # silicon deps
    eval "$install_cmd --noconfirm --needed freetype2 fontconfig libxcb xclip harfbuzz smbclient clang llvm oniguruma samba"
  elif [[ "$id" == opensuse* ]]; then
    eval "$install_cmd patterns-base-base-devel_basis gcc make pkg-config libevent-devel ncurses-devel bison password-store"
    # silicon deps
    eval "$install_cmd libexpat1-devel fontconfig-devel libxcb-composite0-devel freetype2-devel libxml2-devel harfbuzz-devel gcc-c++ libsmbclient0 clang-devel llvm-devel"
  else
    error "Unsupported distro for update: $id"
    exit 1
  fi

  # Install common packages
  local common_pkgs=(
    curl
    automake
    wget
    unzip
    stow
    cmake
    gnupg
    man
    tidy
    git
    net-tools
    jq
    tar
    zsh
    ncdu
  )
  install_packages "$install_cmd" common_pkgs
}

main() {
  confirm_proceed "$@"

  if [[ ! -r /etc/os-release ]]; then
    error "/etc/os-release not found, cannot detect OS"
    exit 1
  fi

  source /etc/os-release
  distro_id=${ID,,}

  # Dispatch based on distro
  if [[ "$distro_id" == "ubuntu" || "$distro_id" == "debian" ]]; then
    update_distro "$distro_id" \
      "apt-get update && apt-get upgrade -y && apt-get autoremove -y" \
      "apt-get install -y"
  elif [[ "$distro_id" == "fedora" ]]; then
    update_distro "$distro_id" \
      "dnf upgrade --refresh -y" \
      "dnf install -y"
  elif [[ "$distro_id" == "centos" ]]; then
    update_distro "$distro_id" \
      "yum update -y" \
      "yum install -y"
  elif [[ "$distro_id" == "arch" || "$distro_id" == "manjaro" ]]; then
    update_distro "$distro_id" \
      "pacman -Syu --noconfirm" \
      "pacman -S --noconfirm"
  elif [[ "$distro_id" == opensuse* ]]; then
    update_distro "$distro_id" \
      "zypper refresh && zypper update -y" \
      "zypper install -y"
  else
    error "Unsupported OS: $distro_id"
    exit 1
  fi

  log "Cleaning buildcache"
  clean_package_cache "$distro_id"

  log "All updates and installations completed successfully"
}

main "$@"
