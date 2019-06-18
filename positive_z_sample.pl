#!/usr/bin/perl 

use warnings;
use strict;
my @file=glob("*correct.z_score");
open(POSI,">z_positive.txt")||die;
print POSI "Sample\tChrom\tz_score\tmean_database\tsd_database\tmean_sample\n";
foreach my $file(@file){
	print "$file\n";
	open(ZSCORE,$file)||die;
	my $samp=(split(/_dedup/,$file))[0];
	while(<ZSCORE>){
		chomp;
		next if /^Chrom/;
		my @line=split(/\t/,$_);
		if($line[1]>=3){
			print POSI join("\t",$samp,@line),"\n";
		}
	}
	close ZSCORE;
}
close POSI;
