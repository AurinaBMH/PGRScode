#!/usr/bin/env Rscript
# This script will prepare original data for liftover
args = commandArgs(trailingOnly=TRUE)
# ~~~ WHY DO I NEED TO PERFORM THIS STEP? ~~~
# The LiftOver step is necesary to bring all genetical analysis to the same reference build.
#
# The SNP list used in the PGC cross disorder dataset uses UCSC hg18 / NCBI b36, while the 1000 Genomes (Phase1, version 3), 
# which was used to impute our GWAS data uses the UCSC hg19 build. Therefore we need to perform a liftover to ensure that 
# both the PGC SNP list and imputed data are both on the UCSC hg19 build. Here we use the UCSC's liftover tool to perform the liftover.
# 
#
#
# ~~~Prepare the PGC data for liftover~~~
#
# Download the PGC cross-disorder data can be downloaded from here:
# https://www.med.unc.edu/pgc/results-and-downloads/
# Download subsets for disorders (file name format: pgc.cross.SCZ17.2013-05.txt):
# ADHD subset
# AUT subset
# BIP subset
# MDD subset
# SCZ subset

# To perform the liftover we need to have the file in BED format
# * NOTE that BED format here refers to Browser Extensible Data *NOT* a binary PED file (used by PLINK).
# PLINK refers to this as a SET file
# See: http://genome.ucsc.edu/FAQ/FAQformat.html#format1 for more info.
#
# Correct example of BED format required for liftover:
# Chr bpstartpos bpendpos snpid
# chr1    743267  743268  rs3115860
# chr1    766408  766409  rs12124819
# chr1    773885  773886  rs17160939
#
# Imprort original pgc data
setwd("/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/1._GWAS2016PGCliftovertohg19/pgc_data")
# Disable scientific notation (otherwise the liftover tool will give an error when it sees things like 2.8e+07)
options(scipen=100)
# Path to PGC data
pgcHg18 <- read.csv(args[1], sep="")
# Trim to only first three columns: snpid hg18chr bp
pgcHg18[, -c(1:3)]<- list(NULL)

# The liftover requires a bp start and end. Because a SNP is only 1 bp long, you can just +1 to 
pgcHg18["bpend"] <- (pgcHg18$bp + 1)

# The format of the file also requires that the chromosome number have the 'chr' string at the beginning 
pgcHg18$hg18chr = paste0('chr', pgcHg18$hg18chr)

# Reorder the columns so that they conform
# Current: snpid chr bpstart bpend
# Final: chr bpstart bp end snpid
pgcHg18 <- pgcHg18[,c(2,3,4,1)]
# Reorder the column headers
names(pgcHg18) <- c("chrom","chromStart","chromEnd","snpid")
# Save file. Remove header, row names, and quotations around strings (will give errors)
# I've included ADHD in the filename, but change this to whatever disorder you're looking at
#
setwd("/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/1._GWAS2016PGCliftovertohg19/")
write.table(pgcHg18, args[2], sep=" ", quote=FALSE, col.names=FALSE, row.names=FALSE)
