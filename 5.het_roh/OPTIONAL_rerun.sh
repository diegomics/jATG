source $(dirname $PWD)/0.general_variables.cnf
source 1.HeRoH_variables.cnf

echo ""
echo "=== Sending jobs for extra step:  ====================================="
echo ""

DARW_PLOT_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/5.het_roh.w${WIN_SIZE}/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/5.het_roh.w${WIN_SIZE}/logs/%x.%j.err slurm/Darwindow_plot.job)
DARW_PLOT_JOB_ID=$(echo ${DARW_PLOT_JOB} | cut -d ' ' -f4)

