# 2. Repeats Annotation and Masking Analysis
🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷

This analysis generates a species-tailored masked version of the genome and annotation files using RepeatModeler and RepeatMasker. It also produces quick analysis from the repeats and generates files useful for downstream steps and posterior (deeper) analysis.

## Output:
```
[OUT_DIR]
└── jATG
    └── [SPECIES_NAME]
        └── [ASSEMBLY_ID]
            ├── 1.overview
            │   └── ..
            └── 2.masking
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
                    ├── <..>.3cols.bed          # coordinates of assembly that is masked
                    ├── <..>.tbl                # summary result of the repeats in the assembly
                    ├── <..>.align.divsum.html  # abundance of repeats in the assembly vs the Kimura divergence from the consensus  
                    ├── <..>.svg                # svg version of the repeat landscape <..>.align.divsum.html
                    └── ..

```

### How to run?

1) Edit `1.repeat_variables.cnf` file with the respective paths, values and parameters.

2) Run `bash 2.lineage_check.sh` to check if the species name is present in the local repeat database. If the species is not present, fill with a proper lineage in `1.repeat_variables.cnf` and re-run `2.lineage_check.sh`

3) Run the masking pipeline: `bash 3.Run_RepeatM_slurm.sh`

\*) It uses up to 16 cpus and 192 Gb of RAM (this can be adjusted in slurm/RepeatM.job)

\**) Running time depends on the genome and computing resources (e.g., a mammal can take 2-5 days to finish the pipeline).
