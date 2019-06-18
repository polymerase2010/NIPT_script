#!/usr/bin/perl 

use warnings;
use strict;
my @file=glob("*correct.t_stat");
open(POSI,">t_positive.txt")||die;
print POSI "Sample\tFile\tChrom\tT_score\n";
foreach my $file(@file){
	print "$file\n";
	open(TVALUE,$file)||die;
	my $samp=(split(/_dedup/,$file))[0];
	while(<TVALUE>){
		chomp;
		next if /^Chrom/;
		my @line=split(/\t/,$_);
		if($line[1]>=4.75 or $line[1]<=-4.75){
			print POSI join("\t",$samp,@line),"\n";
		}
	}
	close TVALUE;
}
close POSI;
