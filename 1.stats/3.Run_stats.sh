#!/bin/bash
source 1.stats_variables.cnf
export PATH="${CONDA_BIN_DIR}:${PATH}"
source activate STATS_env

mkdir -p $OUT_DIR/${SPECIES_NAME}/${ASM_ID}/1.stats
cd  $OUT_DIR/${SPECIES_NAME}/${ASM_ID}/1.stats

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

assembly-stats "${ASSEMBLY_NAME}.fa" > assembly_stats.tmp
python ${INSTALLATION_DIR}/1.stats/scripts/table_from_stats.py assembly_stats.tmp > ${ASSEMBLY_NAME}_shortStats.tsv
rm assembly_stats.tmp

countgc.sh "${ASSEMBLY_NAME}.fa" format=1 > temp
cut -f1 temp > full_fasta_header
awk '{print $1}' temp > col1_temp
awk -F "\t" '{print $2}' temp > col2_temp
awk -F "\t" '{print $7}' temp > col4_temp
awk -F "\t"  '{print $8}' temp > col3_temp
paste col1_temp col2_temp col3_temp col4_temp | awk 'NF' | sort -k 2 -n -r | awk '{print NR"\t"$s}' > number_lengths_GC_Ns
rm *temp

awk '$3 > 5000000 { print $2 }' number_lengths_GC_Ns > main_scaffolds
rm "${ASSEMBLY_NAME}.fa"
