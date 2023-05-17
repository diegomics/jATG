# 1. Quick Stats

This first analysis aims to generate a rapid overview of the genome assembly and produce outputs that come in handy posteriorly.

## Output:
```
[OUT_DIR]
└── jATG
    └── [SPECIES_NAME]
        └── [ASSEMBLY_ID]
            └── 1.stats
                ├── <..>_shortStats.tsv     # very brief stats of the assembly
                ├── full_fasta_header       # complete header of each scaffold
                ├── main_scaffolds          # list with scaffolds longer than 5 Mbp
                ├── number_lengths_GC_Ns    # TSV table with number of scaffold, name, length (decreasing order), GC rate, % of Ns, 
                ├── <..>_sequences.fasta    # sex chromosomes linked genes sequences identified for the species
                ├── <..>_genes.txt          # sex chromosomes linked genes IDs
                ├── <..>.blast              # table with matches between sex chromosome linked genes and the assembly
                ├── <..>.SYNTENYTAB.tsv     # synteny between the assembly and a reference (if provided)
                ├── <..>.png                # DotPlot between the assembly and a reference (if provided)
                └── ..

```

### How to run?

Requirements:
* [Slurm](https://slurm.schedmd.com)
* [Conda](https://docs.conda.io)


1) Edit `1.stats_variables.cnf` file with the respective paths, values and parameters.

2) Install needed software with: `bash 2.install_stats_dependencies.sh`

3) Run the masking pipeline in _Slurm_ with: `bash 3.Run_stats.sh`

\*) It uses up to 16 cpus and 192 Gb of RAM (this can be adjusted in slurm/RepeatM.job)
