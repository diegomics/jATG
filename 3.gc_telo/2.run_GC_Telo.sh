source $(dirname $PWD)/0.general_variables.cnf
source 1.gc_variables.cnf

echo ""
echo "=== Sending jobs for GC and Telomeres analysis ====================================="
echo ""

mkdir -p ${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/3.gc_telo/logs

GC_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/3.gc_telo/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/3.gc_telo/logs/%x.%j.err slurm/3.gc_telo.job)
GC_JOB_ID=$(echo ${GC_JOB} | cut -d ' ' -f4)

