ARG BUILD_FROM
FROM mbentley/omada-controller:beta-6.0

# Add bash and requirements for Home Assistant
RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        jq \
        curl \
        git \
    && mkdir -p /tmp/bashio \
    && curl -L -s "https://github.com/hassio-addons/bashio/archive/master.tar.gz" | tar -xzf - --strip 1 -C /tmp/bashio \
    && mv /tmp/bashio/lib/bashio.sh /usr/bin/bashio \
    && chmod a+x /usr/bin/bashio \
    && rm -rf /tmp/bashio \
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