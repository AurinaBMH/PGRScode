#!/bin/bash
# author: Aurina Arnatkeviciute
# this script combines liftover script pieces (beforeliftover.R and afterliftover.R) and performs all steps at once 

# for each DISORDER replace file names with the files for corresponding DISORDER
# DISORDERcode="MDD9",	DISORDERname="MDD" - 	major depression
# DISORDERcode="AUT8", 	DISORDERname="AUT" - 	autism
# DISORDERcode="SCZ17", DISORDERname="SCZ" - 	schizophrenia
# DISORDERcode="ADD4", 	DISORDERname="ADHD" - 	ADHD
# DISORDERcode="BIP11", DISORDERname="BIP" - 	bipolar

DISORDERcode="BIP11"
DISORDERname="BIP"
module load R
# run script part before liftover
Rscript --vanilla beforeliftover.R pgc.cross.${DISORDERcode}.2013-05.txt pgc${DISORDERname}Hg18.bed
# perform the liftover

./liftOver pgc${DISORDERname}Hg18.bed hg18ToHg19.over.chain pgc${DISORDERname}Hg19.bed pgc${DISORDERname}unlifted.bed
# run script after liftover
Rscript --vanilla afterliftover.R pgc${DISORDERname}unlifted.bed pgc${DISORDERname}unliftedSNPs.bed pgc${DISORDERname}Hg19.bed pgc.cross.${DISORDERcode}.2013-05.txt pgc${DISORDERname}final_target.txt





