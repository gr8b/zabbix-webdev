#
# To use commands below uncomment and append following line at the end of ~/.bashrc or ~/.zshrc file:
# source ~/path/to/this/file/.bashrc
#
# When adding or editing existing function do not forget to reload:
# source ~/.bashrc
#

_get_compose_dir() {
    echo "$HOME/Documents/www/personal/gr8b/zabbix-webdev"
}

# Docker Compose alias
# Usage: dc [options] [command] [args]
# Example: dc up -d
dc() {
    local compose_dir="$(_get_compose_dir)"

    if [[ ! -f "$compose_dir/.env" ]]; then
        echo "Warning: .env file not found in $compose_dir"
        return 1
    fi

    docker-compose -f "$compose_dir/docker-compose.yml" "$@"
}

# Environment setup function
# Usage: envup [-d|--detach] <service1> <service2> ... <serviceN>
# Example: envup -d apache nginx phpfpm74
# Supported services: apache nginx phpfpm56 phpfpm74 phpfpm80 phpfpm83 mariadb mysql mysql-legacy
envup() {
    local detach=""

    if [[ "$1" == "-d" || "$1" == "--detach" ]]; then
        detach="-d"
        shift
    fi

    if [ $# -eq 0 ]; then
        echo "Usage: envup [-d|--detach] <service1> <service2> ... <serviceN>"
        echo "Supported services:"
        echo "apache nginx phpfpm56 phpfpm74 phpfpm80 phpfpm83 mariadb mysql mysql-legacy"
        return 1
    fi

    compose_dir="$(_get_compose_dir)"
    profiles=()

    for profile in "$@"; do
        profiles+=(--profile "$profile")
    done

    dc "${profiles[@]}" up $detach
}

# PHP 5.6 CLI
# Usage: php56 [options] [script.php]
# Example: php56 -v script.php
php56() {
    source "$(_get_compose_dir)/.env"

    if ! dc ps phpfpm56 | grep -q "Up"; then
        echo "Error: phpfpm56 service is not running"
        echo "Start it first with: envup phpfpm56"
        return 1
    fi

    dc exec phpfpm56 php -d variables_order=EGPCS -d error_reporting=E_ALL -d log_errors=On "$@"
}

# PHP 7.4 CLI
# Usage: php74 [options] [script.php]
# Example: php74 -v script.php
php74() {
    source "$(_get_compose_dir)/.env"

    if ! dc ps phpfpm74 | grep -q "Up"; then
        echo "Error: phpfpm74 service is not running"
        echo "Start it first with: envup phpfpm74"
        return 1
    fi

    dc exec phpfpm74 php -d variables_order=EGPCS -d error_reporting=E_ALL -d log_errors=On "$@"
}

# PHP 8.3 CLI
# Usage: php83 [options] [script.php]
# Example: php83 -v script.php
php83() {
    source "$(_get_compose_dir)/.env"

    if ! dc ps phpfpm83 | grep -q "Up"; then
        echo "Error: phpfpm83 service is not running"
        echo "Start it first with: envup phpfpm83"
        return 1
    fi

    dc exec phpfpm83 php -d variables_order=EGPCS -d error_reporting=E_ALL -d log_errors=On "$@"
}

composer() {
    source "$(_get_compose_dir)/.env"
    
    if ! dc ps phpfpm83 | grep -q "Up"; then
        echo "Error: phpfpm83 service is not running"
        echo "Start it first with: envup phpfpm83"
        return 1
    fi

    dc exec phpfpm83 composer "$@"
}