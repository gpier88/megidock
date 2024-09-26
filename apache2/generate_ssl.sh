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
    server_ip=$(/usr/bin/dig +short megicart.it)
    actual_ip=$(/usr/bin/dig +short $domain)
    actual_ip_www=$(/usr/bin/dig +short www.$domain)
    if [ "$actual_ip" == "$server_ip" ] && [ "$actual_ip_www" == "$server_ip" ]; then
        echo "Il dominio e il dominio www puntano correttamente all'indirizzo IP del server."
    else
        echo "Attenzione: Il dominio o il dominio www non puntano all'indirizzo IP corretto del server."
        exit 1
    fi
}

# Funzione per controllare la configurazione di Apache2
check_apache_config() {
  /usr/sbin/apachectl configtest
  if [ $? -eq 0 ]; then
    echo "Configurazione Apache2 OK"
  else
    echo "Errore nella configurazione Apache2"
    exit 1
  fi
}

# Funzione per riavviare Apache2
restart_apache() {
  /etc/init.d/apache2 reload
  echo "Apache2 riavviato"
}

# Verifica l'indirizzo IP del dominio e del dominio www
check_domain_ip

# Controlla la configurazione di Apache2
check_apache_config

# Riavvia Apache2
restart_apache

# Genera il certificato SSL con Certbot
/usr/bin/certbot certonly --webroot -w /var/www/sites/$webroot/dist -d $domain -d www.$domain --non-interactive --agree-tos --email info@megicart.it

exit 0
