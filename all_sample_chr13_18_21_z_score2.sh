#!/bin/bash -w
for date in 20*
do
	echo $date
	cd $date/bam_file/bin_contain_N
	for i in *.correct
	do	echo $i
		egrep "chr(13|18|21)" *.correct.z_score> ${date}_bin_contain_N_chr13_18_21_z.txt
		sed -i 's/_dedup.bam.reads.filter.correct.z_score:/\t/g' ${date}_bin_contain_N_chr13_18_21_z.txt
		sort -k 2 ${date}_bin_contain_N_chr13_18_21_z.txt -o ${date}_bin_contain_N_chr13_18_21_z.txt
		cp ${date}_bin_contain_N_chr13_18_21_z.txt   /results/duzhao/NIPT/results_chr13_18_21
	done

	cd ../bin_contain_N_nohighreads
	for i in *.correct
        do
                egrep "chr(13|18|21)" *.correct.z_score> ${date}_bin_contain_N_nohighreads_chr13_18_21_z.txt
                sed -i 's/_dedup.bam.reads.filter.correct.z_score:/\t/g' ${date}_bin_contain_N_nohighreads_chr13_18_21_z.txt
		sort -k 2  ${date}_bin_contain_N_nohighreads_chr13_18_21_z.txt -o  ${date}_bin_contain_N_nohighreads_chr13_18_21_z.txt
                cp ${date}_bin_contain_N_nohighreads_chr13_18_21_z.txt   /results/duzhao/NIPT/results_chr13_18_21
        done

	cd ../duplicates_rm_and_N
	for i in *.correct
        do
                egrep "chr(13|18|21)" *.correct.z_score> ${date}_rm1000N_chr13_18_21_z.txt
                sed -i 's/_dedup.bam.reads.filter.correct.z_score:/\t/g' ${date}_rm1000N_chr13_18_21_z.txt
		sort -k 2 ${date}_rm1000N_chr13_18_21_z.txt -o ${date}_rm1000N_chr13_18_21_z.txt
                cp ${date}_rm1000N_chr13_18_21_z.txt   /results/duzhao/NIPT/results_chr13_18_21
        done

        cd ../bin_contain_N_20kb
	for i in *.correct
        do
                egrep "chr(13|18|21)" *.correct.z_score> ${date}_bin_contain_N_20kb_chr13_18_21_z.txt
                sed -i 's/_dedup.bam.reads.filter.correct.z_score:/\t/g' ${date}_bin_contain_N_20kb_chr13_18_21_z.txt
		sort -k 2 ${date}_bin_contain_N_20kb_chr13_18_21_z.txt -o ${date}_bin_contain_N_20kb_chr13_18_21_z.txt
                cp ${date}_bin_contain_N_20kb_chr13_18_21_z.txt   /results/duzhao/NIPT/results_chr13_18_21
        done
	cd ../../..
done
