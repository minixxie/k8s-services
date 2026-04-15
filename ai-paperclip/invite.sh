#!/bin/bash

podName=$(kubectl -n $(make -s --no-print-directory ns) get pod | sed 1d | awk '{print $1}')

sh=$(kubectl -n $(make -s --no-print-directory ns) exec $podName -- ls /bin/bash)
if [ "$sh" == "" ]; then
	sh=$(kubectl -n $(make -s --no-print-directory ns) exec $podName -- ls /bin/sh)
fi

echo "Answer 'No' to the question: 'Start Paperclip now?'"
sleep 3s

kubectl -n $(make -s --no-print-directory ns) exec -it $podName -- $sh -c "cd /app && COREPACK_ENABLE_DOWNLOAD_PROMPT=0 pnpm paperclipai onboard && COREPACK_ENABLE_DOWNLOAD_PROMPT=0 pnpm paperclipai auth bootstrap-ceo"
