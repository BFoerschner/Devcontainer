FROM ubuntu:24.10

# /tmp
#     A directory made available for applications that need a place to create
#     temporary files. Applications shall be allowed to create files in this
#     directory, but shall not assume that such files are preserved between
#     invocations of the application.
# -- quoted from https://pubs.opengroup.org/onlinepubs/9699919799/basedefs/V1_chap10.html
ENV INITIAL_INSTALL_PATH=/tmp

###############################################################################
## Copy binaries ##############################################################
###############################################################################
RUN mkdir -p \
  /opt/tmp \
  /root/.local/bin
COPY bin /root/.local/bin

###############################################################################
## Install programs ###########################################################
###############################################################################
COPY init_scripts init.sh ${INITIAL_INSTALL_PATH}/
RUN \
  ${INITIAL_INSTALL_PATH}/init.sh && \
  rm -rf ${INITIAL_INSTALL_PATH}/init_scripts && \
  rm ${INITIAL_INSTALL_PATH}/init.sh

WORKDIR /root/host

ENTRYPOINT ["tmux", "-u"]
