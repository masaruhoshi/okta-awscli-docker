#!/bin/bash

FILE=$1

ask() {
  while read -r answer; do
    if [[ ! -z "$answer" ]]; then
      break
    fi
  done

  echo "$answer"
}

ask_silence() {
  while read -r -s answer; do
    if [[ ! -z "$answer" ]]; then
      break
    fi
  done

  echo "$answer"
}

echo -n "Base URL [okta.com]: "
BASE_URL=$(ask)
echo -n "Username: "
USERNAME=$(ask)
echo -n "Password: "
PASSWORD=$(ask_silence)

PROFILE=`cat <<EOF
[default]
base-url = ${BASE_URL}
username = ${USERNAME}
password = ${PASSWORD}
EOF
`

echo "$PROFILE" > $FILE
