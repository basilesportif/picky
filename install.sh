#!/bin/bash
usage() { echo "Usage: $0 URBIT_PIER_DIRECTORY [-w (watch code and copy to pier)]" 1>&2; exit 1; }

if [ $# -eq 0 ]; then
    usage
    exit 2
fi

while getopts "w" opt; do
    case ${opt} in
        w) WATCH_MODE="true"
           ;;
        *) usage
           ;;
    esac
done

if [ -z "$WATCH_MODE"]; then
    echo "Installed %picky"
    rsync -r --exclude '.*' --exclude '*.sh' --exclude '*.md' * $1/
else
   echo "Watching for changes to copy to ${1}..."
   while [ 0 ]
   do
    sleep 0.8
    rsync -r --exclude '.*' --exclude '*.sh' --exclude '*.md' * $1/
   done
fi
