source 1.gc_telo_variables.cnf
export PATH="${CONDA_BIN_DIR}:${PATH}"
source activate GC_TELO_env

mkdir -p ${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/3.gc_telo/plots
cd ${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/3.gc_telo


if [[ "${ASSEMBLY##*.}" == "gz" ]]
then
    echo "decompressing the file..."
    INTER=$(basename ${ASSEMBLY} .gz)
    export ASSEMBLY_NAME=$(basename $INTER .${INTER##*.})
    gunzip -c ${ASSEMBLY} > "${ASSEMBLY_NAME}.fa"
elif  [[ "${ASSEMBLY##*.}" == "fa" ]] || [[ "${ASSEMBLY##*.}" == "fasta" ]] || [[ "${ASSEMBLY##*.}" == "fna" ]]
then
    export ASSEMBLY_NAME=$(basename $ASSEMBLY .${ASSEMBLY##*.})
    ln -s ${ASSEMBLY} "${ASSEMBLY_NAME}.fa"
else
echo "Invalid reference extension name!"
fi


# GC
cat ${ASSEMBLY_NAME}.fa | seqkit fx2tab -n -l -g > ${ASSEMBLY_NAME}_GC.tab
cat ${ASSEMBLY_NAME}.fa | seqkit sliding -s ${WINDOW_GC} -W ${WINDOW_GC} -g | seqkit fx2tab -n -g > ${ASSEMBLY_NAME}_gc_window${WINDOW_GC}.tab


# Telo
tidk find --log -w ${WINDOW_TELO} -c ${CLADE} -d ${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/3.gc_telo -o ${ASSEMBLY_NAME} ${ASSEMBLY_NAME}.fa


# Gaps
seqtk cutN -n 1 -g ${ASSEMBLY_NAME}.fa > ${ASSEMBLY_NAME}_gaps.bed
python ${INSTALLATION_DIR}/3.gc_telo/scripts/completeGapbED.py -b ${ASSEMBLY_NAME}_gaps.bed -g ${GENOME_TABLE} -o ${ASSEMBLY_NAME}_resolved.bed


# Plots
Rscript ${INSTALLATION_DIR}/3.gc_telo/scripts/plotGC_TELO.R ${GENOME_TABLE} ${MINSIZE} ${ASSEMBLY_NAME}_gc_window${WINDOW_GC}.tab ${ASSEMBLY_NAME}_telomeric_repeat_windows.tsv ${ASSEMBLY_NAME}_resolved.bed ${OUT_DIR}/jATG/${SPECIES_NAME}/${ASSEMBLY_ID}/3.gc_telo/plots


#Rscript scripts/plotGC_karyoploteR.R ${GENOME_FILE} ${MINSIZE} ${OUT_DIR}/${OUT_PREFIX}_gc_window${WINDOW}.tab ${OUT_DIR}/${OUT_PREFIX}_GC.tab ${OUT_DIR}/plots
