source $(dirname $PWD)/0.general_variables.cnf
source 1.masking_variables.cnf

echo ""
echo "=== Sending jobs for Repeats Masking step ====================================="
echo ""

mkdir -p ${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/2.masking
sbatch --mail-user=${USER_MAIL} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/2.masking/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/2.masking/%x.%j.err slurm/RepeatM.job
