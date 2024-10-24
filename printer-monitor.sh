#!/bin/bash

PRINTER_NAME="Deskjet-1510-series"
BUS="03f0"
CHECK_INTERVAL=10

cancel_all_jobs() {
  JOB_IDS=$(lpstat -o | awk '{print $1}')
  for JOB_ID in $JOB_IDS; do
    cancel "$JOB_ID"
  done
}

update_printer_status() {
    local STATUS="$1"
    if echo "$STATUS" | grep -q "Deskjet"; then
      cupsaccept "$PRINTER_NAME"
      cupsenable "$PRINTER_NAME"
    else
      cupsreject "$PRINTER_NAME"
      cancel_all_jobs
    fi
}

PREV_STATUS=$(lsusb -s "$BUS:" 2>&1)
update_printer_status "$PREV_STATUS"

while true; do
  CURR_STATUS=$(lsusb -s "$BUS:" 2>&1)
  
  if [[ "$CURR_STATUS" != "$PREV_STATUS" ]]; then
    update_printer_status "$CURR_STATUS"
    PREV_STATUS="$CURR_STATUS"
  fi

  sleep "$CHECK_INTERVAL"
done