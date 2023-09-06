# Genome-wide GC and Telomeric Regions Identification
🧬📈🧬🔚🧬📈🧬🔚🧬📈🧬🔚🧬📈🧬🔚🧬📈🧬🔚🧬📈🧬🔚🧬📈🧬🔚🧬📈

This analysis generates a diagram of the scaffolds showing the GC%, the telomeric signal, and the gaps across its length. 

## Output:
```
[OUT_DIR]
└── jATG
    └── [SPECIES_NAME]
        └── [ASSEMBLY_ID]
            ├── 1.stats
            │   └── ..
            ├── 2.masking
            │   └── ..
            └── 3.gc_telo
                ├── ..
                ├── <..>_GC.tab                         # GC% across the assembly
                ├── <..>_telomeric_repeat_windows.tsv   # telomeric signal across the assembly
                ├── <..>_gaps.bed                       # position of the gaps across the assembly
                └── plots
                    ├── COMBINED_GAPS_GC_TELO.svg       # plot showing GC%, telomeric signal and gaps in all chromosomes
                    ├── <..>_GAPS_GC_TELO.svg           # plot showing GC%, telomeric signal and gaps in each chromosome
                    └── ..
```

### How to run?

Requirements:
* [Conda](https://docs.conda.io)


1) Edit `1.gc_telo_variables.cnf` file with the respective paths, values and parameters.

2) Install needed software with: `bash 2.install_gc_telo_dependencies.sh`

3) Run the masking pipeline in _Slurm_ with: `bash 3.run_GC_Telo.sh`
