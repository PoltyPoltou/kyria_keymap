#!/bin/bash
echo "acquire sudo before losing keyboard"
sudo echo "sudo acquired !"
echo "Device name to mount ? (/dev/sdd by default)"
echo -n "[sdd]"
read
DEV=${REPLY:-sdd}

echo "Left or Right ?"
echo -n "[L/r]"
read
if [[ $REPLY == "r" ]]; then
	SIDE=right
else
	SIDE=left
fi

while true
do
	sudo mount /dev/"$DEV" /tmp/nicenano && sudo cp "$SIDE".uf2 /tmp/nicenano/ && exit 0
	sleep 2
done
