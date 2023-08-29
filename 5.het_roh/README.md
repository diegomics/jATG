# Genome-wide Heterozygosity and Runs of Homozygosity
🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬

It runs in one take [Darwindow](https://github.com/mennodejong1986/Darwindow/tree/main), a tool to calculate and plot genetic estimates on a sliding-window basis, like runs of homozygosity.

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
                └── 5.het_roh.w<WIN_SIZE>
                    ├── mywindowhe.100000.<..>.txt 
                    ├── Genomewide_regionHe.ind.barplot.pdf
                    ├── He_histo_region.pdf
                    ├── He_histo_window_20000.pdf
                    ├── Rplots.pdf
                    ├── He_with_vs_withoutROH.pop.pdf
                    ├── ..
                    └── ..

```

### How to run?

1) Edit `1.HeRoH_variables.cnf` file with the respective paths, values and parameters.

2) Run the analysis: `bash 2.Run_roh.sh`

3) OPTIONAL: if you want to run the analysis with different values of `NUM_WIN` and/or `MAX_MISS` and/or `HET_TRES`, edit accordingly `1.HeRoH_variables.cnf` and run: `bash OPTIONAL_rerun.sh`
   **IMPORTANT:** for running with a different value of `WIN_SIZE`, edit accordingly `1.HeRoH_variables.cnf` and run `2.Run_roh.sh`
