cd /home/ben9652

export NVM_DIR="/bin/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
export PATH="$PATH:$NVM_DIR"
export BOERISFRONT="/home/ben9652/boeris-creaciones/boeris-creaciones-frontend/dist/boeris-creaciones-frontend/browser"
export BOERISAPI="/home/ben9652/boeris-creaciones/boeris-creaciones-backend/BoerisCreaciones.Api/bin/Dist/"


# Load Angular CLI autocompletion.
source <(ng completion script)
