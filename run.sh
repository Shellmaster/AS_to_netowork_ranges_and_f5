#! /bin/bash

SRC=${SOURCE:-/source/source.txt}
DST=${DESTINATION:-/destination}
F5=${F5:-true}
RAW=${RAW:-true}

echo "RAW dump is ${RAW}, you can disable it by setting RAW env variable to false"
echo "F5 dump is ${F5}, you can disable it by setting F5 env variable to false"

test -f $SRC && echo "Found $SRC" || { echo "Not found $SRC file, you can change it by setting SOURCE env variable"; exit 1; }
test -d $DST && echo "Found $DST" || { echo "Not found $DST directory (write permission is required), you can change it by setting DESTINATION env variable"; exit 1; }

# generate all network ranges
for a in `grep -vE "^$|^#" $SRC|cut -d\  -f1`; do
	echo "Generating for ${a}"
	# no need to check for errors, they go to stderr
	whois -h whois.radb.net -i origin ${a} | grep -Eo "([0-9.]+){4}/[0-9]+" > /tmp/${a}.net
	cp /tmp/${a}.net $DST/ &>/dev/null
	if $F5; then
		test -s /tmp/${a}.net && sed -e "s/$/ := \"$a\"/g" /tmp/${a}.net > /tmp/${a}.f5
	fi
done

# just in case, remove duplicates
sort /tmp/*.net|uniq > /tmp/pre.net

# copy raw data
if $RAW; then
	cp /tmp/pre.net ${DST}/raw.txt && echo "Created ${DST}/raw.txt"
fi

# make it F5 compatible
if $F5; then
	sort /tmp/*.f5|uniq > /tmp/pre.f5
	sed -e 's/^/network /g' -e 's/$/,/g' -e '$ s/.$//' /tmp/pre.f5 > ${DST}/F5.txt && echo "Created ${DST}/F5.txt"
fi

echo "Done"
