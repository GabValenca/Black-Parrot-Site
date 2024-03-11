const express = require('express');
const https = require('https');
const http = require('http');
const fs = require('fs');
const path = require('path'); // Importe o módulo 'path' do Node.js

const app = express();

// Roteamento para a aplicação
app.get('/', (req, res) => {
  // Use o método sendFile para enviar o conteúdo do arquivo HTML
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Certificado privado e público
const privateKey = fs.readFileSync('/etc/ssl/blackparrot.com.br/blackparrot.com.br.key', 'utf8');
const certificate = fs.readFileSync('/etc/ssl/blackparrot.com.br/blackparrot.com.br.crt', 'utf8');

const credentials = { key: privateKey, cert: certificate };

// Inicia o servidor HTTP para redirecionar automaticamente para HTTPS
const httpServer = http.createServer((req, res) => {
  res.writeHead(301, { 'Location': 'https://' + req.headers.host + req.url });
  res.end();
});

// Inicia o servidor HTTP na porta 80
httpServer.listen(80, () => {
  console.log('Servidor HTTP está rodando na porta 80 (redirecionando para HTTPS)');
});

// Configuração para servir arquivos estáticos
app.use(express.static('/home/Black-Parrot-Site/build'));

// Cria o servidor HTTPS
const httpsServer = https.createServer(credentials, app);

// Inicia o servidor HTTPS na porta 443
httpsServer.listen(443, () => {
  console.log('Servidor HTTPS está rodando na porta 443');
});

app.listen(3000, function() {
  console.log('Servidor rodando na porta 3000');
});
