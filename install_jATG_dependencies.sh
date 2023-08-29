source 0.general_variables.cnf

echo ""
echo "* creating conda environment ..."
echo ""
export PATH="${CONDA_BIN_DIR}:${PATH}"
conda create -n jATG_env -y -c conda-forge -c r -c agbiome -c bioconda -c jrhawley assembly-stats bbtools miniprot seqtk fastx_toolkit minimap2 bedops seqtk seqkit tidk bedtools samtools htslib bcftools bwa-mem2 csvtk vcflib psmc gnuplot texlive-core ghostscript biopython r-ggplot2 r-optparse r-plotly bioconductor-karyoploter r-cowplot r-tidyr r-svglite r-zoo r-rcartocolor

source activate jATG_env
conda install --force-reinstall -y -c conda-forge java-jdk

${SINGULARITY_LOAD}

echo ""
echo -e "* building singularity container in ${INSTALLATION_DIR}/containers ..."
echo ""
mkdir -p ${INSTALLATION_DIR}/containers
cd ${INSTALLATION_DIR}/containers
LC_ALL=C
singularity pull docker://dfam/tetools:1.8
singularity pull docker://broadinstitute/gatk:4.2.6.1
ln -s ${INSTALLATION_DIR}/containers/gatk_4.2.6.1.sif gatk_latest.sif
#singularity pull docker://broadinstitute/gatk:4.4.0.0
#ln -s ${INSTALLATION_DIR}/containers/gatk_4.4.0.0.sif gatk_latest.sif
