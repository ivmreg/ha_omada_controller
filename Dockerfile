ARG BUILD_FROM=mbentley/omada-controller:beta-6.0
FROM ${BUILD_FROM}

# Add Home Assistant CLI
RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        jq \
        curl \
    && curl -Lso /usr/bin/ha "https://github.com/home-assistant/cli/releases/latest/download/ha_linux_$(uname -m)" \
    && chmod a+x /usr/bin/ha \
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