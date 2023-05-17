# Genomic Repeats: Annotation and Masking Analysis
🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷🧬😷

This second analysis generates a species-tailored masked version of the genome using RepeatModeler and RepeatMasker. It produces quick analysis on the repeats and generates files useful for downstream steps and posterior (deeper) analysis.

## Output:
```
[OUT_DIR]
└── jATG
    └── [SPECIES_NAME]
        └── [ASSEMBLY_ID]
            ├── 1.stats
            |   └── ..
            └── 1.stats
                ├── ..
                ├── <..>.HM.fa      # hard-masked genome   
                └── <..>.masked.fa  # soft-masked genome

```

## Requirements:
* [Conda](https://docs.conda.io)
* [Singularity](https://sylabs.io/guides/3.0/user-guide/index.html)


## Run the pipeline:

1) Edit `1.repeat_variables.cnf` file with the respective paths, values and parameters.

2) Install needed software with: `bash 2.install_repeat_dependencies.sh`

3) Run the masking pipeline in _Slurm_ with: `bash 3.Run_RepeatM_slurm.sh`

\*) It uses up to 12 cpus and 64 Gb of RAM

\**) For the Asian elephant genome, it takes ~48 h to finish the pipeline.

## Output:
```
[OUT_DIR]
└── jATG
    └── [SPECIES_NAME]
        └── [ASSEMBLY_ID]
            ├── 1.stats
            │   └── ..
            └── 2.masking
                ├── 1_modeler
                │   └── ..
                ├── 2_libraries
                │   └── ..
                └── 3_masker
                    ├── ..
                    ├── <..>.html    
                    ├── <..>.out
                    ├── <..>.tbl
                    ├── <..>.3cols.bed  # merged bed file
                    ├── <..>.bed        # full masking annotation
                    ├── <..>.HM.fa      # hard-masked genome
                    └── <..>.masked.fa  # soft-masked genome
```
