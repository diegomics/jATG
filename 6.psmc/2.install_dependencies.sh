source 1.psmc_variables.cnf

echo ""
echo "* creating conda environment..."
echo ""
export PATH="${CONDA_BIN_DIR}:${PATH}"
conda create -n PSMC_env -y -c conda-forge psmc=0.6.5 bcftools=1.17 samtools=1.17 htslib=1.17 gnuplot=5.4.5 texlive-core=20230313

