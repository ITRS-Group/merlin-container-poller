FROM centos:7

COPY shared_files/merlin-log.sh /usr/libexec/merlin-log.sh
COPY base/naemon_entry.sh /usr/local/bin/naemon_entry.sh
COPY base/naemon_startup.sh /usr/local/bin/naemon_startup.sh
COPY base/merlin_entry.sh /usr/local/bin/merlin_entry.sh
COPY base/nss_wrapper.sh /usr/local/bin/nss_wrapper.sh

# install tini
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/local/bin/tini
RUN chmod +x /usr/local/bin/tini

RUN yum install -y nss_wrapper gettext sudo epel-release && \
    yum clean all && rm -rf /var/cache/yum

# Set nss_wrapper enviorment variables. We set them here to ensure nss_wrapper
# is used in all cases, including when you open a manual shell on the container.
# nss_wrapper is always used, but the passd file is only edited if we are not
# running with the default user (changed in nss_wrapper.sh).
# For some reason $HOME does not get set correctly, so we set it here, too
RUN cp /etc/passwd /tmp/passwd && chmod g+w /tmp/passwd
ENV NSS_WRAPPER_PASSWD=/tmp/passwd NSS_WRAPPER_GROUP=/etc/group
