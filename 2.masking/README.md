# Genomic Repeats: Annotation and Masking Analysis
🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷

This second analysis generates a species-tailored masked version of the genome and annotation files using RepeatModeler and RepeatMasker. It also produces quick analysis on the repeats and generates files useful for downstream steps and posterior (deeper) analysis.

## Output:
```
[OUT_DIR]
└── jATG
    └── [SPECIES_NAME]
        └── [ASSEMBLY_ID]
            ├── 1.stats
            │   └── ..
            └── 1.masking
                ├── 1_modeler
                │   ├── <..>.families.fa        # consensus repeat sequences de novo identified
                │   └── ..
                ├── 2_libraries
                │   ├── <..>-rm.fa              # species/lineage-specific repeat sequences from the built-in library
                │   └── <..>_combined.fa        # <..>.families.fa and <..>-rm.fa files combined
                └── 3_masker
                    ├── <..>.masked.fa          # soft-masked assembly
                    ├── <..>.HM.fa              # hard-masked assembly
                    ├── <..>.gff                # repeats annotation in gff3 format
                    ├── <..>.bed                # repeats annotation in bed format
                    ├── <..>..3cols.bed         # coordinates of assembly that is masked
                    ├── <..>.tbl                # summary result of the repeats in the assembly
                    ├── <..>.align.divsum.html  # abundance of repeats in the assembly vs the Kimura divergence from the consensus  
                    ├── <..>.svg                # svg version of the repeat landscape <..>.align.divsum.html
                    └── ..

```

### How to run?

:::info
Requirements:
* [Slurm](https://slurm.schedmd.com)
* [Conda](https://docs.conda.io)
* [Singularity](https://sylabs.io/guides/3.0/user-guide/index.html)
:::

1) Edit `1.repeat_variables.cnf` file with the respective paths, values and parameters.

2) Install needed software with: `bash 2.install_repeat_dependencies.sh`

3) Run the masking pipeline in _Slurm_ with: `bash 3.Run_RepeatM_slurm.sh`

\*) It uses up to 16 cpus and 192 Gb of RAM (this can be adjusted in slurm/RepeatM.job)

\**) For the Asian elephant genome, it takes ~48 h to finish the pipeline.

