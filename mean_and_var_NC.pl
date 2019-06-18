#!/usr/bin/perl -w

use strict;
my %ally;#y_value for each chrom(keys) of all samples
my @sample=readpipe("find *.correct");#all samples
#print "@sample\n";
foreach (@sample){
	chomp;
	if(!(-e $_)){
		print "Not exists this file:$_\n";last;
	}else{
		open(FILE,$_)||die;
		my(%chread,$allread,%y);
		while(<FILE>){
			chomp;
			my @line=split /\t/;
			$chread{$line[0]}+=$line[6];#total reads count of a chromosome
			$allread+=$line[6];#total reads count of this sample
		}
		foreach(sort keys %chread){
			$y{$_}=$chread{$_}/$allread;
			push @{$ally{$_}},$y{$_};
		}
		close FILE;
	}
}

open(NC,">mean_and_var_NC.txt")||die;
print NC "Chrom\ty_mean\ty_var\ty_each_sample\n";
foreach(sort keys %ally){
	my ($y_mean,$y_var)=&mean_and_var(@{$ally{$_}});
	print NC join("\t",$_,$y_mean,$y_var,@{$ally{$_}}),"\n";
}
close NC;
sub mean_and_var(){#mean and variance of array
	my @array=@_;
	my ($total,$total_sq);
	foreach(0..$#array){
#		print $_,"\n";
		$total+=$array[$_];
		$total_sq+=($array[$_]*$array[$_]);
	}
#	print "$total\t$total_sq\n";
	my $mean=$total/scalar @array;
	my $var=($total_sq/scalar @array)-($mean*$mean);
	return ($mean,$var);
}
