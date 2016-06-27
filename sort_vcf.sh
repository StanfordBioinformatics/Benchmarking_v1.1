#!/bin/bash

in_vcf=`cd \`dirname $1\`; pwd`/`basename $1`
dir=`dirname $in_vcf`
basename=`basename $in_vcf`
sample=${basename/.vcflib.vcf/}

echo $in_vcf
echo $dir
echo $basename
echo $sample

if [ "$dir" == "" ]
then
	dir="."
fi 
out_vcf="$dir/$sample.sorted.vcf"
command="cat $in_vcf | java -Djava.io.tmpdir=$dir -jar /srv/gs1/software/gbsc/amin/jvarkit/dist/sortvcfonref2.jar -R /srv/gsfs0/projects/gbsc/Resources/GATK/hg19-3.0/ucsc.hg19.fasta > $out_vcf"

##Use quotes to echo variable 'command' because of the usage of $() above else no quotes required
echo $command

## The quotes for log file necessary else information will be printed on console
## Use eval for execution else will give error because shell does not understand piped/ nested commands in the variable, says error cat invalid --D option
#$command &> "$dir/sort.log"
eval $command &> "$dir/sort.log"
