#!/usr/bin/perl -w

use strict;
my ($totalreads,$bincount);
my %read;
open(READ,"$ARGV[0]")||die;
while(<READ>){
	chomp;
	my @line=split /\t/;
	push @{$read{$line[4]}},$line[5];#reads count per 0.001 gc content
	$totalreads+=$line[5];
	$bincount++;
}
close READ;

print "$bincount\n";
my $rpb=$totalreads/$bincount;#reads count per bin
my %rpgc;

open(AVRA_GC,">$ARGV[0].eachgc")||die;#average reads of each gc content
foreach (sort keys %read){
	$rpgc{$_}=&mean(@{$read{$_}});
	print AVRA_GC "$_\t$rpgc{$_}\n";
}
close AVRA_GC;

open(READ,"$ARGV[0]")||die;
open(COREAD,">$ARGV[0].correct")||die;
while(<READ>){
        chomp;
	my @line=split /\t/;
	my $read_c=$line[5]*($rpb/$rpgc{$line[4]});#reads count per bin corrected 
	print COREAD join("\t",@line,$read_c),"\n";
}
close READ;	

sub mean(){
	my @array=@_;
	my $total;
	foreach(0..$#array){
		$total+=$array[$_];
	}
	return ($total/scalar@array);
}
