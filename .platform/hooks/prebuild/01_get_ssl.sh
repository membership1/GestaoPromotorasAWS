#!/bin/bash
set -e

EMAIL="kleber.andrade@gmail.com"
DOMAIN1="gestaopromo.com.br"
DOMAIN2="www.gestaopromo.com.br"

echo "=== Habilitando repositório EPEL para Amazon Linux 2023 ==="
# O método correto para AL2023 é usar o config-manager
sudo dnf config-manager --set-enabled epel

echo "=== Instalando Certbot ==="
# --allowerasing é adicionado para resolver possíveis conflitos de pacotes
sudo dnf install -y certbot --allowerasing

echo "=== Gerando certificado Let's Encrypt ==="
# Verifica se o certificado já existe para evitar erros de limite de taxa
if [ ! -d "/etc/letsencrypt/live/$DOMAIN1" ]; then
    # --standalone requer que a porta 80 esteja livre, então paramos o Nginx temporariamente
    sudo systemctl stop nginx || true
    sudo certbot certonly --non-interactive --agree-tos \
        --email "$EMAIL" \
        --standalone \
        -d "$DOMAIN1" -d "$DOMAIN2"
    sudo systemctl start nginx || true
else
    echo "Certificado já existe, pulando a criação."
fi

echo "=== Ajustando permissões ==="
sudo chmod -R 755 /etc/letsencrypt/live
sudo chmod -R 755 /etc/letsencrypt/archive

echo "=== Reiniciando Nginx ==="
# O Nginx será reiniciado automaticamente pelo Elastic Beanstalk mais tarde,
# mas esta é uma garantia caso seja necessário.
sudo nginx -t && sudo nginx -s reload || true

echo "=== SSL configurado com sucesso ==="