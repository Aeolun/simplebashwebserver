#!/usr/bin/env bash

makeResponse()
{
    text=$1

    #Base
    base="HTTP/1.1 200 OK\r\n"

    #Headers
    headers="Connection: keep-alive\r\n\r\n"

    #Content
    content="$text\r\n"

    echo "$base$headers$content"
}

echo "Listening on ${1:-8080}"
while true; do
  echo -e "$(makeResponse "${2:-"Ok"}")" | nc -l ${1:-8080}
  echo "================================================"
done