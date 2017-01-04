#!/bin/bash

#SBATCH --account=monash076
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-48:00:00
#SBATCH --mem-per-cpu=8000
#SBATCH --mail-user=aurina.arnatkeviciute@monash.edu
#SBATCH --mail-type=ALL

# massive usage (more than one subject)
#  1. [code]$ WHERESMYSCRIPT=$(pwd); chunkName="chunk1"; CHROMOSOMESinchunk="1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22"
#  2. [....]$ for CHROMOSOMEinchunk in $CHROMOSOMESinchunk; do sbatch --job-name="${chunkName}${CHROMOSOMEinchunk}" --output="${WHERESMYSCRIPT}/gcta_dose2plink_scripts/slurm-${CHROMOSOMEinchunk}${chunkName}.out" --error="${WHERESMYSCRIPT}/gcta_dose2plink_scripts/slurm-${CHROMOSOMEinchunk}${chunkName}.err" ${WHERESMYSCRIPT}/gcta_dose2bed.sh $WHERESMYSCRIPT $chunkName $CHROMOSOMEinchunk; done


WHERESMYSCRIPT=$1
chunkName=$2
CHROMOSOMEinchunk=$3

dataLocation='/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/4._GWAS2016MaCHimputation/originalData'
saveConvertedFiles='/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/5_GWAS2016MaCHtoPLINK/convertedData08'
cd ${dataLocation}

echo -e "\nRUNNING TRANSFORMATION ON ${CHROMOSOMEinchunk}\n"
./gcta64 --dosage-mach ${chunkName}-ready4mach.${CHROMOSOMEinchunk}.imputed.dose ${chunkName}-ready4mach.${CHROMOSOMEinchunk}.imputed.info --make-bed --exclude exclude_snps3.txt  --out ${saveConvertedFiles}/${chunkName}.${CHROMOSOMEinchunk}


