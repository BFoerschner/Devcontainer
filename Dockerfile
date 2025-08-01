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

################################################################################
#  Copy relevant files over  ---------------------------------------------------
################################################################################
COPY ["init_scripts", "/root/init_scripts"]
COPY ["build-scripts", "/root/build-scripts"]
COPY ["$INIT_SCRIPT_PATH", "/root/init.sh"]
WORKDIR /root

################################################################################
#  Installing everything in one go to avoid unnecessarily bulking up the image
#  with lots of intermediate layers
################################################################################
RUN \
  ./init.sh && \
  rm -rf ./init_scripts && \
  rm -rf ./build-scripts && \
  rm -rf ./init.sh

################################################################################
#  Start in provided host directory and run TMUX -------------------------------
################################################################################
WORKDIR /root/host
ENTRYPOINT ["tmux", "new-session", "-A", "-s", "main"]
