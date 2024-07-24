#!/bin/bash

# Definisci il percorso del lock file in /tmp
LOCK_FILE="/tmp/generate_ssl.lock"

# Intervallo di tempo massimo in minuti per il lock file
MAX_LOCK_AGE_MINUTES=60

# Funzione ricorsiva per cercare il file "certificates.run" nelle sottocartelle di "sites/"
search_certificates() {
    local dir="/var/www/sites"

    # Cicla tutte le sottocartelle di "sites/"
    for sub_dir in "$dir"/*; do
        if [[ -d "$sub_dir" ]]; then
            # Controlla se il file "certificates.run" esiste nella sottocartella corrente
            if [[ -f "$sub_dir/certificates.run" ]]; then
                # Esegue il comando specificato nel file "certificates.run"
                source "$sub_dir/certificates.run"

                # Cancella il file "certificates.run"
                rm "$sub_dir/certificates.run"
            fi
        fi
    done
}

# Esegue la funzione di ricerca a partire dalla cartella "sites/"
search_certificates