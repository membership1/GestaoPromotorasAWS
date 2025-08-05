#!/bin/bash
set -ex

EMAIL="kleber.andrade@gmail.com"
DOMAIN1="gestaopromo.com.br"
DOMAIN2="www.gestaopromo.com.br"
WEBROOT_PATH="/var/www/html"

echo "=== Instalando dependências via DNF ==="
sudo dnf install -y python3-pip gcc python3-devel

echo "=== Instalando Certbot via PIP (System-wide) ==="
sudo pip3 install certbot

echo "=== Preparando o diretório webroot para validação ==="
sudo mkdir -p $WEBROOT_PATH
sudo chown -R ec2-user:ec2-user $WEBROOT_PATH

echo "=== Gerando certificado Let's Encrypt (modo Webroot) ==="
if [ ! -d "/etc/letsencrypt/live/$DOMAIN1" ]; then
    echo "Certificado não encontrado. Obtendo um novo certificado..."
    sudo certbot certonly --non-interactive --agree-tos \
        --email "$EMAIL" \
        --webroot -w $WEBROOT_PATH \
        -d "$DOMAIN1" -d "$DOMAIN2"
else
    echo "Certificado já existe. Verificando a renovação."
    sudo certbot renew --quiet
fi

echo "=== Ajustando permissões finais para o Nginx ler o certificado ==="
sudo chmod -R 755 /etc/letsencrypt/

echo "=== Script de SSL concluído! O Nginx será configurado para usar o certificado. ==="