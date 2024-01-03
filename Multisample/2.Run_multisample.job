source $(dirname $PWD)/0.general_variables.cnf
source 1.multisample_variables.cnf

echo ""
echo "=== Sending jobs for step 1/x:  ====================================="
echo ""

mkdir -p ${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/Multisample/Het_RoH/logs
COMB_ROH_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/Multisample/Het_RoH/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/Multisample/Het_RoH/logs/%x.%j.err slurm/combine_HetRoH.job)
COMB_ROH_JOB_ID=$(echo ${COMB_ROH_JOB} | cut -d ' ' -f4)
