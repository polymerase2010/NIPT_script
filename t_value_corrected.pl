#!/usr/bin/perl 


#从GC含量校正过的样本得到每个bin的校正系数文件：corrected_coefficient.txt，用于t检验
use warnings;
use strict;
my (%bin_sam,%sam_total,%sam_mean,$sam_count,%sam_bin_count);
my @file=`find *.correct`;#all normal samples after GC bias corrected
foreach my $file(@file){
	chomp $file;
#	print $file,"\n";
	if(-e $file){
		$sam_count++;
		open(FILE,$file)||die;
		while(<FILE>){
			chomp;
			next if /chrX|chrY/;#remove chrX or chrY
			my @line=split /\t/;
			$bin_sam{$line[0].":".$line[1]}{$file}=$line[6];#reads count for each bin of this sample
#			print "$line[0].':'.$line[1]\t$file\t$bin_sam{$line[0].':'.$line[1]}{$file}\n";
			$sam_total{$file}+=$line[6];#total reads of this sample
			$sam_bin_count{$file}++;#total count of bin of this sample
		}
		$sam_mean{$file}=$sam_total{$file}/$sam_bin_count{$file};#mean count of bin of this sample
		close FILE;
	}
}

open(COR,">corrected_coefficient.txt")||die;
my (%bin_all,%bin_cor,%count);
foreach my $bin(keys %bin_sam){#each bin
#	print "$bin\n";
	foreach my $s(@file){#each sample
		chomp $s;
		if(exists $bin_sam{$bin}{$s}){
#			print $bin_sam{$bin}{$s},"\n";
			$bin_all{$bin}+=$bin_sam{$bin}{$s}/$sam_mean{$s};
#			print "$bin_sam{$bin}{$s}\t$sam_mean{$s}\n";
			$count{$bin}++;#sample count of this bin
		}
	}
	$bin_cor{$bin}=$bin_all{$bin}/$count{$bin};#corrected coefficient of this bin
	print COR "$bin\t$count{$bin}\t$bin_cor{$bin}\n";
}
close COR;
