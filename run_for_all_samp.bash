#!/bin/bash -w


#######################
#Author: duzhao
#Date: 20170720
#Version: v1.0
#######################

#### 1.Configuration
out=$1
scpt_dir=/scripts
picard=/software/picard-tools-2.4.1/picard.jar
samtls=/software/samtools
bin=/script/gc_content_per_60000b.txt
z_norm_samp=/scripts/mean_and_var_NC.txt 
#mean_and_var_NC.pl脚本得到，需要20个以上正常样本的GC校正过的${sample}_dedup.bam.reads.filter.correct
t_norm_samp=/scripts/t_value_corrected_coefficient.txt 
#t_value_corrected.pl脚本得到，需要20个以上正常样本的GC校正过${sample}_dedup.bam.reads.filter.correct

#### 2.对这一批下机数据，reads数目按照GC含量校正并计算z值
mkdir -p $out/markdu $out/GC_correct $out/z_t_result
for bam in *.bam
do
	bam1=${bam##/*}
	sample=${bam1%%.*}
	echo "$sample is treated."
	
	##Markduplicates of reads.
	java -jar $picard MarkDuplicates  \
		REMOVE_DUPLICATES=true MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=8000 INPUT=$bam  \
		OUTPUT=$out/markdu/${sample}_dedup.bam METRICS_FILE=$out/markdu/${sample}_dedup.metrics
	$samtls index $out/markdu/${sample}_dedup.bam
	
	##Caculate reads count on each chromsome.
	perl $scpt_dir/reads_on_each_bin.pl $bin $out/markdu/${sample}_dedup.bam
	awk -F "\t" '{if($6!=0  && $5>=0.3 && $5<=0.7){print}}' $out/markdu/${sample}_dedup.bam.reads \
		> $out/markdu/${sample}_dedup.bam.reads.filter0
	perl $scpt_dir/reads_filter_1000N.pl $out/markdu/${sample}_dedup.bam.reads.filter0 \
		> $out/markdu/${sample}_dedup.bam.reads.filter
	
	##Correct reads count for each chromsome according GC content.
	ln -s $out/markdu/${sample}_dedup.bam.reads.filter $out/GC_correct/${sample}_dedup.bam.reads.filter
	perl $scpt_dir/reads_correct_by_GC.pl $out/GC_correct/${sample}_dedup.bam.reads.filter
		Rscript $scpt_dir/GC_plot.R $out/GC_correct/${sample}_dedup.bam.reads.filter \
		$out/GC_correct/${sample}_dedup.bam.reads.filter.correct \
		$out/GC_correct/${sample}_dedup.bam.reads.filter.eachgc
	
	##Caculate z_score for each chromsome.
	ln -s $out/GC_correct/${sample}_dedup.bam.reads.filter.correct $out/z_t_result/${sample}_dedup.bam.reads.filter.correct
	perl $scpt_dir/z_score.pl $out/z_t_result/${sample}_dedup.bam.reads.filter.correct $z_norm_samp
	perl $scpt_dir/t_value2.1.pl $out/z_t_result/${sample}_dedup.bam.reads.filter.correct $t_norm_samp

done

#### 3.统计z值和t值不正常的样本和染色体
perl positive_z_sample.pl #输出文件z_positive.txt包含z值不正常的样本和染色体
perl positive_t_sample.pl #输出文件t_positive.txt包含t值不正常的样本和染色体
