#!/usr/bin/with-contenv bashio

# Get config values
DATA_DIR=$(bashio::config 'omada_data_dir')

# Create required directories
mkdir -p "${DATA_DIR}"
mkdir -p "${DATA_DIR}/data"
mkdir -p "${DATA_DIR}/work"
mkdir -p "${DATA_DIR}/logs"
mkdir -p "${DATA_DIR}/cert"

# Set permissions
chown -R omada:omada "${DATA_DIR}"

# Set environment variables for mbentley/omada-controller
export OMADA_DATA_DIR="${DATA_DIR}/data"
export OMADA_WORK_DIR="${DATA_DIR}/work"
export OMADA_LOG_DIR="${DATA_DIR}/logs"
export OMADA_CERT_DIR="${DATA_DIR}/cert"
export MANAGE_HTTP_PORT=8088
export MANAGE_HTTPS_PORT=8043
export PORTAL_HTTP_PORT=8088
export PORTAL_HTTPS_PORT=8843
export SHOW_SERVER_LOGS=true
export SHOW_MONGODB_LOGS=false
export SSL_CERT_NAME="tls.crt"
export SSL_KEY_NAME="tls.key"
export TZ="$(bashio::config 'timezone' || echo 'UTC')"

# Execute the original entrypoint
exec /entrypoint.sh