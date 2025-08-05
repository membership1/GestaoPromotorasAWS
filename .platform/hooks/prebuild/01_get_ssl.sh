#!/bin/bash
set -e

EMAIL="kleber.andrade@gmail.com"
DOMAIN1="gestaopromo.com.br"
DOMAIN2="www.gestaopromo.com.br"

echo "=== Habilitando repositório EPEL para Amazon Linux 2023 ==="
# O Amazon Linux 2023 usa dnf e o repositório EPEL 9
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

echo "=== Instalando Certbot ==="
sudo dnf install -y certbot

echo "=== Gerando certificado Let's Encrypt ==="
# Verifica se o certificado já existe para evitar erros de limite de taxa
if [ ! -d "/etc/letsencrypt/live/$DOMAIN1" ]; then
    sudo certbot certonly --non-interactive --agree-tos \
        --email "$EMAIL" \
        --standalone \
        -d "$DOMAIN1" -d "$DOMAIN2" \
        --keep-until-expiring
else
    echo "Certificado já existe, pulando a criação."
fi

echo "=== Ajustando permissões ==="
sudo chmod -R 755 /etc/letsencrypt/live
sudo chmod -R 755 /etc/letsencrypt/archive

echo "=== Reiniciando Nginx ==="
# O Nginx será reiniciado automaticamente pelo Elastic Beanstalk, mas garantimos aqui
sudo nginx -t && sudo nginx -s reload || true

echo "=== SSL configurado com sucesso ==="