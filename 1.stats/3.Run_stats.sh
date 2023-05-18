source 1.stats_variables.cnf

echo ""
echo "=== Sending jobs for step: Calculating quick stats ====================================="
echo ""


mkdir -p ${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/1.stats/logs
STATS_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/1.stats/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/1.stats/logs/%x.%j.err slurm/Stats.job)
STATS_JOB_ID=$(echo ${STATS_JOB} | cut -d ' ' -f4)



if [ -z "${REF_ASSEMBLY}" ]
then
	echo "No reference or related assembly provided"

else
	echo ""
	echo "=== Sending jobs for step: DotPlot ====================================="
	echo ""

	DOTPLOT_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/1.stats/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/1.stats/logs/%x.%j.err slurm/DotPlot.job)
	DOTPLOT_JOB_ID=$(echo ${DOTPLOT_JOB} | cut -d ' ' -f4)

fi



if [ -z "${REF_SPECIES_NAME}" ]
then
        echo "No reference or related species provided"

else
        echo ""
        echo "=== Sending jobs for step: Sex Check sex-chromosome linked genes ====================================="
        echo ""

	SEX_CHROM_JOB=$(sbatch --mail-user=${USER_MAIL} --mail-type=${MAIL_TYPE} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/1.stats/logs/%x.%j.out --error=${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/1.stats/logs/%x.%j.err slurm/Sex_chrom.job)
	SEX_CHROM_JOB_ID=$(echo ${SEX_CHROM_JOB} | cut -d ' ' -f4)

fi


