#!/bin/bash

server_cfg_file="$SERVER_DIR/svencoop/server.cfg"
liblist_file="$SERVER_DIR/svencoop/liblist.gam"

if [[ $GAME_NAME != "" ]]; then
    echo "Starting Sven Co-Op server \"$GAME_NAME\""
    sed -i "s/\/\?\/\?hostname \".*\"/hostname \"$GAME_NAME\"/" $server_cfg_file
    sed -i "s/\/\?\/\?game \".*\"/game \"$GAME_NAME\"/" $liblist_file
else
    echo "Starting Sven Co-Op server"
fi

if [[ $GAME_PASSWORD != "" ]]; then
    echo "Password protection enabled"
    sed -i "s/\/\?\/\?sv_password \".*\"/sv_password \"$GAME_PASSWORD\"/" $server_cfg_file
fi

cd ${SERVER_DIR}
${SERVER_DIR}/svends_run ${GAME_PARAMS}