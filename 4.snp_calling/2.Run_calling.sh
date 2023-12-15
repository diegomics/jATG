source $(dirname $PWD)/0.general_variables.cnf
source 1.calling_variables.cnf

export PATH="${CONDA_BIN_DIR}:${PATH}"
source activate jATG_env


if [[ "${ASSEMBLY##*.}" == "gz" ]]
then
    INTER=$(basename ${ASSEMBLY} .gz)
    export ASSEMBLY_NAME=$(basename $INTER .${INTER##*.})
elif  [[ "${ASSEMBLY##*.}" == "fa" ]] || [[ "${ASSEMBLY##*.}" == "fasta" ]] || [[ "${ASSEMBLY##*.}" == "fna" ]]
then
    echo "crating the link..."
    export ASSEMBLY_NAME=$(basename $ASSEMBLY .${ASSEMBLY##*.})
else
    echo "Invalid reference extension name!"
fi


if [ -z "${MASKED_BED}" ]
then
        echo -e "Using previously obtained file ${ASSEMBLY_NAME}.3cols.bed for downstream analysis"
	export MASKED_BED="${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/2.masking/3_masker/${ASSEMBLY_NAME}.3cols.bed"
else
        echo -e "Using provided ${MASKED_BED} for downstream analysis"
fi



echo ""
echo "=== Sending jobs for step 4/5: Fixing VCF for Larissa :) ============================================="
echo ""

conda deactivate
MERGE_VCF_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/2_VCFs/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/2_VCFs/logs/%x.%j.err slurm/Merge_VCF.job)
MERGE_VCF_JOB_ID=$(echo $MERGE_VCF_JOB | cut -d ' ' -f4)


echo ""
echo "=== Sending jobs for step 5/5: Filtering VCF ============================================="
echo ""
FILTER_JOB=$(sbatch --dependency=afterok:${MERGE_VCF_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/2_VCFs/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/2_VCFs/logs/%x.%j.err slurm/VCFfilter.job)
FILTER_JOB_ID=$(echo $FILTER_JOB | cut -d ' ' -f4)


echo ""
echo "=== Sending jobs for extra step: Cleaning temp files ====================================="
echo ""
CLEANING_JOB=$(sbatch --dependency=afterok:${FILTER_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/2_VCFs/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/2_VCFs/logs/%x.%j.err slurm/cleaning.job)
CLEAINING_JOB_ID=$(echo $CLEANING_JOB | cut -d ' ' -f4)

