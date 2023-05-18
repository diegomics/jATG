source 1.gc_telo_variables.cnf

echo ""
echo "* creating conda environment..."
echo ""
export PATH="${CONDA_BIN_DIR}:${PATH}"
conda create -n GC_TELO_env -y -c conda-forge r-base bioconductor-karyoploter r-cowplot seqtk tidk 
#conda create -n GC_TELO_env -y -c bioconda -c conda-forge r-base bioconductor-karyoploter r-cowplot seqkit tidk
