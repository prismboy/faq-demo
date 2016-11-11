#!/bin/bash
#
# Watson NLCから引数で指定されたClassifierを削除する

if [ $# -lt 1 ]; then
	echo "Usage:"
	echo "	$0 classifier-id"
	exit 1
fi

CURRENT=`dirname $0`
. ${CURRENT}/nlc.env

classifier_id=$1

curl -X DELETE -u "${username}":"${password}" "https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers/${classifier_id}"
