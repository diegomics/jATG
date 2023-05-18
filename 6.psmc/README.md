# Past Population Dynamics Inference
🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰

This analysis estimates historical population sizes from a single genome sequence using the Pairwise Sequentially Markovian Coalescent (PSMC). Considering its limitations (e.g., assumptions about recombination rates and low accuracy for recent historical changes), it's a powerful way to glean insights about the demographic history of the species directly from the assembly.

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
                ├── number_lengths_GC_Ns    # table with number of scaffold, name, length (decreasing order), GC rate, % of Ns 
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

\*) It uses up to 8 cpus and 16 Gb of RAM
