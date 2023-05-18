source 1.psmc_variables.cnf

echo ""
echo "=== Sending jobs for step 1/4:  ====================================="
echo ""

#mkdir -p ${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs

#CONSENSUS_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.err slurm/Consensus.job)
#CONSENSUS_JOB_ID=$(echo ${CONSENSUS_JOB} | cut -d ' ' -f4)


echo ""
echo "=== Sending jobs for step 2/4:  ====================================="
echo ""

#CONVERT_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.err slurm/Convert.job)
#CONVERT_JOB_ID=$(echo ${CONVERT_JOB} | cut -d ' ' -f4)



echo ""
echo "=== Sending jobs for step 3/4:  ====================================="
echo ""

PSMC_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.err slurm/PSMC.job)
PSMC_JOB_ID=$(echo ${PSMC_JOB} | cut -d ' ' -f4)



echo ""
echo "=== Sending jobs for step 4/4:  ====================================="
echo ""

#PLOT_JOB=$(sbatch --dependency=afterok:${PSMC_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/6.psmc/logs/%x.%j.err slurm/Plot.job)
#PLOT_JOB_ID=$(echo ${PLOT_JOB} | cut -d ' ' -f4)
