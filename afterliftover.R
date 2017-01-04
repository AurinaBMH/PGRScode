#!/usr/bin/env Rscript
# This script will rearrange files after liftover
args = commandArgs(trailingOnly=TRUE)
#~~~Perform the liftover using USCS tools~~~
# this step is performed from the terminal in runPGCliftover.sh script (using OPTION 2)

# NOTE: This step WILL NOT update rs numbers, ONLY bp.
# We will be using CHR:BP format to match SNPs between target (GWAS) and base (PGC) data 
#
# OPTION 1: Perform the liftover using the USCS website (~15 mins)
# The pgcHg18.bed file can be uploaded to:
# https://genome.ucsc.edu/cgi-bin/hgLiftOver
# Set original assembly as March 2006 (NCBI36/hg18)
# Set new assembly as (GRCHg37/hg19)
#
# OPTION 2: (4-5 seconds, once files downloaded/installed)
# Download the liftover tool from:
# http://hgdownload.cse.ucsc.edu/admin/exe/linux.x86_64/liftOver
# and Hg18 to Hg19 chain file: http://hgdownload.cse.ucsc.edu/goldenPath/hg18/liftOver/hg18ToHg19.over.chain.gz
# Then in a linux environment:
# chmod +x liftOver.bin
# ./liftOver pgcAUTHg18.bed hg18ToHg19.over.chain pgcAUTHg19.bed pgcAUTunlifted.bed
# If you have problems with this process you can refer to:
# http://genome.sph.umich.edu/wiki/LiftOver#Various_reasons_that_lift_over_could_fail
#
# The unlifted SNPs file will have "#Deleted in new" in a line before each missing SNP
# Remove these before importing the file:
# ed 's/#Deleted in new//g' pgcAUTunlifted.bed > pgcAUTunliftedSNPs.bed
# AA added a few lines to delete the redundant rows and save that variable to a file 'pgcAUTunliftedSNPs.bed', which turned out not to be used. 
setwd("/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/1._GWAS2016PGCliftovertohg19/")
deleteSNPs <- read.csv(args[1], sep="",header=FALSE)
removeRows <- seq(1,nrow(deleteSNPs),2);
deleteSNPs <- deleteSNPs[-removeRows,]; #Read in liftover file and unlifted snps

pgcHg19 <- read.csv(args[3], sep="",header=FALSE)
pgcfailsnps <- deleteSNPs;

#Rename PGC19 and PGCfailsnp headers
names(pgcHg19) <- c("chrom","hg19chromStart","hg19chromEnd","snpid")
names(pgcfailsnps) <- c("chrom","hg19chromStart","hg19chromEnd","snpid")


#
#~~~Create new dataframe with all data needed for PGRS~~~~
#
setwd("/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/1._GWAS2016PGCliftovertohg19/pgc_data")
pgcfinal <- read.csv(args[4], sep="")
#order of columns for PGRS: "SNP,CHR,BP,A1,A2,OR,SE,P"
#Remove extra columns
pgcfinal[, -c(1:8)]<- list(NULL)
#Rename extra columns
names(pgcfinal) <- c("SNP","CHR","BP","A1","A2","OR","SE","P")

#Call in updated BP for SNPs
pgcfinal$BP <- pgcHg19[match(pgcfinal$SNP, pgcHg19$snpid),2]

#Remove rows that have missing data from liftover
pgcfinal <- pgcfinal[complete.cases(pgcfinal[,3]),]

#If you want to have SNP names as CHR:BP format instead of rs numbers, use this step:
pgcfinal$SNP <- paste(pgcfinal$CHR, pgcfinal$BP, sep=":")

#Write final file
setwd("/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/1._GWAS2016PGCliftovertohg19/")
write.table(pgcfinal, args[5], sep=" ", quote=FALSE, row.names=FALSE)
write.table(pgcfailsnps, args[2], sep=" ", quote=FALSE, row.names=FALSE)

