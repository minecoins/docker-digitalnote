FROM ubuntu:16.04

ENV DIGITALNOTE_VERSION 4.0.0-beta

RUN set -x \
    && buildDeps=' \
        ca-certificates \
        curl \
    ' \
    && apt-get -qq update \
    && apt-get -qq --no-install-recommends install $buildDeps \
    && rm -rf /var/lib/apt/lists/* \
    \
    && curl -sL https://github.com/xdn-project/digitalnote/releases/download/v$DIGITALNOTE_VERSION/digitalnote_linux_$DIGITALNOTE_VERSION.tar.gz | tar -xz -C /usr/local/bin/ \
    \
    && apt-get -qq --auto-remove purge $buildDeps

# Contains the blockchain
VOLUME /root/.digitalnote

# Generate your wallet via accessing the container and run:
# cd /wallet
# simplewallet
VOLUME /wallet

ENV LOG_LEVEL 2
ENV P2P_BIND_IP 0.0.0.0
ENV P2P_BIND_PORT 42080
ENV RPC_BIND_IP 127.0.0.1
ENV RPC_BIND_PORT 42081

EXPOSE 42080
EXPOSE 42081

CMD exec digitalnoted --log-level=$LOG_LEVEL --log-file=/root/.digitalnote/digitalnoted.log --p2p-bind-ip=$P2P_BIND_IP --p2p-bind-port=$P2P_BIND_PORT --rpc-bind-ip=$RPC_BIND_IP --rpc-bind-port=$RPC_BIND_PORT
