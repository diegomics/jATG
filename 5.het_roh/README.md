# 4. Genome-wide Heterozygosity and Runs of Homozygosity
🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🏃‍♀️🧬🏃🧬🏃‍♂️🧬🧬🏃‍♀️🧬🏃🧬

This analysis relies on [Darwindow](https://github.com/mennodejong1986/Darwindow/tree/main) to calculate and plot genetic estimates on a sliding-window basis, like heterozygosity and runs of homozygosity.

## Output:
```
[OUT_DIR]
└── jATG
    └── [SPECIES_NAME]
        └── [ASSEMBLY_ID]
            ├── 1.overview
            │   └── ..
            ├── 2.masking
            │   └── ..
            └── [SAMPLE_NAME]
                ├── 3.calling
                │   └── ..
                └── 4.het_roh
                    ├── w<WIN_SIZE>
                    │   └── w<WIN_SIZE>n<NUM_WIN>m<MAX_MISS>h<HET_TRES>  # folder with results for the provided parameters
                    │       ├── darwindow.RData                          # R session of the analysis
                    │       ├── fROH.svg                                 # barplot of genome-wide proportion of RoH binned by size
                    │       ├── fROH.txt                                 
                    │       ├── lROH.svg                                 # barplot of genome-wide sum-length of RoH binned by size
                    │       ├── lROH.txt                                 
                    │       ├── nROH.svg                                 # barplot of genome-wide total number of RoH binned by size
                    │       ├── nROH.txt                                 
                    │       ├── Genomewide_He.txt                        # genome-wide heterozygosity (%)
                    │       ├── Genomewide_propROH.txt                   # genome-wide proportion of RoH
                    │       ├── ROH_positions.txt                        
                    │       ├── Scaff_He.txt                             # heterozygosity (%) per scaffold
                    │       ├── Scaff_propROH.txt                        # proportion of RoH per scaffold
                    │       ├── totalROHsMb.txt                           
                    │       ├── Total_ROHs_number.txt                    
                    │       ├── He_histo_region.pdf                      
                    │       ├── He_withROH_<..>.1.pdf                    # RoH and heterozygosity per scaffold
                    │       └── ..
                    ├── mywindowhe.<WIN_SIZE>.allsites_roh.txt           # table showing per window: miss sites, non-miss sites, het sites, alt hom sites
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

* A region will be marked as RoH if it has the minimum length (in number of windows) as defined by *NUM_WIN*. Therefore, the limit of detection for a RoH is set as *WIN_SIZE* * *NUM_WIN*. The detected RoHs will be binned by length (in Mbp): ≤0.2, >0.2≤0.5, >0.5≤1, >1≤2, >2≤5, >5≤10, and >10.

\>\>\>\>\> Important variables when running analysis:

The main configuration is based on four parameters:

**WIN_SIZE**: Size of the window to calculate heterozygosity in base pairs (e.g., 25000)

**NUM_WIN**: Minimum number of adjacent windows to be considered as a RoH (e.g., 4)

**MAX_MISS**: Maximum proportion of missing data per window (e.g., 0.5)

**HET_TRES**: Heterozygosity threshold to consider a window as low heterozygous (e.g., 0.02)

*  A good practice is to try different values of the variables and review the results, particularly the heterozygosity curve across particular scaffolds and the fit of the RoH region in it to check consistency
