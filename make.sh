#!/bin/bash

# Copyright 2015 (c) Creative Commons Corporation

# Extract only the license-related strings
# and convert the translation style from Python named vars to printf-style

# Copy files from an i18n checkout next to this directory
SRCDIR=../i18n/cc/i18n/po/
DESTDIR=po
FILE=cc_org.po
# Messages mentioning licenses always have a license_url
MATCH='--msgid --fixed-strings --regexp="%(license_url)s"'
# Convert %(...)s to %s
#TRANS="sed -e s/%([^)]*)s/%s/g"
#FIXME: match the full #, python-format
DEPYTHON="./bin/depythonize"

if [ ! -d ${SRCDIR} ];
then
    echo Please run this script in a directory next to a checkout of:
    echo https://github.com/creativecommons/i18n
    exit 1
fi

POS=${SRCDIR}*/*.po

mkdir -p "${DESTDIR}"

for po in ${POS};
do
    locale=$(basename $(dirname "${po}"))
    echo "${locale}"
    outdir="${DESTDIR}/${locale}"
    mkdir -p "${outdir}"
    outfile="${outdir}/${FILE}"
    msggrep $MATCH "${po}" | \
        msgfilter ${DEPYTHON} > "${outfile}"
done
