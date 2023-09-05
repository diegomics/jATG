# Genome-wide Heterozygosity and Runs of Homozygosity
🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🧬🏃‍♀️🧬🏃🧬

This analysis relies on [Darwindow](https://github.com/mennodejong1986/Darwindow/tree/main) to calculate and plot genetic estimates on a sliding-window basis, like heterozygosity and runs of homozygosity.

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
                    ├── w<WIN_SIZE>n<NUM_WIN>m<MAX_MISS>h<HET_TRES>  # folder with results for the provided parameters
                    │   ├── darwindow.RData                          # R session of the analysis
                    │   ├── fROH.svg                                 # barplot 
                    │   ├── fROH.txt
                    │   ├── lROH.svg                                 # barplot
                    │   ├── lROH.txt
                    │   ├── nROH.svg                                 # barplot
                    │   ├── nROH.txt
                    │   ├── Genomewide_He.txt
                    │   ├── Genomewide_propROH.txt
                    │   ├── ROH_positions.txt
                    │   ├── Scaff_He.txt
                    │   ├── Scaff_propROH.txt
                    │   ├── totalROHsMb.txt
                    │   ├── Total_ROHs_number.txt
                    │   ├── He_histo_region.pdf
                    │   ├── He_withROH_<..>.1.pdf
                    │   └── ..
                    ├── mywindowhe.<WIN_SIZE>.allsites_roh.txt
                    └── ..

```

### How to run?

1) Edit `1.HeRoH_variables.cnf` file with the respective paths, values and parameters.

2) Run the analysis: `bash 2.Run_roh.sh`

3) OPTIONAL: if you want to run the analysis with different values of `NUM_WIN` and/or `MAX_MISS` and/or `HET_TRES`, edit accordingly `1.HeRoH_variables.cnf` and run: `bash OPTIONAL_rerun.sh`
   **IMPORTANT:** for running with a different value of `WIN_SIZE`, edit accordingly `1.HeRoH_variables.cnf` and run `2.Run_roh.sh`

---
### About the analysis and setting of the parameters:

Starting from a base-pair resolution filtered gVCF, the analysis proceeds as follows: First, get heterozygosity for a given windows size (*WIN_SIZE*). Then, based on the heterozygosity threshold (*HET_TRES*), classify the window as having less heterozygosity (low) or more (not-low) than the given value. Next, count contiguous low and not-low windows. Finally, get sections where low windows occur a number of times defined by a given value (*NUM_WIN*).

* A region will be marked as RoH if it has the minimum length (in number of windows) as defined by *NUM_WIN*. Therefore, the limit of detection for a RoH is set as *WIN_SIZE* * *NUM_WIN*

\>\>\>\>\> Important variables when running analysis
