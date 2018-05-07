#!/usr/bin/env bash

makeResponse()
{
    path=$1

    if [[ -d $path ]]
    then
        text=$(ls $path)
    elif [[ -f $path ]]
    then
        text=$(cat $path)
    else
        text="Unknown path: $path"
    fi

    #Base
    base="HTTP/1.1 200 OK\r\n"

    #Headers
    headers="Connection: keep-alive\r\n\r\n"

    #Content
    content="$text\r\n"

    echo "$base$headers$content"
}

output() {
    echo $1 >&2
}

command -v nc > /dev/null 2>&1 || { echo "Netcat is required to be installed."; exit 1; }

if [ $# -eq 0 ]
then
    echo "Listening on 8080"
    while true; do
      rm backpipe
      mkfifo backpipe
      scriptpath="$( cd "$(dirname "$0")" ; pwd -P )"
      nc -l -N 8080 < backpipe | bash "${scriptpath}/index.sh" "script" > backpipe
      echo "Request finished"
    done
else
    while read line
    do
      #echo "$line"
      first=$(echo $line | cut -d" " -f 1)
      path=""
      if [ "$first" = "GET" ]
      then
        path=$(echo $line | cut -d" " -f 2)
        output "GET $path"
        break
      fi
    done

    if [ "$path" != "" ]
    then
        basepath="."
        echo -e "$(makeResponse $basepath$path)"
    fi
fi