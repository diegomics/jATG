source $(dirname $PWD)/0.general_variables.cnf
source 1.stats_variables.cnf

export PATH="${CONDA_BIN_DIR}:${PATH}"
source activate jATG_env


python ${INSTALLATION_DIR}/1.stats/scripts/search_sex_scaffolds.py ${USER_MAIL} ${REF_SPECIES_NAME} --ask

