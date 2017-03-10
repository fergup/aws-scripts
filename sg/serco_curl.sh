#!/bin/bash
MYENCPASS="UjBkQHRyNG41ZjNyCg=="
MYUSER="rodtransfer"
MYCURL=$(which curl)
MYPASS=$(echo "$MYENCPASS" | base64 --decode)
FILENAME=$1
F1=$(basename "$FILENAME")
R1=$RANDOM
TMPFILE=/tmp/$R1.$F1
RANDNAME=/tmp/smh.$R1.txt
# Enter a value for $1
[[ -z $1 ]] && echo "Format: $0 <filename>" && exit 1
# Enter a valid filename
if [ ! -f $FILENAME ]; then
	echo "Enter a valid filename"
	exit 1
fi
# Do the actual transfer
$MYCURL -s -L -X POST -F eftupload=@$FILENAME -u $MYUSER:$MYPASS https://filetransfer.serco.com >/dev/null
$MYCURL -s -u $MYUSER:$MYPASS https://filetransfer.serco.com > $RANDNAME
# Do stuff
if [ -f $RANDNAME ]; then
	NUM=$(cat $RANDNAME | grep $F1 | wc -l)
	if [ $NUM == 1 ]; then
		if [ -f $TMPFILE ]; then
			rm -rf $TMPFILE
		fi
		$MYCURL -o $TMPFILE -s -u $MYUSER:$MYPASS https://filetransfer.serco.com/$F1

		####Check the MD5 of source and destination file and compare
		SMD5=$(md5sum $FILENAME | awk '{print $1}')
		RMD5=$(md5sum $TMPFILE | awk '{print $1}')
		if [ "$SMD5" = "$RMD5" ]; then
			rm $TMPFILE
			rm $RANDNAME
			exit 0
		else
			echo "File upload failed! - Unable to compare MD5"
			rm $TMPFILE
			rm $RANDNAME
			exit 10
		fi
	else
		echo "Uploading failed"
		rm $TMPFILE
		rm $RANDNAME
		exit 10
	fi
else
	echo "Unable to query the target to see if file has been uploaded."
	rm $TMPFILE
	rm $RANDNAME
	exit 10
fi
