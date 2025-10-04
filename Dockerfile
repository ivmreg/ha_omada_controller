ARG BUILD_FROM
FROM mbentley/omada-controller:beta-6.0

# Add bash and requirements for Home Assistant
RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        jq \
    && rm -rf /var/lib/apt/lists/*

# Home Assistant specific labels
LABEL \
    io.hass.version="6.0" \
    io.hass.type="addon" \
    io.hass.arch="amd64|aarch64"

# Copy root filesystem
COPY rootfs /
