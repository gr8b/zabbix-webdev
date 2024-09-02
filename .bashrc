#
# To use commands below uncomment and append following line at the end of ~/.bashrc file:
# . ~/path/to/this/file/.bashrc
#
# When adding or editing existing function do not forget to reload:
# source ~/.bashrc
#

envup() {
    if [ $# -eq 0 ]; then
        echo "Usage: envup <service1> <service2> ... <serviceN>"
        echo "Supported services:"
        echo "apache nginx phpfpm56 phpfpm74 phpfpm80 phpfpm83 mariadb mysql mysql-legacy"
        return 1
    fi

    compose_dir="$(dirname "${BASH_SOURCE[0]}")"
    profiles=""

    for profile in "$@"; do
    profiles+=" --profile $profile"
    done

    docker-compose -f $compose_dir/docker-compose.yml $profiles up
}