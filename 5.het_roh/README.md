# Genome-wide Heterozygosity and Runs of Homozygosity
🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬

It runs in one take [Darwindow](https://github.com/mennodejong1986/Darwindow/tree/main), a tool to calculate and plot population-genetic estimates on a sliding-window basis, like runs of homozygosity.

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
                └── 5.het_roh
                    ├── mywindowhe.100000.<..>.txt 
                    ├── Genomewide_regionHe.ind.barplot.pdf
                    ├── He_histo_region.pdf
                    ├── He_histo_window_20000.pdf
                    ├── Rplots.pdf
                    ├── He_with_vs_withoutROH.pop.pdf
                    ├── ..
                    ├── ..
                    ├── ..
                    ├── ..
                    ├── ..
                    ├── ..
                    └── ..

```

### How to run?

Requirements:
* [Slurm](https://slurm.schedmd.com)
* [Conda](https://docs.conda.io)


1) Edit `1.roh_variables.cnf` file with the respective paths, values and parameters.

2) Install needed software with: `bash 2.install_roh_dependencies.sh`

3) Run the masking pipeline in _Slurm_ with: `bash 3.Run_het_roh.sh`

\*) 
