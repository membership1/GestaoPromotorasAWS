#!/bin/bash
set -ex

EMAIL="kleber.andrade@gmail.com"
DOMAIN1="gestaopromo.com.br"
DOMAIN2="www.gestaopromo.com.br"
WEBROOT_PATH="/var/www/html"

# Instala o Certbot apenas se ele ainda não estiver instalado
if ! command -v certbot &> /dev/null
then
    echo "=== Instalando dependências e Certbot via PIP ==="
    sudo dnf install -y python3-pip gcc python3-devel
    sudo pip3 install certbot
fi

echo "=== Preparando o diretório webroot para validação ==="
sudo mkdir -p $WEBROOT_PATH
sudo chown -R ec2-user:webapp $WEBROOT_PATH # Garante que o Nginx possa ler
sudo chmod -R 755 $WEBROOT_PATH

echo "=== Gerando/Renovando certificado Let's Encrypt (modo Webroot) ==="
# O --deploy-hook reinicia o Nginx apenas se um novo certificado for emitido.
sudo certbot certonly --non-interactive --agree-tos \
    --email "$EMAIL" \
    --webroot -w $WEBROOT_PATH \
    -d "$DOMAIN1" -d "$DOMAIN2" \
    --deploy-hook "sudo systemctl reload nginx"

echo "=== Script de SSL concluído com sucesso! ==="