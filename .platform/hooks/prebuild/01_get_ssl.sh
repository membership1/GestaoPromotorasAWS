#!/bin/bash
set -ex

EMAIL="kleber.andrade@gmail.com"
DOMAIN1="gestaopromo.com.br"
DOMAIN2="www.gestaopromo.com.br"

echo "=== Instalando dependências via DNF ==="
# Instala o PIP para Python 3, e ferramentas de desenvolvimento que o Certbot pode precisar
sudo dnf install -y python3-pip gcc python3-devel

echo "=== Instalando Certbot e o plugin do Nginx via PIP (System-wide) ==="
# Como o venv não está disponível, instalamos diretamente no sistema
sudo pip3 install certbot certbot-nginx

echo "=== Gerando certificado Let's Encrypt ==="
# Verifica se o certificado já existe
if [ ! -d "/etc/letsencrypt/live/$DOMAIN1" ]; then
    echo "Certificado não encontrado. Obtendo um novo certificado..."
    
    # Executa o Certbot com o plugin do Nginx
    # O plugin vai encontrar a configuração do Nginx e modificá-la automaticamente
    # para a validação e instalação do certificado.
    sudo certbot --nginx --non-interactive --agree-tos \
        --email "$EMAIL" \
        -d "$DOMAIN1" -d "$DOMAIN2"
else
    echo "Certificado já existe. Garantindo que está renovado e reinstalado."
    # O comando renew garante que o certificado está válido.
    sudo certbot renew --quiet
fi

echo "=== Script de SSL concluído com sucesso! O Nginx será reiniciado pelo Elastic Beanstalk. ==="