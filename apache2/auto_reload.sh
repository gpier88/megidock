#!/bin/bash

# Specifica il percorso della cartella da controllare
directory="/var/www/vhosts"

# Controlla se ci sono file modificati negli ultimi 5 minuti
if find "$directory" -type f -mmin -5 | read; then
    # Esegui il comando "apache reload"
    /etc/init.d/apache2 reload
fi
