source $(dirname $PWD)/0.general_variables.cnf
source 1.HeRoH_variables.cnf

if [ -z "${VCF}" ]
then
        echo -e "Using previously obtained file ${SAMPLE_NAME}.Genot.full.mainNoSex.mask.filt.vcf.bgz for downstream analysis"
        export VCF="${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/4.calling/2_VCFs/filtered/${SAMPLE_NAME}.Genot.full.mainNoSex.mask.filt.vcf.bgz"
else
        echo -e "Using provided ${VCF} for downstream analysis"
fi


echo ""
echo "=== Sending jobs for step 1/3:  ====================================="
echo ""

mkdir -p ${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/5.het_roh.w${WIN_SIZE}/logs
DARW_PREP_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/5.het_roh.w${WIN_SIZE}/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/5.het_roh.w${WIN_SIZE}/logs/%x.%j.err slurm/Darwindow_prep.job)
DARW_PREP_JOB_ID=$(echo ${DARW_PREP_JOB} | cut -d ' ' -f4)


echo ""
echo "=== Sending jobs for step 2/3:  ====================================="
echo ""

DARW_CALC_JOB=$(sbatch --dependency=afterok:${DARW_PREP_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/5.het_roh.w${WIN_SIZE}/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/5.het_roh.w${WIN_SIZE}/logs/%x.%j.err slurm/Darwindow_calc.job)
DARW_CALC_JOB_ID=$(echo ${DARW_CALC_JOB} | cut -d ' ' -f4)


echo ""
echo "=== Sending jobs for step 3/3:  ====================================="
echo ""

DARW_PLOT_JOB=$(sbatch --dependency=afterok:${DARW_CALC_JOB_ID} --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/5.het_roh.w${WIN_SIZE}/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/${SAMPLE_NAME}/5.het_roh.w${WIN_SIZE}/logs/%x.%j.err slurm/Darwindow_plot.job)
DARW_PLOT_JOB_ID=$(echo ${DARW_PLOT_JOB} | cut -d ' ' -f4)

