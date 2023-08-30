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
                    ├── scaffolds_ok # list of scaffolds >5Mbp and without sex chrom.
                    ├── scaffolds_ok.vcf.gz # filtered VCF containing only scaffolds_ok
                    ├── <..>_consensus.fasta
                    ├── <..>.psmcfa
                    ├── <..>.psmcfa.split.psmcfa
                    ├── <..>.psmc
                    ├── round-1.psmc
                    ├── round-2.psmc
                    ├── ..
                    ├── <..>.combined.psmc
                    ├── <..>.png
                    └── ..
```

### How to run?

1) Edit `1.psmc_variables.cnf` file with the respective paths, values and parameters.

2) Run the analysis with: `bash 3.Run_psmc.sh`

OPTIONAL: if you want to re-scale the PSMC results with different `MUTATION` and `GENERATION` values, edit accordingly `1.psmc_variables.cnf` and run: `bash OPTIONAL_rescale.sh`

\*) It uses up to 8 cpus and 16 Gb of RAM


### About the analysis and setting of the parameters:

The PSMC estimates changes in the effective population size (Ne) through time.

The script uses a hardmasked assembly without small scaffolds or sex-chromosomes, and based on a vcf with high confidence SNPs, produces a consensus fasta where diploid information is presented by using ambiguity codes (e.g., a 'Y' is placed for a heterozygote position for C and T nucleotides) to start the analysis.

It will first, runs the analysis on the entire consensus, and after that, it will run it on a defined number of bootstrap replicates of the consensus. At the end, it combines the results of the original analysis and the bootstrap replicates into a single file.

Since the PSMC values are in coalescent units, which are not directly comparable to real time, we need to scale it using a per-generation mutation rate and a generation time in years so the results can be plotted to show the effective population size of the population over a real time scale.

Important variables to run the analaysis :

**PARAMS** this variable contains the following parameters
* -N: 
* -t: scaled mutation rate (theta)
* -r: scaled recombination rate (rho)
> blabla

**TIME_INT** this variable corresponds to:
* -p: time interval patterns = number of intervals with particular widths in coalescent time units
> blabla

**BOOTST**: this variable assigns the number of bootstraps
> blabla

**MUTATION**

**GENERATION**
> blabla

