#!/bin/bash
# Questo andrà vesso in crontab che legge da un file di configurazione il nome a dominio e la cartella webroot
# e genera il certificato SSL con Certbot


# Script per generare il certificato SSL con Certbot
# Questo script deve essere eseguito con privilegi di root
# Per eseguirlo: sudo ./generate_ssl.sh

# Prendo i parametri passati
webroot=$1
domain=$2

 # Funzione per verificare l'indirizzo IP del dominio
check_domain_ip() {
    server_ip=$(dig +short megicart.it)
    actual_ip=$(dig +short $domain)
    actual_ip_www=$(dig +short www.$domain)
    if [ "$actual_ip" == "$server_ip" ] && [ "$actual_ip_www" == "$server_ip" ]; then
        echo "Il dominio e il dominio www puntano correttamente all'indirizzo IP del server."
    else
        echo "Attenzione: Il dominio o il dominio www non puntano all'indirizzo IP corretto del server."
        exit 1
    fi
}

# Verifica l'indirizzo IP del dominio e del dominio www
check_domain_ip

# Genera il certificato SSL con Certbot
certbot certonly --webroot -w /var/www/sites/$webroot/dist -d $domain -d www.$domain --non-interactive --agree-tos --email info@megicart.it

exit 0
