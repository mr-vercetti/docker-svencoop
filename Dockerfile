FROM debian:stable-slim
LABEL maintainer="mr-vercetti"

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y \
        bzip2 ca-certificates curl libarchive13 libstdc++6 lib32gcc-s1 libssl1.1:i386 \
        libstdc++6:i386 locales locales-all tmux zlib1g:i386 p7zip-full tar unzip wget xz-utils && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        locale-gen --no-purge en_US.UTF-8 && \
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
ENV APP_DIR="/app"
ENV STEAMCMD_DIR="${APP_DIR}/Steam/steamcmd"
ENV SERVER_DIR="${APP_DIR}/server"
ENV GAME_PARAMS="-num_edicts 3072 +sv_lan 1 -port 27015 -console -debug;"

# Set up user environment
RUN groupadd -r abc && \
    useradd -d ${APP_DIR} -r -g abc abc && \
    mkdir -p ${SERVER_DIR} ${STEAMCMD_DIR} && \
    chown -R abc:abc ${APP_DIR}

ADD --chown=abc:abc --chmod=755 /scripts/start.sh /

USER abc
WORKDIR ${APP_DIR}

# Download and update steamcmd
RUN wget -qO- http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar xz -C ${STEAMCMD_DIR} && \
    chmod +x ${STEAMCMD_DIR}/steamcmd.sh && \
    ${STEAMCMD_DIR}/steamcmd.sh +force_install_dir ${STEAMCMD_DIR} +login anonymous +quit

# Download Sven Co-Op server
RUN ${STEAMCMD_DIR}/steamcmd.sh +login anonymous +force_install_dir ${SERVER_DIR} +app_update 276060 validate +quit && \
    echo "225840" > ${SERVER_DIR}/steam_appid.txt

# Link steamclient.so to prevent srcds_run errors
RUN mkdir -p ${APP_DIR}/.steam/sdk32 && \
    ln -s ${SERVER_DIR}/steamclient.so ${APP_DIR}/.steam/sdk32/steamclient.so

ENTRYPOINT ["/start.sh"]