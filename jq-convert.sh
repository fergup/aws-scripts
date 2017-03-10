#!/bin/bash
# A script to use jq to convert a CSV into JSON for consumption by DynamoDB
# PRF / 08/03/2017
################################
# Variables
#NUM=25
OUTFILE=dynamo.in
# Do stuff
upload() {
printf '{ "house-price": ' > $OUTFILE
#head -n${NUM} head1000-pp | \
cat $1 | \
jq --slurp --raw-input --raw-output \
    'split("\n") | .[1:] | map(split(",")) |
        map({ "PutRequest": { "Item":{ "id": {"S":.[0]},
             "price": {"N":.[1]},
             "date": {"S":.[2]},
             "postcode": {"S":.[3]},
             "number": {"S":.[7]}}}})' >> $OUTFILE
echo "}" >> $OUTFILE
sed -i '505,525d' $OUTFILE
# Do the actual batch load into DynamoDB
aws dynamodb batch-write-item --request-items file://$OUTFILE
}
# Do a nice for loop
for DIR in $(ls -1 files |grep sub*)
	do
	for FILE in $(find files/$DIR)
		do
		upload $FILE
	done
done
