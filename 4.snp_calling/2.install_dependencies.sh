source 1.calling_variables.cnf

echo ""
echo "* creating conda environment..."
echo ""
export PATH="${CONDA_BIN_DIR}:${PATH}"
conda create -n CALLING_env -y -c bioconda bwa-mem2=2.2.1 minimap2=2.26 samtools=1.17 htslib=1.17 bcftools=1.17 picard=3.0.0 csvtk=0.25.0 bedtools=2.31.0 vcflib=1.0.3 vcftools=0.1.16 r-zoo

source activate CALLING_env

${SINGULARITY_LOAD}
BIN_VER="1.5.0"
LC_ALL=C singularity pull docker://google/deepvariant:"${BIN_VER}"
