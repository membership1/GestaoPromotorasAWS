#!/bin/bash
set -e

EMAIL="kleber.andrade@gmail.com"
DOMAIN1="gestaopromo.com.br"
DOMAIN2="www.gestaopromo.com.br"

echo "=== Instalando repositório EPEL para Amazon Linux 2023 ==="
# Instala o pacote que define o repositório EPEL.
# A flag --nogpgcheck é por vezes necessária em ambientes de build.
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm --nogpgcheck

echo "=== Instalando Certbot ==="
# A flag --allowerasing ajuda a resolver quaisquer conflitos.
sudo dnf install -y certbot python3-certbot-nginx --allowerasing

echo "=== Gerando certificado Let's Encrypt ==="
if [ ! -d "/etc/letsencrypt/live/$DOMAIN1" ]; then
    # Usaremos o plugin do Nginx, que é mais robusto que o standalone.
    # Ele modifica a configuração do Nginx automaticamente.
    sudo certbot --nginx --non-interactive --agree-tos \
        --email "$EMAIL" \
        -d "$DOMAIN1" -d "$DOMAIN2"
else
    echo "Certificado já existe, pulando a criação."
fi

echo "=== Ajustando permissões (se necessário) ==="
sudo chmod -R 755 /etc/letsencrypt/live
sudo chmod -R 755 /etc/letsencrypt/archive

echo "=== SSL configurado com sucesso pelo Certbot ==="