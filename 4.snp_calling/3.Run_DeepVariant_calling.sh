source 1.calling_variables.cnf

echo ""
echo "=== Sending jobs for step 1/5: Indexing reference... ====================================="
echo ""

mkdir -p ${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/0_idx/logs
INDEX_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/0_idx/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/0_idx/logs/%x.%j.err slurm/Index.job)
INDEX_JOB_ID=$(echo ${INDEX_JOB} | cut -d ' ' -f4)


echo ""
echo "=== Sending jobs for step 2/5: Mapping... ================================================"
echo ""

if [[ "${READ_TYPE}" == "illuminaPE" ]]
then
	LENGTH=$(ls ${TRIMMED_READS_DIR}/*{1.trim*fq,1.fq,1.trim*fastq,1.fastq}.gz 2>/dev/null | wc -l)
        mkdir -p "${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/1_BAMs/logs"
        mkdir -p "${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/1_BAMs/eval"
        MAP_JOB=$(sbatch --dependency=afterok:${INDEX_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --array=1-${LENGTH} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/1_BAMs/logs/%x.%A_%a.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/1_BAMs/logs/%x.%A_%a.err slurm/Map_Dups_PE.job)
        MAP_JOB_ID=$(echo ${MAP_JOB} | cut -d ' ' -f4)

elif  [[ "${READ_TYPE}" == "HiFi" ]]
then
        LENGTH=$(ls ${TRIMMED_READS_DIR}/*{trim*fq,fq,trim*fastq,fastq}.gz 2>/dev/null | wc -l)
        mkdir -p "${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/1_BAMs/logs"
        mkdir -p "${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/1_BAMs/eval"
        MAP_JOB=$(sbatch --dependency=afterok:${INDEX_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --array=1-${LENGTH} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/1_BAMs/logs/%x.%A_%a.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/1_BAMs/logs/%x.%A_%a.err slurm/Map_Dups_HiFi.job)
        MAP_JOB_ID=$(echo ${MAP_JOB} | cut -d ' ' -f4)

else
        echo 'Invalid read type. Valid values for READ_TYPE variable in variables.cnf file are: "illuminaPE" or "HiFi"'
fi


echo ""
echo "=== Sending jobs for step 3/5: Merging BAMs =============================================="
echo ""

if [ -z "${MULTI_RUN}" ]
then
	MERGE_BAM_JOB=$(sbatch --dependency=afterok:${MAP_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/1_BAMs/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/1_BAMs/logs/%x.%j.err slurm/Hold.job)
	MERGE_BAM_JOB_ID=$(echo ${MERGE_BAM_JOB} | cut -d ' ' -f4)
else
	MERGE_BAM_JOB=$(sbatch --dependency=afterok:${MAP_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/1_BAMs/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/1_BAMs/logs/%x.%j.err slurm/Merge_BAM.job)
	MERGE_BAM_JOB_ID=$(echo ${MERGE_BAM_JOB} | cut -d ' ' -f4)
fi


echo ""
echo "=== Sending jobs for intermeriate step: BAM stats ========================================="
echo "" 
BAMSTATS_JOB=$(sbatch --dependency=afterok:${MERGE_BAM_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/1_BAMs/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/1_BAMs/logs/%x.%j.err slurm/Eval_BAM.job)
BAMSTATS_JOB_ID=$(echo $BAMSTATS_JOB | cut -d ' ' -f4)


echo ""
echo "=== Sending jobs for step 4/5: Calling variants =========================================="
echo "" 

mkdir -p "${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/2_VCFs/logs"
VARCALL_JOB=$(sbatch --dependency=afterok:${MERGE_BAM_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/2_VCFs/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/2_VCFs/logs/%x.%j.err slurm/Caller.job)
VARCALL_JOB_ID=$(echo $VARCALL_JOB | cut -d ' ' -f4)


echo ""
echo "=== Sending jobs for step 5/5: Filtering VCF ============================================="
echo ""
FILTER_JOB=$(sbatch --dependency=afterok:${VARCALL_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/2_VCFs/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/2_VCFs/logs/%x.%j.err slurm/VCFstats.job)
FILTER_JOB_ID=$(echo $FILTER_JOB | cut -d ' ' -f4)
