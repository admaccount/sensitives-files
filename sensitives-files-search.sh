#!/bin/bash

# Variables
LOG_FILE="script.log"
VERBOSE=0
EXCLUDE_DIRS=()
SPECIFIC_FILE=""
SINGLE_WORD=""
FILE_TYPES="*"

# Fonction pour afficher l'aide
show_help() {
    echo "Usage: $0 [-w <wordlist> | -sw <word>] [options]"
    echo ""
    echo "Options :"
    echo "  -w, --wordlist <file>        Fichier contenant les mots-clés à rechercher."
    echo "  -sw, --single-word <word>    Recherche un seul mot-clé spécifique."
    echo "  -f, --folder <path>          Dossier contenant les fichiers à analyser."
    echo "  -p, --path <path>            Dossier spécifique à analyser (exemple: un partage réseau)."
    echo "  -e, --exclude <path>         Exclure un dossier de la recherche (option répétable)."
    echo "  -file <file>                 Spécifie un fichier unique à analyser."
    echo "  -v, --verbose                Mode verbose: affiche la ligne où le mot est trouvé."
    echo "  -l, --log <file>             Spécifie un fichier de log personnalisé (par défaut: script.log)."
    echo "  -h, --help                   Affiche ce message d'aide."
    exit 0
}

# Fonction pour rechercher dans un fichier spécifique
search_in_file() {
    local file="$1"
    shift
    local keywords=("$@")
    local line_number=0

    if [[ ! -r "$file" ]]; then
        echo "⚠️ Impossible de lire le fichier '$file'. Vérifiez les permissions." >&2
        echo "[$(date)] ⚠️ Impossible de lire le fichier '$file'" >> "$LOG_FILE"
        return
    fi

    while IFS= read -r line; do
        ((line_number++))
        for word in "${keywords[@]}"; do
            if [[ "$line" == *"$word"* ]]; then
                if [[ $VERBOSE -eq 1 ]]; then
                    echo "✅ Mot trouvé : '$word' dans le fichier '$file' (ligne: $line_number) | Ligne: $line"
                else
                    echo "✅ Mot trouvé : '$word' dans le fichier '$file' (ligne: $line_number)"
                fi
                echo "[$(date)] Mot trouvé : '$word' dans le fichier '$file' (ligne $line_number)" >> "$LOG_FILE"
            fi
        done
    done < "$file"
}

# Fonction pour rechercher dans un dossier
search_in_folder() {
    local folder="$1"
    shift
    local keywords=("$@")

    if [[ ! -d "$folder" ]]; then
        echo "❌ Le dossier '$folder' n'existe pas." >&2
        return
    fi

    find "$folder" -type f | while read -r file; do
        # Vérifier si le fichier se trouve dans un dossier à exclure
        for exclude_dir in "${EXCLUDE_DIRS[@]}"; do
            if [[ "$file" == "$exclude_dir"* ]]; then
                continue 2
            fi
        done
        search_in_file "$file" "${keywords[@]}"
    done
}

# Fonction pour analyser un système complet
search_in_system() {
    check_root
    echo "🔍 Recherche sur l'ensemble du système. Cela peut prendre du temps..."
    search_in_folder "/" "${@}"
}

# Vérification des privilèges root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "❌ Ce script doit être exécuté avec des privilèges root (sudo)." >&2
        exit 1
    fi
}

# Analyse des arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -w|--wordlist)
            WORDLIST="$2"
            shift 2
            ;;
        -sw|--single-word)
            SINGLE_WORD="$2"
            shift 2
            ;;
        -f|--folder)
            FOLDER="$2"
            shift 2
            ;;
        -p|--path)
            PATH_TO_SCAN="$2"
            shift 2
            ;;
        -e|--exclude)
            EXCLUDE_DIRS+=("$2")
            shift 2
            ;;
        -file)
            SPECIFIC_FILE="$2"
            shift 2
            ;;
        -v|--verbose)
            VERBOSE=1
            shift
            ;;
        -l|--log)
            LOG_FILE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            ;;
        *)
            echo "❌ Option invalide : $1" >&2
            show_help
            ;;
    esac
done

# Vérifications de base
if [[ -n "$SINGLE_WORD" && -n "$WORDLIST" ]]; then
    echo "❌ Vous ne pouvez pas utiliser à la fois -w (wordlist) et -sw (single word)." >&2
    exit 1
fi

if [[ -z "$SINGLE_WORD" && -z "$WORDLIST" ]]; then
    echo "❌ Une wordlist ou un mot unique est obligatoire. Utilisez -w ou -sw pour spécifier." >&2
    show_help
fi

# Charger les mots-clés depuis la wordlist ou l'option single word
if [[ -n "$SINGLE_WORD" ]]; then
    KEYWORDS=("$SINGLE_WORD")
else
    if [[ ! -f "$WORDLIST" ]]; then
        echo "❌ Le fichier wordlist '$WORDLIST' n'existe pas." >&2
        exit 1
    fi
    KEYWORDS=()
    while IFS= read -r word; do
        [[ -n "$word" ]] && KEYWORDS+=("$word")
    done < "$WORDLIST"

    if [[ ${#KEYWORDS[@]} -eq 0 ]]; then
        echo "❌ La wordlist est vide." >&2
        exit 1
    fi
fi

# Recherche dans un fichier spécifique
if [[ -n "$SPECIFIC_FILE" ]]; then
    if [[ ! -f "$SPECIFIC_FILE" ]]; then
        echo "❌ Le fichier spécifié '$SPECIFIC_FILE' n'existe pas." >&2
        exit 1
    fi
    search_in_file "$SPECIFIC_FILE" "${KEYWORDS[@]}"
    exit 0
fi

# Recherche dans un dossier
if [[ -n "$FOLDER" ]]; then
    search_in_folder "$FOLDER" "${KEYWORDS[@]}"
fi

# Recherche dans un chemin spécifique
if [[ -n "$PATH_TO_SCAN" ]]; then
    search_in_folder "$PATH_TO_SCAN" "${KEYWORDS[@]}"
fi

# Si aucune option n'a été spécifiée, afficher l'aide
if [[ -z "$FOLDER" && -z "$PATH_TO_SCAN" && -z "$SPECIFIC_FILE" ]]; then
    echo "❌ Vous devez spécifier un fichier, un dossier ou un chemin." >&2
    show_help
fi

