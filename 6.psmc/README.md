# Past Population Dynamics Inference
🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰

This analysis **estimates historical population sizes from a single genome sequence** using the Pairwise Sequentially Markovian Coalescent (**PSMC**). Considering its **limitations** (e.g., assumptions about **recombination rates** and low accuracy for **recent historical changes**), it's a powerful way to glean insights about the **demographic history** of the species directly from the assembly.

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
            ├── 3.gc_telo
            │   └── ..
            └── [SAMPLE_NAME]
                ├── 4.snp_calling
                │   └── ..
                ├── 5.het_roh
                │   └── ..
                └── 6.psmc
                    └── ..

```

### How to run?

Requirements:
* [Slurm](https://slurm.schedmd.com)
* [Conda](https://docs.conda.io)


1) Edit `1.psmc_variables.cnf` file with the respective paths, values and parameters.

2) Install needed software with: `bash 2.install_psmc_dependencies.sh`

3) Run the masking pipeline in _Slurm_ with: `bash 3.Run_psmc.sh`

\*) It uses up to 8 cpus and 16 Gb of RAM
