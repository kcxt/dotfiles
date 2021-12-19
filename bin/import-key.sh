#!/bin/bash

KEY="$1"
if [ -z "$KEY" ]; then
	echo "Usage: $0 <GPG key id>" 1>&2
	exit 1
fi

if [ $KEY != 0x* ]; then
	KEY="0x$KEY"
fi

KEY=$(echo $KEY | tr '[:upper:]' '[:lower:]')

echo -e "\033[0;32mImporting key: '$KEY'\033[0m"
RECV_KEY=$(curl "https://keyserver.ubuntu.com/pks/lookup?op=get&search=$KEY" 2>/dev/null)

if grep "Not Found" <(echo "$RECV_KEY"); then
	echo "Key not found" 1>&2;
	exit 1
fi

echo -e "$RECV_KEY"
echo 
read -r -p "Are you sure you want to import this key? [y/N] " ans
case "$ans" in
    [yY][eE][sS]|[yY]) 
        echo "$RECV_KEY" | gpg2 --import
        ;;
esac

