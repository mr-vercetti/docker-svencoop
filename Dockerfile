FROM mrvercetti/steamcmd as builder

# Download Sven Co-Op server
RUN ${STEAMCMD_DIR}/steamcmd.sh +login anonymous +force_install_dir ${OUTPUT_DIR} +app_update 276060 validate +quit && \
    echo "225840" > ${OUTPUT_DIR}/steam_appid.txt

# Fresh start
FROM debian:bullseye-slim
LABEL maintainer="mr-vercetti"

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y \
        ca-certificates lib32gcc-s1 libstdc++6 libssl1.1:i386 libstdc++6:i386 locales locales-all tmux zlib1g:i386 && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
        locale-gen --no-purge en_US.UTF-8 && \
    apt-get clean && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# General variables
ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
ENV SERVER_DIR="/svencoop-server"
ENV OUTPUT_DIR="/output"
# Startup variables
ENV GAME_PARAMS="-num_edicts 3072 +sv_lan 1 -port 27015 -console -debug;"
ENV GAME_NAME=""
ENV GAME_PASSWORD=""

# Set up user environment
RUN groupadd -r abc && \
    useradd -d ${SERVER_DIR} -r -g abc abc && \
    mkdir -p ${SERVER_DIR} && \
    chown -R abc:abc ${SERVER_DIR}

USER abc
WORKDIR ${SERVER_DIR}

# Copy needed files
COPY --chown=abc:abc --chmod=755 /scripts/start.sh /
COPY --chown=abc:abc --from=builder ${OUTPUT_DIR} ${SERVER_DIR}

# Link steamclient.so to prevent srcds_run errors
RUN mkdir -p ${SERVER_DIR}/.steam/sdk32 && \
    ln -s ${SERVER_DIR}/steamclient.so ${SERVER_DIR}/.steam/sdk32/steamclient.so

ENTRYPOINT ["/start.sh"]
