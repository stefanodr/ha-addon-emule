FROM debian:bookworm-slim

ARG EMULE_VERSION=0.70b
ARG EMULE_SHA256=f21a078bfb46df1c87124cd91b545f92949a54795c615639e2cd647749b0235d

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        unzip \
        jq \
        procps \
        xvfb \
        x11vnc \
        openbox \
        novnc \
        websockify \
        winetricks \
        cabextract \
        wine64 \
        libwine \
        fonts-wine \
        fonts-liberation \
    && rm -rf /var/lib/apt/lists/*

# eMule Community (64-bit build), pinned and verified by checksum
RUN curl -fsSL -o /tmp/emule.zip \
        "https://github.com/irwir/eMule/releases/download/eMule_v${EMULE_VERSION}-community/emule${EMULE_VERSION}_x64.zip" \
    && echo "${EMULE_SHA256}  /tmp/emule.zip" | sha256sum -c - \
    && mkdir -p /opt/emule \
    && unzip -q /tmp/emule.zip -d /tmp/emule-unpacked \
    && cp -a /tmp/emule-unpacked/*/. /opt/emule/ \
    && rm -rf /tmp/emule.zip /tmp/emule-unpacked

# noVNC served through Home Assistant ingress
RUN cp -a /usr/share/novnc /opt/novnc
COPY rootfs/opt/novnc/index.html /opt/novnc/index.html

COPY run.sh /run.sh
RUN chmod +x /run.sh

EXPOSE 4662/tcp 4672/udp 8099/tcp

CMD ["/run.sh"]
