#!/bin/bash

#SBATCH --account=monash076
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-48:00:00
#SBATCH --mem-per-cpu=24000
#SBATCH --mail-user=aurina.arnatkeviciute@monash.edu
#SBATCH --mail-type=ALL

# massive usage (more than one subject)
#  1. [/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/PGRScode]$ DISORDERS="ADHD" THRESHOLD="03"; 
#  2. [....]$ for DISORDER in $DISORDERS; do sbatch --job-name="${DISORDER}${THRESHOLD}" --output="/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/7._GWAS2016PRSice/dataForPRSice/Testing/test2/slurm-${DISORDER}${THRESHOLD}.out" --error="/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/7._GWAS2016PRSice/dataForPRSice/Testing/test2/slurm-${DISORDER}${THRESHOLD}.err" runPRSice.sh $DISORDER $THRESHOLD; done

module load R
module load plink

DISORDER=$1
THRESHOLD=$2

scriptLocation='/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/PGRScode'
dataLocation='/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/7._GWAS2016PRSice/dataForPRSice'
# check if thresholds for p values (high/low) in PRSice_pgrs.R script are consistent with the folder, where data will be saved before running. 
alloriginalData='/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/5_GWAS2016MaCHtoPLINK'
baseLocation='/gpfs/M2Scratch/Monash076/aurina/Gen_Cog/code/PGRS/bethj/Sdisc/1._GWAS2016PGCliftovertohg19'
originalData=${alloriginalData}/convertedData${THRESHOLD}
outputLocation=${dataLocation}/Testing/test2

cd ${outputLocation}
mkdir ${DISORDER}${THRESHOLD}

cp ${originalData}/all_chrFINAL.* ${outputLocation}/${DISORDER}${THRESHOLD}
cp ${dataLocation}/CovariateFile_AS.txt ${outputLocation}/${DISORDER}${THRESHOLD}
cp ${baseLocation}/pgc${DISORDER}final_target.txt ${outputLocation}/${DISORDER}${THRESHOLD}
cp ${dataLocation}/plink_1.9_linux_160914 ${outputLocation}/${DISORDER}${THRESHOLD}
cp ${scriptLocation}/PRSice_pgrs.R ${outputLocation}/${DISORDER}${THRESHOLD}

cd ${outputLocation}/${DISORDER}${THRESHOLD}
chmod +x plink_1.9_linux_160914

echo -e "\nRUNNING TRANSFORMATION ON ${DISORDER}${THRESHOLD}\n"
R --file=PRSice_pgrs.R -q --args \
plink ./plink_1.9_linux_160914 \
base pgc${DISORDER}final_target.txt
