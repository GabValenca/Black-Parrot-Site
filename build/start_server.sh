#!/bin/bash

# Diretório onde o script está localizado
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Caminho para o arquivo JavaScript do servidor
SERVER_FILE="$SCRIPT_DIR/server.js"

# Certificado Privado & Público
PRIVATE_KEY="/home/Black-Parrot-Site/ssl/blackparrot.com.br/blackparrot.com.br.key"
PUBLIC_CERT="/home/Black-Parrot-Site/ssl/blackparrot.com.br/blackparrot.com.br.crt"

# Caminho para os certificados
CERTIFICATES_DIR="/home/Black-Parrot-Site/ssl/blackparrot.com.br"

# Diretório onde a aplicação está localizada
APP_DIR="/home/Black-Parrot-Site/build"

# Mude para o diretório do aplicativo
cd "$APP_DIR"

# Inicie o servidor Node.js na porta 443
nohup node "$SERVER_FILE" &

# Redirecione o tráfego HTTP (porta 80) para HTTPS (porta 443)
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
#sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 443

# Exiba mensagem informativa
echo "Servidor Node.js iniciado na porta 443."

# Aguarde o usuário pressionar Enter antes de sair
read -p "Pressione Enter para sair." -r
