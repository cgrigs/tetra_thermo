set -e

PICARD=picard
PICARD_ARGS=SortSam \
 MAX_RECORDS_IN_RAM=2000000 \
 VALIDATION_STRINGENCY=SILENT \
 SORT_ORDER=coordinate \
 CREATE_INDEX=true 

# Input files
BAM_in="$1"
BAM_out="$2"

$PICARD $PICARD_ARGS SORT_ORDER=coordinate I="$BAM_in" O="$BAM_out"
