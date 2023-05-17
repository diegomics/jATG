source 1.repeat_variables.cnf

if [ -z "${LINEAGE_NAME}" ]
then
      VAR=$(echo ${SPECIES_NAME} | sed 's/_/ /g')
else
      VAR=$(echo ${LINEAGE_NAME} | sed 's/_/ /g')
fi


echo ""
echo "* checking if ${VAR} is present in the local repeat database..."
echo ""

singularity exec --pwd /opt/RepeatMasker/Libraries/ tetools_1.8.sif famdb.py -i RepeatMaskerLib.h5 lineage -ad ${VAR} 2> check.tmp

if [[ $(cat check.tmp) == *"No species found for search term"* ]]; then
	echo "WARNING! $VAR not found!"
	echo "Please add a proper lineage to LINEAGE_NAME variable in 1.repeat_variables.cnf file"
else
	echo ""
	echo ""
	echo "Looks like $VAR is present in the local repeat database ;)"
fi

#rm check.tmp
