#!/bin/bash
set -e

EMAIL="kleber.andrade@gmail.com"
DOMAIN1="gestaopromo.com.br"
DOMAIN2="www.gestaopromo.com.br"

echo "=== Habilitando repositórios CodeReady Builder e EPEL para Amazon Linux 2023 ==="
# Habilita o repositório CRB que contém dependências para o EPEL
sudo dnf config-manager --set-enabled codeready-builder-for-rhel-9-x86_64-rpms

# Instala o pacote de release do EPEL. A flag --allowerasing ajuda com conflitos.
sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm -y --allowerasing

echo "=== Instalando Certbot e o plugin para Nginx ==="
sudo dnf install -y certbot python3-certbot-nginx

echo "=== Gerando certificado Let's Encrypt ==="
# Verifica se o certificado já existe para evitar atingir limites de taxa
if [ ! -d "/etc/letsencrypt/live/$DOMAIN1" ]; then
    # O plugin --nginx modifica a configuração do Nginx automaticamente para a validação.
    sudo certbot --nginx --non-interactive --agree-tos \
        --email "$EMAIL" \
        -d "$DOMAIN1" -d "$DOMAIN2"
else
    echo "Certificado já existe, pulando a criação."
fi

echo "=== Ajustando permissões finais ==="
sudo chmod -R 755 /etc/letsencrypt/

echo "=== SSL configurado com sucesso! O Elastic Beanstalk reiniciará o Nginx. ==="