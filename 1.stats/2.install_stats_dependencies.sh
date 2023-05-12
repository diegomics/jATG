source 1.stats_variables.cnf

echo ""
echo "* creating conda environment..."
echo ""
export PATH="${CONDA_BIN_DIR}:${PATH}"
conda create -n STATS_env -y -c bioconda -c agbiome assembly-stats bbtools
