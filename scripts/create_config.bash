METADATA="$1"
DICT="$2"

echo "BASENAMES_WITH_LANES=\\"
cat "$METADATA" | tail -n +2 | cut -f 2 |
  uniq | awk '{ print "    ", $0, "\\" }'
echo ""

echo "BASENAMES=\\"
cat "$METADATA"  | tail -n +2 | cut -f 2 |
  sed -re 's|_L00[1234]$||' | sort | uniq | awk '{ print "    ", $0, "\\" }'
echo ""

echo "CONTIGS=\\"
cat "$DICT" | grep "^@SQ" |cut -f 2 | sed -e 's/^.*://g' | awk '{ print "    ", $0, "\\" }'
echo ""
