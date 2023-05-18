source 1.stats_variables.cnf

echo ""
echo "* creating conda environment..."
echo ""
export PATH="${CONDA_BIN_DIR}:${PATH}"
conda create -n STATS_env -y -c conda-forge -c agbiome assembly-stats bbtools miniprot seqtk fastx_toolkit minimap2 r-ggplot2 r-optparse r-plotly biopython
