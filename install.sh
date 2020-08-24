#!/bin/bash
if [ -z "$1" ]
then
    echo "usage: sync.sh URBIT_PIER_DIRECTORY"
    exit;
fi

echo "Watching for changes to copy to ${1}..."
while [ 0 ]
do
    sleep 0.1
    rsync -r --exclude '.*' --exclude '*.sh' --exclude '*.md' * $1
done
