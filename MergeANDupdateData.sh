#!/bin/bash

#SBATCH --account=monash076
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-48:00:00
#SBATCH --mem-per-cpu=16000
#SBATCH --mail-user=aurina.arnatkeviciute@monash.edu
#SBATCH --mail-type=ALL

module load plink
module load perl
WHEREAREDATA='/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/5_GWAS2016MaCHtoPLINK/convertedData08'
WHEREISLIST='/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/5_GWAS2016MaCHtoPLINK/data_cleaning_merging_scripts'
cp ${WHEREISLIST}/all_chr_merge_list.txt ${WHEREAREDATA}/all_chr_merge_list.txt
cp ${WHEREISLIST}/allchrsex.txt ${WHEREAREDATA}/allchrsex.txt
cp ${WHEREISLIST}/allchrpheno.txt ${WHEREAREDATA}/allchrpheno.txt
cd ${WHEREAREDATA}

# combine chunked files into one file for all chromosomes (use chromosome ordered (instead of chunk ordered file all_chr_merge_list.txt)).
# takes about 2h to complete
plink --bfile chunk1.1 --merge-list all_chr_merge_list.txt --make-bed --out all_chr
# update sex and affection data.
# each line takes about 30min to complete
plink --bfile all_chr --update-sex allchrsex.txt --make-bed --out all_chrusex
plink --bfile all_chrusex --pheno allchrpheno.txt --make-bed --out all_chrFINAL

# update SNP list to CHR:BP format
perl -ne '@c=split/\t/; @loc=split/:/,$c[1]; $c[0]=$loc[0]; $c[3]=$loc[1]; print join("\t",@c);' all_chr.bim > all_chrFINAL.bim

# check if all files are ok
plink --bfile all_chrFINAL --assoc


