#!/bin/sh

CPU="${CPU:-1000000}"
MEMORY="${MEMORY:-50}"
DISK_READ="${DISK:-100}"
DISK_WRITE="${DISK:-100}"
WAN_RECEIVE="${WAN_RECEIVE:-100}"
WAN_TRANSMIT="${WAN_TRANSMIT:-10}"


log(){
  echo [`date +"%Y-%m-%dT%TZ"`] $*
}

cpu(){
  log "CPU: running through $CPU iterations"
  COUNTER=0
  while [  $COUNTER -lt $CPU ]; do
    let COUNTER=COUNTER+1
  done
  log "CPU: run completed"
}

memory(){
  log "Memory: loading $MEMORY megabytes"
  memory=$(cat /dev/urandom | head -c ${MEMORY}m)
  log "Memory: load completed"
}


# file_url(){
#   case $WAN_RECEIVE in
#     100) all three;;
#     10|1024) "http://speedtest.ftp.otenet.gr/files/test1Mb.db" ;;
#     1) download="http://speedtest.ftp.otenet.gr/files/test1Mb.db";;
#   esac
# }

wan_receive(){
  # case $WAN_RECEIVE in
  #   100) /bin/true;;
  log "Net receive: downloading ${WAN_RECEIVE}MB file from internet"
  curl -o /dev/null -s http://ipv4.download.thinkbroadband.com/5MB.zip
  log "Net receive: download completed"
}

wan_transmit(){
  log "Net transmit: uploading ${WAN_TRANSMIT}MB file to internet"
  dd if=/dev/urandom bs=1MB count=${WAN_TRANSMIT} status=noxfer | curl -s -T - ftp://speedtest.tele2.net/upload/foo.txt
  log "Net transmit: upload complete"
}

disk_write(){
  log "Disk write: writing $DISK_WRITE megabytes to disk"
  dd if=/dev/urandom of=/tmp/file bs=1MB count=$DISK_WRITE conv=fsync status=noxfer
  log "Disk write: write completed"
}

disk_read(){
  # doesn't really work - probably hitting file cache
  log "Disk read: reading $DISK_READ megabytes from disk"
  dd if=file of=/dev/null bs=1MB count=$DISK_READ status=noxfer
  log "Disk read: read completed"
}


cpu &

memory

wan_receive

wan_transmit

disk_write

wait

log "Load run completed. Sleeping forever."


sleep 365d
