################################################################################
#  Build arguments  ------------------------------------------------------------
################################################################################
ARG USE_UBUNTU_ROLLING=false
ARG BASE_IMAGE=ubuntu:rolling
ARG INIT_SCRIPT_PATH
ARG ENTRYPOINT

################################################################################
#  Base image selection  -------------------------------------------------------
################################################################################
FROM ${BASE_IMAGE}

################################################################################
#  Re-declare args after FROM  -------------------------------------------------
################################################################################
ARG INIT_SCRIPT_PATH
RUN test -n "$INIT_SCRIPT_PATH" \
  || (echo "ERROR: INIT_SCRIPT_PATH build argument is required" && exit 1)

WORKDIR /build
################################################################################
#  Installing everything in one go to avoid unnecessarily bulking up the image
#  with lots of intermediate layers
################################################################################
SHELL ["/bin/bash", "-c"]

USER root 
# Copy only scripts needed for OS update
COPY ["build-scripts/logging.sh", "build-scripts/cleanup_caches.sh", "build-scripts/update_os.sh", "/build/build-scripts/"]
RUN source build-scripts/logging.sh && source build-scripts/cleanup_caches.sh && source build-scripts/update_os.sh && update_os true && cleanup_caches

RUN useradd -m -s /bin/bash -u 1001 dev && \
  usermod -aG sudo dev && \
  echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER dev

# Copy and run language installation
COPY ["build-scripts/common_setup.sh", "/build/build-scripts/"]
COPY ["build-scripts/languages.sh", "/build/build-scripts/"]
RUN source build-scripts/common_setup.sh && source build-scripts/logging.sh && source build-scripts/cleanup_caches.sh && source build-scripts/languages.sh && setup_environment && install_languages && cleanup_caches

# Copy and run dotfiles installation
COPY ["build-scripts/dotfiles.sh", "/build/build-scripts/"]
RUN source build-scripts/common_setup.sh && source build-scripts/logging.sh && source build-scripts/cleanup_caches.sh && source build-scripts/dotfiles.sh && setup_environment && install_dotfiles && cleanup_caches

# Copy and run Go tools installation
COPY ["build-scripts/go_tools.sh", "/build/build-scripts/"]
RUN source build-scripts/common_setup.sh && source build-scripts/logging.sh && source build-scripts/cleanup_caches.sh && source build-scripts/go_tools.sh && setup_environment && install_go_tools && cleanup_caches

# Copy and run UV tools installation
COPY ["build-scripts/uv_tools.sh", "/build/build-scripts/"]
RUN source build-scripts/common_setup.sh && source build-scripts/logging.sh && source build-scripts/cleanup_caches.sh && source build-scripts/uv_tools.sh && setup_environment && install_uv_tools && cleanup_caches

# Copy and run Cargo tools installation
COPY ["build-scripts/cargo_tools.sh", "/build/build-scripts/"]
RUN source build-scripts/common_setup.sh && source build-scripts/logging.sh && source build-scripts/cleanup_caches.sh && source build-scripts/cargo_tools.sh && setup_environment && install_cargo_tools && cleanup_caches

# Copy and run NPM tools installation
COPY ["build-scripts/npm_tools.sh", "/build/build-scripts/"]
RUN source build-scripts/common_setup.sh && source build-scripts/logging.sh && source build-scripts/cleanup_caches.sh && source build-scripts/npm_tools.sh && setup_environment && install_npm_tools && cleanup_caches

# Copy and run tools installation
COPY ["build-scripts/tools.sh", "/build/build-scripts/"]
RUN source build-scripts/common_setup.sh && source build-scripts/logging.sh && source build-scripts/cleanup_caches.sh && source build-scripts/tools.sh && setup_environment && install_tools && cleanup_caches


################################################################################
#  Start in provided host directory and run TMUX -------------------------------
################################################################################
WORKDIR /home/dev
ENTRYPOINT [ \
  "/home/dev/.cargo/bin/nu", \
  "-l", \
  "-c", \
  "/usr/local/bin/tmux new-session -A -s main" \
  ]
