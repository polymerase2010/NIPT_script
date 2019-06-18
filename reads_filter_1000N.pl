#!/usr/bin/perl -w

use strict;
my %bin_n;
open(BIN_N,"/results/duzhao/script/gc_content_per_60000b.txt1")||die;
while(<BIN_N>){
	chomp;
	my @line=split /\t/;
	if($line[5]>0){
		$bin_n{$line[0].":".$line[1]}=1;
	}
}
open(FILTER,"$ARGV[0]")||die;
while(<FILTER>){
	chomp;
	my @line=split /\t/;
	if (not exists $bin_n{$line[0].":".$line[1]}){
		print join("\t",@line),"\n";
	}
}
close BIN_N;close FILTER;
