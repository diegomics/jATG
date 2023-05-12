source 1.repeat_variables.cnf
mkdir -p $OUT_DIR/${SPECIES_NAME}/${ASM_ID}/2.masking
sbatch --mail-user=${USER_MAIL} --partition=${PARTITION} --qos=${QUEUE} --output=${OUT_DIR}/${SPECIES_NAME}/${ASM_ID}/2.masking/%x.%j.out --error=${OUT_DIR}/${SPECIES_NAME}/${ASM_ID}/2.masking/%x.%j.err slurm/RepeatM.job
