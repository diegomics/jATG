source $(dirname $PWD)/0.general_variables.cnf
source 1.psmc_variables.cnf


if [[ "${ASSEMBLY##*.}" == "gz" ]]
then
    INTER=$(basename ${ASSEMBLY} .gz)
    export ASSEMBLY_NAME=$(basename $INTER .${INTER##*.})
elif  [[ "${ASSEMBLY##*.}" == "fa" ]] || [[ "${ASSEMBLY##*.}" == "fasta" ]] || [[ "${ASSEMBLY##*.}" == "fna" ]]
then
    export ASSEMBLY_NAME=$(basename $ASSEMBLY .${ASSEMBLY##*.})
else
    echo "Invalid reference extension name!"


if [ -z "${ASSEMBLY_HM}" ]
then
        echo -e "Using previously obtained file ${ASSEMBLY_NAME}.HM.fa for downstream analysis"
        export ASSEMBLY_HM="${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/2.masking/3_masker/${ASSEMBLY_NAME}.HM.fa"
else
        echo -e "Using provided ${ASSEMBLY_HM} for downstream analysis"
fi

if [ -z "${CHROM_LIST}" ]
then
        echo -e "Using previously obtained file main_scaffoldsNoSex_lengths for downstream analysis"
        export CHROM_LIST="${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/2_VCFs/filtered/main_scaffoldsNoSex_lengths"
else
        echo -e "Using provided ${CHROM_LIST} for downstream analysis"
fi



echo ""
echo "=== Sending jobs for step 1/4:  ====================================="
echo ""

mkdir -p ${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs

CONSENSUS_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.err slurm/Consensus.job)
CONSENSUS_JOB_ID=$(echo ${CONSENSUS_JOB} | cut -d ' ' -f4)


echo ""
echo "=== Sending jobs for step 2/4:  ====================================="
echo ""

CONVERT_JOB=$(sbatch --dependency=afterok:${CONSENSUS_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.err slurm/Convert.job)
CONVERT_JOB_ID=$(echo ${CONVERT_JOB} | cut -d ' ' -f4)



echo ""
echo "=== Sending jobs for step 3/4:  ====================================="
echo ""

PSMC_JOB=$(sbatch --dependency=afterok:${CONVERT_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.err slurm/PSMC.job)
PSMC_JOB_ID=$(echo ${PSMC_JOB} | cut -d ' ' -f4)



echo ""
echo "=== Sending jobs for step 4/4:  ====================================="
echo ""

PLOT_JOB=$(sbatch --dependency=afterok:${PSMC_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.err slurm/Plot.job)
PLOT_JOB_ID=$(echo ${PLOT_JOB} | cut -d ' ' -f4)
