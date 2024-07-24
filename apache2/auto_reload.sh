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

# Controlla se ci sono file modificati negli ultimi 5 minuti
if find "$directory" -type f -mmin -2 | read; then
    # Controlla la configurazione di Apache2
    check_apache_config

    # Riavvia Apache2
    restart_apache
fi
