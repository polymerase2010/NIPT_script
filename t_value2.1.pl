#!/usr/bin/perl -w


use strict;
print "PAPER:Sensitivity of Noninvasiver Prenatal Detection of Fetal Aneuploidy from Maternal Plasma Using Shotgun Sequencing Is Limited Only by Counting Statistics\n";
my %coefficient;
open(COE,"/results/duzhao/NIPT/all_sample_corrected_60kb_rm1000N/Z_statistic_Sensitivity_of/corrected_coefficient.txt")||die;
while(<COE>){
	chomp;
	my @line=split /\t/;
	$coefficient{$line[0]}=$line[2];
}
close COE;


###all sample run together###
my @file=`ls *correct`;
foreach my $f(@file){
chomp $f;
print "\n$f\n";
my (%bin_count,%bin_reads);
open(COR,$f)||die;
open(T_RESULT,">$f.t_stat")||die;
while(<COR>){
	chomp;
	next if /chrX|chrY/;
	my @line=split /\t/;
	$bin_count{$line[0]}++;
	if(exists $coefficient{"$line[0]:$line[1]"}){
		push @{$bin_reads{$line[0]}}, $line[6]/$coefficient{"$line[0]:$line[1]"};
	}else{
		push @{$bin_reads{$line[0]}}, $line[6];
	}
}

my (%chr_mean,%chr_var);
foreach(1..22){
	my $chr="chr$_";
	my @m_v=&mean_var(@{$bin_reads{$chr}}); #mean and var  reads of each bin of chri
	$chr_mean{$chr}=$m_v[0];
	$chr_var{$chr}=$m_v[1];
	print "$chr\t$bin_count{$chr}\t$chr_mean{$chr}\t$chr_var{$chr}\t",sqrt($chr_var{$chr}),"\n";
}

my (%t_value,%t_mean);
#foreach my $t(1..22){
foreach my $t(13,18,21){
	my $test="chr$t";
	foreach(keys %bin_count){
		if($test ne $_){
			push @{$t_value{$test}},($chr_mean{$test}-$chr_mean{$_})/sqrt($chr_var{$test}/$bin_count{$test}+$chr_var{$_}/$bin_count{$_});
		}
	}
	@{$t_value{$test}}=sort{$a<=>$b}@{$t_value{$test}};
	print "$test\t@{$t_value{$test}}\n";
	@{$t_value{$test}}=splice(@{$t_value{$test}},2,17);
	print "$test\t@{$t_value{$test}}\n";
	$t_mean{$test}=(&mean_var(@{$t_value{$test}}))[0];
	print T_RESULT "$f\t$test\t$t_mean{$test}\n";
}
close COR;close T_RESULT;
}
close COE;
sub mean_var(){
	my @a=@_;
	my ($total,$total_sq);
	foreach(@a){
		$total+=$_;
		$total_sq+=$_*$_;
	}
	my $v=$total_sq/($#a+1)-($total/($#a+1))**2;
	my $m=$total/($#a+1);
	return ($m,$v);
}
