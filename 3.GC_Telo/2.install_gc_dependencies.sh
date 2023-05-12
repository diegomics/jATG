source 1.XXXXX_variables.cnf

echo ""
echo "* creating conda environment..."
echo ""
export PATH="${CONDA_BIN_DIR}:${PATH}"
conda create -n GC_env -y -c bioconda -c conda-forge r-base bioconductor-karyoploter r-cowplot seqkit
