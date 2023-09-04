source 0.general_variables.cnf

export PATH="${CONDA_BIN_DIR}:${PATH}"

if conda env list | grep "jATG_env" >/dev/null 2>&1
then
        echo "jATG_env already available!"
else
        echo "* creating conda environment ..."
	conda create -n jATG_env2 -y -c conda-forge -c r -c agbiome -c bioconda -c jrhawley assembly-stats bbtools miniprot seqtk fastx_toolkit minimap2 bedops seqtk seqkit tidk bedtools samtools htslib bcftools bwa-mem2 csvtk vcflib psmc gnuplot texlive-core ghostscript biopython r-ggplot2 r-optparse r-plotly bioconductor-karyoploter r-cowplot r-tidyr r-svglite r-zoo r-rcartocolor
	#source activate jATG_env
	#conda install --force-reinstall -y -c conda-forge java-jdk
fi


${SINGULARITY_LOAD}
LC_ALL=C
mkdir -p ${INSTALLATION_DIR}/containers
cd ${INSTALLATION_DIR}/containers

if [ -e "${INSTALLATION_DIR}/containers/gatk_latest.sif" ]
then
	echo "GATK container already available!"
else
	echo -e "* building GATK singularity container in ${INSTALLATION_DIR}/containers ..."
	singularity pull docker://broadinstitute/gatk:4.2.6.1
	ln -s gatk_4.2.6.1.sif gatk_latest.sif
fi


if [ -e "${INSTALLATION_DIR}/containers/tetools_latest.sif" ]
then
        echo "TETools container already available!"
else
        echo -e "* building TETools singularity container in ${INSTALLATION_DIR}/containers ..."
        singularity pull docker://dfam/tetools:1.85
        ln -s tetools_1.8.sif tetools_latest.sif
fi
