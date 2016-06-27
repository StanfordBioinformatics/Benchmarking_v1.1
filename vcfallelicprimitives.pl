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
        my $sample = "$dir/$base.hg19.vcf";
	###my $cmd = "~/mva/vcfallelicprimitives.sh $sample";##
        my $cmd = "/srv/gsfs0/SCGS/benchmark/scripts/vcfallelicprimitives.sh $sample";
   	print "$cmd\n"; 
        system ($cmd);
}
close FILE;
