#!/usr/bin/perl
use File::Basename;

my $vcfs = shift;
my $basedir = shift;
my $outdir=shift;
my $giab_indel=shift;
my $giab_snp=shift;
my $giab_bed=shift;

my $file = shift;
open (FILE, "<", $vcfs) or die "cannot open the input file!";
my $base;
while(my $sample=<FILE>){
        chomp $sample;
## Code to take care of the files in format .vcf.gz
	if (substr($sample,-2) eq "gz"){
	     $base = basename($sample, ".vcf.gz");
	} else{
	     $base = basename($sample, ".vcf");
        }
    print "$base\n";
	my $indel;
	my $snp;
	my $tmp = $base;
	$tmp =~ s/.indel//;
	
	if ($base !~ m/.snp/){
		#$indel = "$basedir/input_vcfs/$tmp.final.indel.vcf"; ## no need for sub-directory input_vcf as not present orifginally
		$indel = "$basedir/$tmp.final.indel.vcf";
	}
	if ($base !~ m/indel/){
		$base =~ s/.snp//;
		#$snp = "$basedir/input_vcfs/$base.final.snp.vcf";
		$snp = "$basedir/$base.final.snp.vcf";
	}

	my $snp_out = "$base.snp";
	my $indel_out = "$base.indel";

	if ($snp =~ m/[A-Z]/i){
		if (!(-e $snp)){
			die "SNP: File $snp does not exist!\n";
		}
		$command="qsub -b y -N vcfcomp-snp-$base -A clinical-service -l h_vmem=32g -M vankrish\@stanford\.edu -m a \"module load useq; java -jar -Xmx22g /srv/gs1/software/useq/useq-8.8.8/Apps/VCFComparator -s -g -a $giab_snp -b $giab_bed -c $snp -d $giab_bed -p $outdir/$snp_out\"";
		print "$command\n";
		system($command);
	}

	my @lent=("all");
	
	if ($indel =~ m/[A-Z]/i){
		foreach my $l (@lent){
			my $command;

			#print "$l\n";
			my $giab_indel_l = $giab_indel;
			my $indel_l = $indel;
			if (!(-e $indel)){
				die "File $indel does not exist!\n";
			}
			$command="qsub -b y -N vcfcomp-indel-$base -A clinical-service -l h_vmem=32g -M vankrish\@stanford\.edu -m a \"module load useq; java -jar -Xmx22g /srv/gs1/software/useq/useq-8.8.8/Apps/VCFComparator -n -a $giab_indel_l -b $giab_bed -c $indel_l -d $giab_bed -p $outdir/$indel_out\"";
			print "$command\n";
			system($command);
			#die;
		}
	}
}
