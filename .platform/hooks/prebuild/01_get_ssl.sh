#!/bin/bash
set -e

EMAIL="kleber.andrade@gmail.com"
DOMAIN1="gestaopromo.com.br"
DOMAIN2="www.gestaopromo.com.br"

echo "=== Instalando dependências para o ambiente virtual do Certbot ==="
# Instala o pacote python3-venv, que é essencial para criar ambientes virtuais com o comando 'python3 -m venv'
sudo dnf install -y python3-venv gcc python3-devel

echo "=== Preparando uma instalação autocontida do Certbot ==="
# 1. Cria um ambiente virtual para o Certbot não interferir com a aplicação
sudo python3 -m venv /opt/certbot_venv

# 2. Ativa o ambiente e instala o Certbot usando pip
sudo /opt/certbot_venv/bin/pip install --upgrade pip
sudo /opt/certbot_venv/bin/pip install certbot

# 3. Cria um link simbólico para facilitar a execução do comando
sudo ln -sf /opt/certbot_venv/bin/certbot /usr/bin/certbot

echo "=== Gerando certificado Let's Encrypt ==="
# Verifica se o certificado já existe para evitar atingir os limites de taxa
if [ ! -d "/etc/letsencrypt/live/$DOMAIN1" ]; then
    echo "Certificado não encontrado. Obtendo um novo certificado..."
    # Para o Nginx temporariamente para liberar a porta 80 para a validação
    sudo systemctl stop nginx || true
    
    # Executa o Certbot no modo 'standalone'
    sudo certbot certonly --non-interactive --agree-tos \
        --email "$EMAIL" \
        --standalone \
        -d "$DOMAIN1" -d "$DOMAIN2"
        
    # Inicia o Nginx novamente
    sudo systemctl start nginx || true
else
    echo "Certificado já existe. Pulando a criação."
fi

echo "=== Ajustando permissões finais ==="
sudo chmod -R 755 /etc/letsencrypt/

echo "=== Script de SSL concluído com sucesso! ==="