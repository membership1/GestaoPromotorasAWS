#!/bin/bash
set -e

EMAIL="kleber.andrade@gmail.com"
DOMAIN1="gestaopromo.com.br"
DOMAIN2="www.gestaopromo.com.br"

echo "=== Instalando Certbot ==="
sudo yum install -y epel-release
sudo amazon-linux-extras enable epel
sudo yum install -y certbot

echo "=== Gerando certificado Let's Encrypt ==="
sudo certbot certonly --non-interactive --agree-tos \
    --email "$EMAIL" \
    --standalone \
    -d "$DOMAIN1" -d "$DOMAIN2" \
    --keep-until-expiring

echo "=== Ajustando permissões ==="
sudo chmod 755 /etc/letsencrypt/live
sudo chmod 644 /etc/letsencrypt/live/$DOMAIN1/fullchain.pem
sudo chmod 600 /etc/letsencrypt/live/$DOMAIN1/privkey.pem

echo "=== Reiniciando Nginx ==="
sudo nginx -t && sudo nginx -s reload

echo "=== SSL configurado com sucesso ==="
