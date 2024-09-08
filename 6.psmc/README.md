# Past Population Dynamics Inference
🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰🧬🕰

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
                    ├── <..>_consensus.fasta              # Hard-masked assembly without small scaffolds and sex chromosomes, and with the SNPs information 
                    ├── <..>.psmcfa                       
                    ├── <..>.psmcfa.split.psmcfa          
                    ├── <..>.psmc                         # result using the entire consensus
                    ├── round-1.psmc                      # result using the first bootstrap replicate of the consensus
                    ├── ..
                    ├── round-<BOOTST>.psmc               # result using the last bootstrap replicate of the consensus
                    ├── <..>.combined.psmc                # final combined result
                    └── plots.m<MUTATION>.g<GENERATION>
                        ├── <..>_plot.pdf                 # PSMC plot
                        ├── <..>_plot.0.txt               # raw data to plot
                        ├── <..>_plot.<BOOTST>.txt        
                        └── ..
```

### How to run?

1) Edit `1.psmc_variables.cnf` file with the respective paths, values and parameters.

2) Run the analysis with: `bash 3.Run_psmc.sh`

OPTIONAL: if you want to re-run the PSMC with different parameters (`PARAMS`) and/or time intervals (`TIME_INT`) values, edit accordingly `1.psmc_variables.cnf` and run: `bash OPTIONAL_rePSMC.sh`

OPTIONAL: if you want to re-scale the PSMC results with different `MUTATION` and/or `GENERATION` values, edit accordingly `1.psmc_variables.cnf` and run: `bash OPTIONAL_reScale.sh`

\*) It uses up to 8 cpus and 16 Gb of RAM

---
### About the analysis and setting of the parameters:

The PSMC estimates changes in the effective population size (Ne) through time.

The script uses a hardmasked assembly without small scaffolds or sex chromosomes, and based on a VCF with high confidence SNPs, produces a consensus fasta where diploid information is presented by using ambiguity codes (e.g., a 'Y' is placed for a heterozygote position for C and T nucleotides) to start the analysis.

It will first, run the analysis on the entire consensus, and after that, run it on a defined number of bootstrap replicates of the consensus. In the end, it combines the results of the original analysis and the bootstrap replicates into a single file.

Since the PSMC values are in coalescent units, which are not directly comparable to real-time, we need to scale it using a per-generation mutation rate and a generation time in years so the results can be plotted to show the effective population size of the population over a real-time scale.

\>\>\>\>\> Important variables when running analysis:

**PARAMS**: this variable contains the following parameters
* -N: maximum number of iterations. The program's default is 30
* -t: maximum 2N0 coalescent time (the time it takes for two lineages to coalesce in a population of size = 2 * initial Ne). The program's default is 15
* -r: initial theta/rho ratio (ratio of the mutation rate to the recombination rate). The program's default is 4
> Example for humans: -N25 -t15 -r5
>
> 

**TIME_INT**: this variable corresponds to -p (time interval patterns). Time intervals are followed by a "+" symbol to separate them. The number corresponds to the widths in coalescent time units. The notation is: "amount of intervals"\*"width"+"amount of intervals"\*"width". The program's default is "4+5\*3+4"
> Example for humans: -p "4+25\*2+4+6"
> 
> The first interval spans 4 time units, the next 25 intervals spans 2 time units, the 27th interval spans 4 time units, and the last interval spans 6 time units (for a total of 64). A poor choice of intervals can lead to over- or underfitting of the model. Repeating the analysis using different numbers of time intervals can show whether there is any impact on the inferences (Nadachowska-Brzyska et al. 2016).

**BOOTST**: number of resampling iterations
> A higher number of bootstraps generally leads to more precise estimates but increase computational time

**MUTATION**: per-generation mutation rate
> It will determine the scale of time in PSMC results. A higher mutation rate will compress the time axis, making events appear more recent, while a lower mutation rate will stretch the time axis, making events appear more ancient. 

**GENERATION**:  generation time in years
> It will affect the scaling of the time axis in the results. A longer generation time will stretch the time axis, making events appear more ancient, while a shorter generation time will compress the time axis, making events appear more recent

