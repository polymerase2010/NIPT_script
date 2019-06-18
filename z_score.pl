#!/usr/bin/perl -w

use strict;
open(MEAN_VAR,"$ARGV[1]")||die;
my (%mean,%var);
while(<MEAN_VAR>){
	chomp;
	my @line=split /\t/;
	$mean{$line[0]}=$line[1];
	$var{$line[0]}=$line[2];
}
my (%chread,$allread,%z_score);
open(READ,"$ARGV[0]")||die;
while(<READ>){
	chomp;
	my @line=split /\t/;
	$chread{$line[0]}+=$line[6];
	$allread+=$line[6];
}

open(Z,">$ARGV[0].z_score")||die;
print Z "Chrom\tz_score\tmean_database\tsd_database\tmean_sample\n";
foreach(1..22,'X','Y'){
	my $chr='chr'.$_;
#	print $chr,"\n";
	$z_score{$chr}=($chread{$chr}/$allread-$mean{$chr})/sqrt($var{$chr});
	my $mean_sam=$chread{$chr}/$allread;
	print Z "$chr\t$z_score{$chr}\t$mean{$chr}\t",sqrt($var{$chr}),"\t",$mean_sam,"\n";
}
close READ;close Z;
