source 0.general_variables.cnf

export PATH="${CONDA_BIN_DIR}:${PATH}"

if mamba env list | grep "jATG_env" >/dev/null 2>&1
then
        echo "jATG_env already available!"
else
        echo "* creating conda environment ..."
	mamba create -n jATG_env -y \
 	-c conda-forge -c r -c agbiome -c bioconda -c jrhawley \
	assembly-stats=1.0.1 \
	bbtools=37.62 \
	bcftools=1.17 \
	bedops=2.4.41 \
	bedtools=2.31.0 \
	bioconductor-karyoploter=1.26.0 \
	biopython=1.81 \
	bwa-mem2=2.2.1 \
	csvtk=0.27.2 \
	fastx_toolkit=0.0.14 \
	ghostscript=9.56.1 \
	gnuplot=5.4.8 \
	htslib=1.17 \
	intervaltree=3.1.0 \
	minimap2=2.26 \
	miniprot=0.12 \
	pandas=2.1.3 \
	psmc=0.6.5 \
	samtools=1.17 \
	seqkit=2.5.1 \
	seqtk=1.4 \
	r-cowplot=1.1.1 \
	r-ggplot2=3.4.3 \
	r-optparse=1.7.3 \
	r-plotly=4.10.2 \
	r-rcartocolor=2.1.1 \
	r-svglite=2.1.1 \
	r-tidyr=1.3.0 \
	r-zoo=1.8_12 \
	texlive-core=20230313 \
	tidk=0.2.41 \
	vcflib=1.0.9 > environment_creation_log.txt 2>&1
fi


${SINGULARITY_LOAD}
export LC_ALL=C
mkdir -p ${INSTALLATION_DIR}/containers
cd ${INSTALLATION_DIR}/containers

GATK_VER="4.2.6.1"
TET_VER="1.85"

if [ -e "${INSTALLATION_DIR}/containers/gatk_${GATK_VER}.sif" ]
then
	echo "GATK container already available!"
else
	echo -e "* building GATK singularity container in ${INSTALLATION_DIR}/containers ..."
	singularity pull docker://broadinstitute/gatk:${GATK_VER}
	ln -s gatk_${GATK_VER}.sif gatk_latest.sif
fi


if [ -e "${INSTALLATION_DIR}/containers/tetools_${TET_VER}.sif" ]
then
        echo "TETools container already available!"
else
        echo -e "* building TETools singularity container in ${INSTALLATION_DIR}/containers ..."
        singularity pull docker://dfam/tetools:${TET_VER}
        ln -s tetools_${TET_VER}.sif tetools_latest.sif
fi
