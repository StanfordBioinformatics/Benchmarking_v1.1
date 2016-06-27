#!/usr/bin/perl

my $file = shift;
print "$file\n";
open (IN, "<", $file) or die "cannot open the input file!";

while(my $sample=<IN>){
        chomp $sample;

	my $cmd;
  ## Change code below because the directory for input vcf file can have _vcf as part of directory name and can get replaced
	#$sample =~s/.vcf//;
  ## Code to accommodate for files with .vcf.gz format
	if (substr($sample,-2) eq "gz"){
               $sample =~ s/\.vcf\.gz$//;
        } else{
	       $sample=~ s/\.vcf$//; 
        }
	print "$sample\n";	
	if ($sample =~ m/indel/){
		my $base = $sample;
		$base =~ s/.indel//g;
		$cmd = "ln -sf $sample.sorted.vcf $base.final.indel.vcf";
	} elsif ($sample =~ m/snp/){
		my $base = $sample;
		$base =~ s/.snp//g;
		$cmd = "ln -sf $sample.sorted.vcf $base.final.snp.vcf";
	} else {
		#$cmd = "~/mva/split_vcf.sh $sample.sorted.vcf";
		$cmd = "/srv/gsfs0/SCGS/benchmark/scripts/split_vcf.sh $sample.sorted.vcf";
	}
   	print "$cmd\n"; 
        system ($cmd);
}
close IN;
