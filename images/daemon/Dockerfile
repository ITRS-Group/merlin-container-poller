FROM op5com/merlin-base:latest

ENV NAEMON_CFG=/etc/naemon/ MERLIN_CFG=/etc/merlin/ \
    MERLIN_SOCK=/var/lib/merlin/ipc.sock \
    NAEMON_UID=1001 NAEMON_GID=0

COPY shared_files/install.sh /usr/local/bin/install.sh
COPY daemon/default_config /usr/local/etc/merlin/default_config
RUN bash /usr/local/bin/install.sh

USER $NAEMON_UID
VOLUME /var/lib/merlin/

ENTRYPOINT ["/usr/local/bin/merlin_entry.sh"]
CMD ["/usr/bin/merlind", "--config", "/etc/merlin/merlin.conf", "--debug"]
