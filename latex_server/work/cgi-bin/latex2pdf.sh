#!/bin/bash

PORT=6000
BASEWORKDIR=/var/www/html/requests
FILENAME=$QUERY_STRING

echo "Content-type: application/json"
echo ""

if [[ "$REQUEST_METHOD" != "POST" ]]; then
    echo '{ "error": "Only POST is supported" }'
    exit 0
fi

echo "{"
echo '"CONTENT_LENGTH": "'$CONTENT_LENGTH'", '
echo '"QUERY_STRING": "'$QUERY_STRING'", '

UUID=$(cat /proc/sys/kernel/random/uuid)
REQUEST_ID=$(date +%Y%m%d-%H%M)-$RANDOM_$UUID


THIS_HOST=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

REQUESTDIR=$BASEWORKDIR/$REQUEST_ID
echo '"uri": "/requests/'$REQUEST_ID'/'$FILENAME'.pdf", '
echo '"local_uri": "http://'$THIS_HOST':'$PORT'/requests/'$REQUEST_ID'/'$FILENAME'.pdf", '
# maybe just CP to EFS at the end

mkdir -p $REQUESTDIR

cat > $REQUESTDIR/$FILENAME.tex

cd $REQUESTDIR
pdflatex -interaction=nonstopmode $REQUESTDIR/$FILENAME.tex --output-directory $REQUESTDIR &> $REQUESTDIR/ALL.LOG

if [[ -e "$REQUESTDIR/$FILENAME.pdf" ]]; then
    echo '"status": 0 '
else
    echo '"status": 1 '
fi

echo "}"

touch /EFS/run/services/latex2pdf/$THIS_HOST
cp -rf $REQUESTDIR /EFS/data/latex2pdf/.
