#!/usr/bin/perl
use File::Basename;
#use IO::Zlib;

my $file = shift;
open (FILE, "<", $file) or die "cannot open the input file!";
my $gzFlag=0;

while(my $sample=<FILE>){
        chomp $sample;
	##Can be a vcf.gz file
        if (substr($sample,-2) eq "gz"){
              my $base = basename($sample, ".vcf.gz");
	      $gzFlag = 1;
              vcfCheck($sample,$base,$gzFlag);
	} elsif (substr($sample,-3) eq "vcf"){
              my $base = basename($sample, ".vcf");
	      vcfCheck($sample,$base,$gzFlag);
	} else {
		print "Please check the input file format and try again\n";
	}
}
close FILE;

   sub vcfCheck {
        $sample = $_[0];
	$base = $_[1];
	$gzFlag = $_[2];
	my $dir = dirname($sample);
	$dir = "." if ($dir eq "");
	my $out = "$dir/$base.hg19.vcf";
	print "($sample)\t($base)\t($dir)\t($out)\n\n";
	  if ($gzFlag == 1){
	     $sample_mod="$dir/$base.vcf";
	     ##first uncompress the gzip file but retain the original .gz file, doesnt work on vcf.gz formats
	     my $command="zcat $sample > $sample_mod";
	     system($command);
             ## No need to write "else" part and two separate open file statements!
	     $sample = $sample_mod;
	  }
	open (IN, "<", $sample) or die "cannot open input file $sample\n";
	open (OUT, ">", $out) or die "cannot open the output file $out\n";

	while(my $line=<IN>){
	        chomp $line;
		if ($line =~/^\#/){
			if ($line =~ m/\#\#contig=<ID=(\d+),(\S+)/){
				print OUT "\#\#contig=<ID=chr$1,$2\n";
			} elsif ($line =~ m/\#\#contig=<ID=([XY]),(\S+)/){
				print OUT "\#\#contig=<ID=chr$1,$2\n";
			} elsif ($line =~ m/\#\#contig=<ID=MT,(\S+)/){
				print OUT "\#\#contig=<ID=chrM,$1\n";
			} else {
				print OUT "$line\n";
			}
		} else {
			if ($line !~ m/^chr/){
				my @line = split("\t", $line);
				my $lent = @line;
				print OUT "chr$line[0]";
				for (my $i=1;$i<$lent; $i++){
					print OUT "\t$line[$i]";
				}	
				print OUT "\n";	
			} else {
				print OUT "$line\n";
			}
		}
	}
	close IN;	
	close OUT;
    return;
    }
