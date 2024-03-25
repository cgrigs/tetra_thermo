set -e

BWAMEM_BIN="bwa mem"
BWAMEM_ARGS=-Y
SAMTOOLS_BIN="samtools"

# metadata
READGROUPS=readgroups.tsv

# Input files
REF="$1"
F1="$2"
F2="$3"
BAM="$4"

base=$(basename "$F1" _R1_001.fastq.gz)

RG=$(awk -F'\t' -v base="base:${base}" '$1 == base { $1 = "@RG"; print }' "$READGROUPS")
oldstr="T. thermophila Whole Genome DNA"
newstr="T.thermophila_Whole_Genome_DNA"
result=$(echo $RG | sed "s/$oldstr/$newstr/")
RB=${result//$' '/'\t'}

if [ -z "$RB" ]; then
  echo "ERROR: Read group not found"
  exit 1
fi

$BWAMEM_BIN $BWAMEM_ARGS -R "$RB" "$REF" "$F1" "$F2" |
  $SAMTOOLS_BIN view -Shb -o "$BAM"
