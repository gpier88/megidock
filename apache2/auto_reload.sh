#!/bin/bash

# Specifica il percorso della cartella da controllare
directory="/var/www/vhosts"

# Funzione per controllare la configurazione di Apache2
check_apache_config() {
  apachectl configtest
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

# se esiste il file "reload_apache" nella cartella specificata
# allora controlla la configurazione di Apache2 e riavvia il servizio
if [[ -f "$directory/reload_apache.run" ]] || [[ "$1" == "--force" ]]; then
  # Controlla la configurazione di Apache2
  check_apache_config

  # Riavvia Apache2
  restart_apache

  # Cancella il file "reload_apache.run" se esiste
  if [[ -f "$directory/reload_apache.run" ]]; then
    rm "$directory/reload_apache.run"
  fi
fi
