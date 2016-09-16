#!/bin/sh
set -e

chown -R ${SERVICE_UID}:${SERVICE_GID} ${SERVICE_HOME_DIR}
SERVICE_PIDFILE="/var/run/etcd.pid"

#function service_start {
  # Environment Variables Configuration
  export $(cat /etc/etcd/etcd.conf | \
           grep -v ^# | \
           sed -e 's/"//g')
  
  # 

#}

chown -R ${SERVICE_UID}:${SERVICE_GID} ${SERVICE_HOME_DIR}

SERVICE_PIDFILE="/var/run/etcd.pid"

case ${1} in
  start)
#    if [ ! -f ${SERVICE_PIDFILE} ]; then
      exec su etcd -s /bin/sh -c 'nohup etcd' && \
      pid=$!
      touch ${SERVICE_PIDFILE}
      echo ${pid} > ${SERVICE_PIDFILE}
      echo "etcd Service Started"
#    else
#      echo "etcd Service Running"
#    fi
  ;;

  status)
    SERVICE_PROC=$(ps -eo pid,comm | grep -E "^.*etcd" | awk '{print $2}')
    if [ -f ${SERVICE_PIDFILE} -a "etcd" = ${SERVICE_PROC} ]; then
      echo "etcd Service Running"
    else
      echo "etcd Service Stop"
    fi
  ;;

  stop)
    kill -9 $(cat ${SERVICE_PIDFILE})
    echo "etcd Service Stopped"
  ;;

  *)
    exec *
  ;;

esac
