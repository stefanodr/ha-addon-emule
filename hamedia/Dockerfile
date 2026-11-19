# --- Stage 1: rebuild Debian's MiniDLNA with the HaMedia icons --------------
# MiniDLNA embeds the icons it advertises to TVs in its binary and has no
# option to change them, so the package is rebuilt with the four images
# replaced (sm/lrg, png/jpg).
FROM debian:bookworm-slim AS builder
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8
RUN set -eux; \
    if [ -f /etc/apt/sources.list.d/debian.sources ]; then \
        sed -i 's/^Types: deb$/Types: deb deb-src/' /etc/apt/sources.list.d/debian.sources; \
    else \
        sed -n 's/^deb /deb-src /p' /etc/apt/sources.list >> /etc/apt/sources.list; \
    fi; \
    apt-get update; \
    apt-get install -y --no-install-recommends build-essential dpkg-dev fakeroot python3 ca-certificates; \
    apt-get build-dep -y minidlna
WORKDIR /build
RUN apt-get source minidlna
COPY patch_icons.py /patch_icons.py
COPY icons /icons
RUN set -eux; \
    cd /build/minidlna-*/; \
    python3 /patch_icons.py icons.c /icons; \
    DEB_BUILD_OPTIONS=nocheck dpkg-buildpackage -b -uc -us; \
    ls -l /build/minidlna_*.deb

# --- Stage 2: runtime -------------------------------------------------------
FROM debian:bookworm-slim
ENV DEBIAN_FRONTEND=noninteractive LANG=C.UTF-8
COPY --from=builder /build/minidlna_*.deb /tmp/
RUN apt-get update \
    && apt-get install -y --no-install-recommends /tmp/minidlna_*.deb jq ca-certificates \
    && rm -rf /var/lib/apt/lists/* /tmp/*.deb
COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD ["/run.sh"]
