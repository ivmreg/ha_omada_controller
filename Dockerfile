ARG BUILD_FROM
FROM mbentley/omada-controller:beta-6.0

# Add bash for Home Assistant scripts
RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        jq \
        curl \
    && curl -sLf -o /usr/bin/bashio "https://github.com/hassio-addons/bashio/raw/master/lib/bashio.sh" \
    && chmod a+x /usr/bin/bashio \
    && rm -rf /var/lib/apt/lists/*

# Home Assistant specific labels
LABEL \
    io.hass.version="6.0" \
    io.hass.type="addon" \
    io.hass.arch="amd64|aarch64"

# Copy root filesystem
COPY rootfs /

WORKDIR /
ENTRYPOINT ["/init"]