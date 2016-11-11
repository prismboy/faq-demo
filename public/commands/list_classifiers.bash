#!/bin/bash
#
# Watson NLCのClassifierをリストする

CURRENT=`dirname $0`
. ${CURRENT}/nlc.env

curl -u "${username}":"${password}" "https://gateway.watsonplatform.net/natural-language-classifier/api/v1/classifiers"
