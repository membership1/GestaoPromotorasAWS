#!/bin/bash
set -ex

EMAIL="kleber.andrade@gmail.com"
DOMAIN1="gestaopromo.com.br"
DOMAIN2="www.gestaopromo.com.br"
WEBROOT_PATH="/var/www/html"

# Instala o Certbot e o plugin do Nginx apenas se ainda não estiverem instalados
if ! command -v certbot &> /dev/null
then
    echo "=== Instalando dependências e Certbot via PIP ==="
    sudo dnf install -y python3-pip gcc python3-devel
    sudo pip3 install certbot certbot-nginx
fi

echo "=== Preparando o diretório webroot para validação ==="
sudo mkdir -p $WEBROOT_PATH
sudo chown -R nginx:nginx $WEBROOT_PATH

echo "=== Gerando/Renovando certificado (modo Nginx) ==="
# O plugin --nginx vai ler nossa configuração, fazer a validação e instalar o certificado
sudo certbot --nginx --non-interactive --agree-tos \
    --email "$EMAIL" \
    -d "$DOMAIN1" -d "$DOMAIN2"

echo "=== Script de SSL concluído com sucesso! ==="