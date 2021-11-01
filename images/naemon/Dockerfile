FROM op5com/merlin-base:latest

ENV NAEMON_CFG=/etc/naemon/ MERLIN_CFG=/etc/merlin/ \
    MERLIN_SOCK=/var/lib/merlin/ipc.sock \
    NAEMON_UID=1001 NAEMON_GID=0

COPY shared_files/install.sh /usr/local/bin/install.sh
RUN bash /usr/local/bin/install.sh

# Install newer versions of dependencies needed for running cluster_tools
RUN pip3 install --no-cache-dir -U pip==21.0.1
RUN pip3 install --no-cache-dir cryptography==3.4.6 paramiko==2.7.2 docopt==0.6.2

# clear some of the naemon config, which will be replaced from default_config
# during the entrypoint script
RUN rm -rf $NAEMON_CFG/oconf/ $NAEMON_CFG/module-conf.d/ $NAEMON_CFG/naemon.cfg

USER $NAEMON_UID
COPY naemon/default_config /usr/local/etc/naemon/default_config
VOLUME /var/lib/merlin/
ENTRYPOINT ["/usr/local/bin/naemon_entry.sh"]
CMD ["/usr/local/bin/naemon_startup.sh"]
