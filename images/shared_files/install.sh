#!/bin/bash

useradd -l -g "$NAEMON_GID" -u "$NAEMON_UID" -s /bin/bash -M naemon -d /var/lib/naemon/

curl https://download.opensuse.org/repositories/home:/itrs-op5/CentOS_7/home:itrs-op5.repo -o /etc/yum.repos.d/merlin.repo
curl https://download.opensuse.org/repositories/home:/naemon/CentOS_7/home:naemon.repo -o /etc/yum.repos.d/naemon.repo
yum install -y naemon-core naemon-livestatus merlin-slim monitor-merlin-slim merlin-apps-slim && \
  yum clean all && \
  rm -rf /var/cache/yum

# set permissions:
chown -R "$NAEMON_UID" "$MERLIN_CFG"
chown -R "$NAEMON_UID" "$NAEMON_CFG"

# Get rid of default merlin.conf, we'll replace by the default_config during the
# entry script
rm "$MERLIN_CFG/merlin.conf"
