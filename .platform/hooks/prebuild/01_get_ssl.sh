#!/bin/bash
set -ex

EMAIL="kleber.andrade@gmail.com"
DOMAIN1="gestaopromo.com.br"
DOMAIN2="www.gestaopromo.com.br"

echo "=== Instalando dependências via DNF ==="
# Instala o PIP para Python 3, e ferramentas de desenvolvimento
sudo dnf install -y python3-pip gcc python3-devel

echo "=== Instalando Certbot via PIP (System-wide) ==="
# Instala somente o Certbot, sem o plugin do Nginx que não usaremos para validação
sudo pip3 install certbot

echo "=== Gerando certificado Let's Encrypt (modo Standalone) ==="
# Verifica se o certificado já existe para evitar atingir os limites
if [ ! -d "/etc/letsencrypt/live/$DOMAIN1" ]; then
    echo "Certificado não encontrado. Obtendo um novo certificado..."
    
    # GARANTE QUE O NGINX NÃO ESTÁ RODANDO PARA LIBERAR A PORTA 80
    # O '|| true' evita que o script falhe se o nginx já estiver parado.
    sudo systemctl stop nginx || true
    
    # Executa o Certbot no modo 'standalone', que usa sua própria porta 80
    sudo certbot certonly --non-interactive --agree-tos \
        --email "$EMAIL" \
        --standalone \
        -d "$DOMAIN1" -d "$DOMAIN2"
else
    echo "Certificado já existe. Verificando a renovação."
    sudo certbot renew --quiet
fi

echo "=== Ajustando permissões finais ==="
sudo chmod -R 755 /etc/letsencrypt/

echo "=== Script de SSL concluído com sucesso! O Elastic Beanstalk iniciará e configurará o Nginx. ==="