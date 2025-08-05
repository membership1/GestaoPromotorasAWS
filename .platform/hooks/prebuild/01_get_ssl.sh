#!/bin/bash
set -ex

EMAIL="kleber.andrade@gmail.com"
DOMAIN1="gestaopromo.com.br"
DOMAIN2="www.gestaopromo.com.br"

# Instala o Certbot e o plugin do Nginx apenas se ainda não estiverem instalados
if ! command -v certbot &> /dev/null
then
    echo "=== Instalando dependências e Certbot via PIP ==="
    sudo dnf install -y python3-pip gcc python3-devel lsof
    sudo pip3 install certbot certbot-nginx
fi

echo "=== Verificando e liberando a porta 80 ==="
# Tenta parar o Nginx de forma padrão primeiro
sudo systemctl stop nginx || true
# Força a parada de qualquer processo que ainda esteja na porta 80
sudo fuser -k 80/tcp || true

echo "=== Gerando/Renovando certificado (modo Standalone) ==="
# --standalone é mais confiável quando podemos garantir que a porta 80 está livre
sudo certbot certonly --standalone --non-interactive --agree-tos \
    --email "$EMAIL" \
    -d "$DOMAIN1" -d "$DOMAIN2"

echo "=== Script de SSL concluído com sucesso! O Elastic Beanstalk iniciará o Nginx com a configuração correta. ==="