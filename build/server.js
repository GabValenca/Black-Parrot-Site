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

// Configuração para servir arquivos estáticos
app.use(express.static('/home/Black-Parrot-Site/build'));

// Middleware de redirecionamento
app.use((req, res, next) => {
  console.log('Middleware de redirecionamento chamado');
  if ((req.headers["x-forwarded-proto"] || "").endsWith("http")) {
    res.redirect(`https://${req.hostname}${req.url}`);
  } else {
    next();
  }
});

// Cria o servidor HTTPS
const httpsServer = https.createServer(credentials, app);

// Inicia o servidor HTTPS na porta 443
httpsServer.listen(443, () => {
  console.log(`${new Date().toLocaleString()} - Servidor HTTPS está rodando na porta 443`);
});


// Cria o servidor HTTP
//const httpServer = http.createServer(app);

// Inicia o servidor HTTP na porta 80
//httpServer.listen(80, () => {
//  console.log(`${new Date().toLocaleString()} - Servidor HTTP está rodando na porta 80`);
//});
