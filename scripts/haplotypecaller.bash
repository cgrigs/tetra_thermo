set -e 

GATK=/home/aahowel3/miniconda3/envs/gatk4/bin/gatk

REF="$1"
BAM="$2"
VCF="$3"

"$GATK" HaplotypeCaller -A DepthPerAlleleBySample -A DepthPerSampleHC -A InbreedingCoeff -A StrandBiasBySample -A Coverage -A FisherStrand -A MappingQualityRankSumTest -A MappingQualityZero -A QualByDepth -A RMSMappingQuality -A ReadPosRankSumTest -R "$REF" -I "$BAM" --mapping-quality-threshold-for-genotyping 0 -stand-call-conf 0 -ploidy 2 -O "$VCF"

