#!/bin/bash
#SBATCH --ignore-pbs
#SBATCH --job-name=PrepCHRfiles
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --mem-per-cpu=5000
#SBATCH --time=01:00:00
#SBATCH --mail-type=ALL

#Dump all of your .info files temporarily into this folder.
# Folder with all of your info files
scriptDirectory='/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/5_GWAS2016MaCHtoPLINK/data_cleaning_merging_scripts'
dataDirectory='/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/4._GWAS2016MaCHimputation/originalData'
cd ${scriptDirectory}
mkdir info_temp
cd ${dataDirectory}
cp *.info ${scriptDirectory}/info_temp

# This script will remove any instances where both alleles are the same, and
# will remove any indels. All instances are changed to 0 (PLINK's missing allele
# default) so that no errors are given when creating the .bed file
# sed -i This option specifies that files are to be edited in-place. GNU sed does this by creating a temporary file and sending output to this file rather than to the standard output.
# The syntax of the s (as in substitute) command is ‘s/regexp/replacement/flags’. The / characters may be uniformly replaced by any other single character within any given s command. The 
# character (or whatever other character is used in its stead) can appear in the regexp or replacement only if it is preceded by a \ character. 
# So all matching letters and R/I/D/ combinations will be replaced with zero. 
# flag g means: apply the replacement to all matches to the regexp, not just the first. 
# comments from: https://www.gnu.org/software/sed/manual/sed.html#Invoking-sed

cd ${scriptDirectory}/info_temp

sed -i -- 's/G	G/0	0/g' *
sed -i -- 's/A	A/0	0/g' *
sed -i -- 's/C	C/0	0/g' *
sed -i -- 's/T	T/0	0/g' *
sed -i -- 's/R	I/0	0/g' *
sed -i -- 's/I	R/0	0/g' *
sed -i -- 's/D	R/0	0/g' *
sed -i -- 's/R	D/0	0/g' *

#~~~~Filter SNPS~~~~
# http://genome.sph.umich.edu/wiki/MaCH_FAQ
# "Post-imputation, we recommend Rsq 0.3 (which removes >70% of poorly-imputed SNPs at the cost of <0.5% well-imputed SNPs) and MAF of 1%."

# Therefore we want to use the minimac imputation .info files to make a list of SNPs that have a high enough MAF (>1%) and Rsq (>0.3)
# The list of SNPs will be in CHR:BP format
#
#Column order for .info files
# SNP	Al1	Al2	Freq1	MAF	AvgCall	  Rsq	Genotyped	LooRsq	EmpR	EmpRsq	Dose1	Dose2
# 

for i in *.info
do
awk '{ if ($2=0 || $3=0 || $5<=.01 || $5>=.99 || $7<=.8) print $1}' $i >> ${dataDirectory}/exclude_snps3.txt
done
