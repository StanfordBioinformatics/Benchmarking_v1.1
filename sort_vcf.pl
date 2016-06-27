#!/usr/bin/perl
use File::Basename;

my $file = shift;
open (FILE, "<", $file) or die "cannot open the input file!";
my $base;
while(my $sample=<FILE>){
        chomp $sample;
	 ## Code to take care of the files in format .vcf.gz
	if (substr($sample,-2) eq "gz"){
               $base = basename($sample, ".vcf.gz");
        } else{
	       $base = basename($sample, ".vcf");
	}
	my $dir = dirname($sample);
	$dir = "." if ($dir eq "");
	my $in = "$dir/$base.vcflib.vcf";
	
	##my $cmd = "~/mva/sort_vcf.sh $in";
	my $cmd = "/srv/gsfs0/SCGS/benchmark/scripts/sort_vcf.sh $in";
	print "$cmd\n";
        ##Not sure why the below command did not work so modified it
	#system(`$cmd`);
	system($cmd);
}
close FILE;
