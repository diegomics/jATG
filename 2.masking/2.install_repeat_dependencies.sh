source 1.repeat_variables.cnf

echo ""
echo "* creating conda environment..."
echo ""
export PATH="${CONDA_BIN_DIR}:${PATH}"
conda create -n REPEAT_env -y -c bioconda bedops=2.4.39 bedtools=2.30.0
source activate REPEAT_env
echo ""
echo "* building singularity container in ${PWD}..."
echo ""
$LOAD_SINGULARITY
singularity pull docker://dfam/tetools:1.7
