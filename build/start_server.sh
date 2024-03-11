#!/bin/bash

# Diretório onde o script está localizado
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Caminho para o arquivo JavaScript do servidor
SERVER_FILE="$SCRIPT_DIR/server.js"

# Certificado Privado
PRIVATE_KEY="/etc/ssl/blackparrot.com.br/blackparrot.com.br.key"

# Certificado Público
PUBLIC_CERT="/etc/ssl/blackparrot.com.br/blackparrot.com.br.crt"

# Caminho para os certificados
CERTIFICATES_DIR="/etc/ssl/blackparrot.com.br"

# Certificado Chain (opcional)
# CERTIFICATE_CHAIN="/etc/ssl/blackparrot.com.br/chain.pem"

# Diretório onde a aplicação está localizada
APP_DIR="/home/Black-Parrot-Site/build"  # Substitua 'username' pelo seu nome de usuário real

# Mude para o diretório do aplicativo
cd "$APP_DIR"

# Instale as dependências (se necessário)
npm install

# Inicie o servidor Node.js na porta 443
node "$SERVER_FILE" &

# Redirecione o tráfego HTTP (porta 80) para HTTPS (porta 443)
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
udo iptables -A INPUT -p tcp --dport 3000 -j ACCEPT
sudo iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 443

# Exiba mensagem informativa
echo "Servidor Node.js iniciado na porta 443."

# Aguarde o usuário pressionar Enter antes de sair
read -p "Pressione Enter para sair." -r
