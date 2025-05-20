#!/bin/bash
set -x

# Valores por defecto desde git config
GIT_USERNAME=$(git config user.name)
GIT_USEREMAIL=$(git config user.email)
GIT_SSHKEY=~/.ssh/id_rsa

# Verifica si se necesita sudo para usar docker
SUDO_STRING=$(groups | grep docker)
SUDO=""
if [ -z "$SUDO_STRING" ]; then
  SUDO="sudo "
fi

# Parseo de argumentos
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--user)
            GIT_USERNAME="$2"
            shift 2
            ;;
        -e|--email)
            GIT_USEREMAIL="$2"
            shift 2
            ;;
        --help)
            echo "Uso: build.sh [--user GIT_USERNAME] [--email GIT_EMAIL]"
            exit 0
            ;;
        --)
            shift
            break
            ;;
        -*|--*)
            echo "Opción desconocida: $1"
            exit 1
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

# Construcción de la imagen con Docker BuildKit y soporte SSH
DOCKER_BUILDKIT=1 $SUDO docker build \
  --build-arg GIT_USERNAME="$GIT_USERNAME" \
  --build-arg GIT_USEREMAIL="$GIT_USEREMAIL" \
  --ssh default=$GIT_SSHKEY \
  -t learning_humanoid_walking:ubuntu24.04 .
