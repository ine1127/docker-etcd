FROM docker.io/alpine:latest
MAINTAINER ine1127

ENV PROXY="" \
    HTTP_PROXY="" \
    HTTPS_PROXY="" \
    FTP_PROXY="" \
    NO_PROXY=""

ENV http_proxy=${HTTP_PROXY:-${PROXY}} \
    HTTP_PROXY=${HTTP_PROXY:-${PROXY}} \
    https_proxy=${HTTPS_PROXY:-${PROXY}} \
    HTTPS_PROXY=${HTTPS_PROXY:-${PROXY}} \
    ftp_proxy="" \
    FTP_PROXY="" \
    all_proxy=${PROXY} \
    ALL_PROXY=${PROXY} \
    no_proxy=${NO_PROXY} \
    NO_PROXY=${NO_PROXY} \

    SERVICE_NAME="etcd" \
    SERVICE_VERSION="2.3.7" \
    SERVICE_ARCH="linux-amd64" \
    SERVICE_DIR="/usr/local/sbin"

ENV SERVICE_UID="800" \
    SERVICE_GID="800" \
    SERVICE_USER=${SERVICE_NAME} \
    SERVICE_GROUP=${SERVICE_NAME} \
    SERVICE_HOME_DIR="/var/lib/${SERVICE_NAME}" \
    SERVICE_USER_COMMENT="exec_etcd" \
    SERVICE_LOGIN_SHELL="/sbin/nologin"
    SERVICE_CONF_DIR="/etc/${SERVICE_NAME}" \
    SERVICE_RELEASES="${SERVICE_NAME}-v${SERVICE_VERSION}-${SERVICE_ARCH}"

ENV SERVICE_URL="https://github.com/coreos/etcd/releases/download/v${SERVICE_VERSION}/${SERVICE_RELEASES}.tar.gz"

RUN mkdir ${SERVICE_CONF_DIR} && \
    mkdir ${SERVICE_DIR} && \
    apk update && \
    apk add curl && \
    curl -x ${PROXY} -jksSL ${SERVICE_URL} -o /tmp/${SERVICE_RELEASES}.tar.gz && \
    tar zxvf ${SERVICE_RELEASES}.tar.gz -C /tmp && \
    addgroup -g ${SERVICE_GID} -S ${SERVICE_GROUP} && \
    adduser -D \
            -u ${SERVICE_UID} \
            -g ${SERVICE_USER_COMMENT} \
            -h ${SERVICE_HOME_DIR} \
            -s ${SERVICE_LOGIN_SHELL} \
            -G ${SERVICE_GROUP} \
            -S ${SERVICE_USER} && \
    mv /tmp/${SERVICE_RELEASES}/etcd ${SERVICE_DIR}/etcd && \
    mv /tmp/${SERVICE_RELEASES}/etcdctl ${SERVICE_DIR}/etcdctl

VOLUME ["${SERVICE_HOME_DIR}", "${SERVICE_CONF_DIR}"]
EXPOSE 2379 2380 

COPY entrypoint.sh ${SERVICE_DIR}/entrypoint.sh

ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]
CMD ["start"]
