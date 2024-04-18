#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

bodyJson=`cat`  # from stdin

emptyLineNum=$(echo -n "$bodyJson" | grep -E --line-number '^$' | head -n 1 | cut -f 1 -d ':')
#echo "emptyLineNum: $emptyLineNum ==="

firstLine=$(echo -n "$bodyJson" | head -n 1)
verb=$(echo -n "$firstLine" | cut -f 1 -d ' ')
url=$(echo -n "$firstLine" | cut -f 2 -d ' ')

#echo "verb=$verb"
#echo "url=$url"

tmpfile=$(mktemp /tmp/XXXXXX)
function cleanup {
   rm -f "$tmpfile"
}
trap cleanup EXIT

headers=""
contentRemoveFirstLine=$(echo -n "$bodyJson" | tail -n +2)
if [ "$emptyLineNum" != "" ]; then
    # has empty line
    headerLines=$(echo -n "$bodyJson" | head -n $(expr $emptyLineNum - 1) | tail -n +2 | sed '/^\s*$/d')
    headers=$(echo -n "$headerLines" | sed "s/^/-H '/" | sed "s/\$/'/" | tr '\012' ' ')
    echo -n "$bodyJson" | tail -n +$(expr $emptyLineNum + 1) > "$tmpfile"
else
    # has NO empty line
    headerLines=$(echo -n "$contentRemoveFirstLine" | sed '/^\s*$/d')
    headers=$(echo -n "$headerLines" | sed "s/^/-H '/" | sed "s/\$/'/" | tr '\012' ' ')
    echo -n "" > "$tmpfile" # empty body
fi

#echo "headerLines:==="
#echo "$headerLines"
#echo "headers: $headers"
#echo "body:==="
#cat "$tmpfile"


if [ "$LOAD_TEST" == 1 ]; then
    if [ "$TOTAL_REQS" == "" ]; then
        TOTAL_REQS=1000
    fi
    if [ "$CONCURRENCY" == "" ]; then
        CONCURRENCY=10
    fi
    #echo "$headers" | xargs hey -n "$TOTAL_REQS" -c "$CONCURRENCY" -m $verb -D "$tmpfile" "$url"
    if [ "$verb" == "GET" ]; then
        echo "$headers $url" | xargs ab -n "$TOTAL_REQS" -c "$CONCURRENCY" -m "$verb"
    else
        echo "$headers $url" | xargs ab -n "$TOTAL_REQS" -c "$CONCURRENCY" -p "$tmpfile"
    fi
else
    stdout=$(echo "$headers" | xargs curl -v -w "\nHTTP %{http_code} time:%{time_total}s\n" -X $verb "$url" -d @"$tmpfile")
    j=$(echo "$stdout"|tail -n2|head -n1)
    s=$(echo "$stdout"|tail -n1);
    #o=$(echo "$stdout"|head -n +2);
    json=$(echo "$j"|python -m json.tool 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "$stdout"
    else
        echo "$json"
        echo "$s"
    fi
fi
