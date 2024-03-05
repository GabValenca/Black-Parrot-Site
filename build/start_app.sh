#!/bin/bash

APP_NAME="BlackParrot"
NODE_COMMAND="node"
SERVER_SCRIPT="server.js"
APP_DIR="/home/build/"
HTTP_PORT=80

# Navega até o diretório da aplicação
cd $APP_DIR || exit 1

# Verifica se o processo do Node.js está em execução
if pgrep -f "$NODE_COMMAND $SERVER_SCRIPT" > /dev/null; then
    echo "O servidor está em execução."
else
    echo "O servidor não está em execução. Iniciando na porta $HTTP_PORT..."
    nohup $NODE_COMMAND $SERVER_SCRIPT > /dev/null 2>&1 &
    echo "Servidor iniciado na porta $HTTP_PORT."
fi
