#!/bin/bash

BASEWORKDIR=/var/www/html/requests
THIS_HOST=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

FILENAME=$QUERY_STRING

echo "Content-type: application/json"
echo ""

if [[ "$REQUEST_METHOD" != "POST" ]]; then
    echo '{ "error": "Only POST is supported" }'
    exit 0
fi

if [[ ! $FILENAME =~ ^[0-9a-zA-Z_]{1,19}$ ]]; then
    echo '{ "error": "name can only have alphanumeric characters and underscore and have fewer than 20 characters" }'
    exit 0
fi


echo "{"
echo '"CONTENT_LENGTH": "'$CONTENT_LENGTH'", '
echo '"QUERY_STRING": "'$QUERY_STRING'", '


UUID=$(cat /proc/sys/kernel/random/uuid)
REQUEST_ID=$(date +%Y%m%d-%H%M)-$RANDOM_$UUID

REQUESTDIR=$BASEWORKDIR/$REQUEST_ID
mkdir -p $REQUESTDIR
echo '"uri": "/requests/'$REQUEST_ID'/'$FILENAME'.pdf", '
cat > $REQUESTDIR/$FILENAME.tex

cd $REQUESTDIR
pdflatex -interaction=nonstopmode $REQUESTDIR/$FILENAME.tex --output-directory $REQUESTDIR &> $REQUESTDIR/ALL.LOG

touch /EFS/run/services/latex2pdf/$THIS_HOST
cp -rf $REQUESTDIR /EFS/data/latex2pdf/.

if [[ -e "$REQUESTDIR/$FILENAME.pdf" ]]; then
    echo '"status": 0 '
else
    echo '"error": "check ALL.LOG", '
    echo '"status": 1 '
fi

echo "}"
