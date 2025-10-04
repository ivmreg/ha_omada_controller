FROM mbentley/omada-controller:beta-6.0

# Home Assistant specific labels
LABEL \
    io.hass.version="6.0" \
    io.hass.type="addon" \
    io.hass.arch="amd64|aarch64"

# Copy run script for Home Assistant integration
COPY run.sh /
RUN chmod a+x /run.sh

WORKDIR /
ENTRYPOINT [ "/run.sh" ]