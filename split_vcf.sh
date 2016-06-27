#!/bin/bash

in_vcf=`cd \`dirname $1\`; pwd`/`basename $1`
dir=`dirname $in_vcf`
basename=`basename $in_vcf`
sample=${basename/.sorted.vcf/}

echo $in_vcf
echo $dir
echo $basename
echo $sample

snp_vcf="$dir/$sample.final.snp.vcf"
indel_vcf="$dir/$sample.final.indel.vcf"

echo $snp_vcf
echo $indel_vcf
## Load the module to enable populating the value of $GATK
command="module load gatk/3.5"
echo $command
$command
REF="/srv/gsfs0/SCGS/resources/GATK/hg19-3.0/ucsc.hg19.fasta"

command="java -Xmx6g -Xms6g -jar "$GATK"GenomeAnalysisTK.jar \
   -T SelectVariants \
   -R $REF \
   -V $in_vcf \
   -o $snp_vcf \
   -selectType SNP"

echo $command
## avoid printing stats/ information on console to reduce computational time and create log file
$command &> "$dir/split_snp.log"

command="java -Xmx6g -Xms6g -jar "$GATK"GenomeAnalysisTK.jar \
   -T SelectVariants \
   -R $REF \
   -V $in_vcf \
   -o $indel_vcf \
   -selectType INDEL"
echo $command
## avoid printing stats/ information on console to reduce computational time and create log file
$command &> "$dir/split_indel.log"

