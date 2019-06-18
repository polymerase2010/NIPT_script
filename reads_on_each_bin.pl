#!/usr/bin/perl 

use strict;
open(BIN,"$ARGV[0]")||die; #/script/gc_content_per_60000b.txt
my $bam = $ARGV[1];
open(READ,">$ARGV[1].reads")||die;
while(<BIN>){
	chomp;
	my @line=split /\t/;
	my $reads=readpipe("samtools view -q 10 $bam $line[0]:$line[2]-$line[3]|awk 'length($10)>35'|wc -l");
	chomp $reads;
#	if($reads!=0){	print "reads=$reads\n";	}
	print READ join("\t",@line,$reads),"\n";
}
close BIN;close READ;

#system("awk -F /\t/ '{if($6!=0 && $5>0.3 && $5<0.7){print}}'");
