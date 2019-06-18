#!/usr/bin/perl -w

use strict;
open(HG19,"$ARGV[0]")||die; # hg19.fasta
my %hg;
$/=">";
while(<HG19>){
	chomp;
	$_=~s/\n//g;
	if(/(chr\d+|chrX|chrY)(.*)/){	$hg{$1}=$2;	print "$1\n";}
}
$/="\n";
print "HG19 hash completed!\n";
my $bin=$ARGV[0];
open(GC,">gc_content_per_${bin}b.txt3")||die;
foreach my $i((1..22),'X','Y'){
	my $chrlen=length $hg{"chr$i"};
	print "chr$i\t$chrlen\n";
	my $j;
	for($j=1;$j<$chrlen-$bin;$j+=$bin){
		my @gc_n=&gcportion(substr($hg{"chr$i"},$j-1,$bin),$bin);
		my $gc=$gc_n[0];
		my $n=$gc_n[1];
		if($n==0){	print GC "chr$i\t",int($j/$bin+1),"\t$j\t",($j+$bin-1),"\t$gc\n";	}
	}
	my $gc=&gcportion(substr($hg{"chr$i"},$j-1),$chrlen-$j+1);
#	print substr($hg{"chr$i"},$j-1),"\t",$chrlen-$j+1,"\t",length(substr($hg{"chr$i"},$j-1)),"\n";
#	print GC "chr$i\t",int($j/$bin+1),"\t$j\t",($chrlen),"\t$gc\n";
}

sub gcportion(){
	my ($seq,$len)=@_;
	my $gcport=($seq=~s/G|C/#/g);
	my $nport=($seq=~s/N/n/g);
	my $gc=sprintf "%.3f",($gcport/$len);
	my $n=sprintf "%.4f",($nport/$len);
	return ($gc,$n);
}
