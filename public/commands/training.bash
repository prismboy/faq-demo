#!/bin/bash
#
# Watson Natural Language Classifierトレーニング

train_csv="$1"

if [ -z "$train_csv" ]; then
	echo "Usage:"
	echo "	$0 training_csv_file"
	exit 1
fi

if [ ! -f "$train_csv" ]; then
	echo "	$train_csv does not exist."
	exit 1
fi

CURRENT=`dirname $0`
. ${CURRENT}/nlc.env

curl -u "${username}":"${password}" -F training_data=@${train_csv} -F training_metadata="{\"language\":\"ja\",\"name\":\"trained-faq\"}" "https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers"

exit $?
