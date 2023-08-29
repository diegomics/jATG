source $(dirname $PWD)/0.general_variables.cnf
source 1.masking_variables.cnf
${SINGULARITY_LOAD}


if [ -z "${LINEAGE_NAME}" ]
then
      VAR=$(echo ${SPECIES_NAME} | sed 's/_/ /g')
else
      VAR=$(echo ${LINEAGE_NAME} | sed 's/_/ /g')
fi


echo ""
echo "* checking if ${VAR} is present in the local repeat database..."
echo ""

$LOAD_SINGULARITY #comment if singularity is in path

singularity exec --pwd /opt/RepeatMasker/Libraries/ "${INSTALLATION_DIR}/containers/tetools_1.8.sif" famdb.py -i RepeatMaskerLib.h5 lineage -ad ${VAR} > ${TMPDIR}/check_lineage.tmp 2>&1

if [[ $(cat ${TMPDIR}/check_lineage.tmp) == *"No species found for search term"* ]]; then
	echo "WARNING! $VAR not found!"
	echo "Please add a proper lineage to LINEAGE_NAME variable in 1.repeat_variables.cnf file"
else
	echo ""
	echo ""
	echo "Looks like $VAR is present in the local repeat database ;)"
fi

echo -e "Result of local database query: ${TMPDIR}/check_lineage.tmp"
