# Variant Calling & Filtering
🧬🧐🧬🧐🧬🧐🧬🧐🧬🧐🧬🧐🧬🧐

Complete variant-calling pipeline based on [GATK](https://gatk.broadinstitute.org/hc/en-us), including filtering and BAM/VCF metrics analysis. Accepts Illumina paired-end and PacBio HiFi reads.


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
                └── 4.snp_calling
                    ├── 0_idx
                    │   └── ..
                    ├── 1_BAMs
                    │   ├── ..
                    │   ├── eval                                                 # BAM-based metrics folder
                    │   │   ├── <..>.markdup_metrics.txt                         # dups metrics
                    │   │   ├── <..>.merged_MeanCov                              # mean coverage based on the merged BAM
                    │   │   ├── <..>.merged_RefCov.md                            # markdown table with metrics by scaffolds
                    │   │   └── <..>.rmd_PrimAligRead                            # Number of primary aligned reads
                    │   ├── <..>.merged.bam
                    │   └── <..>.merged.bam.bai
                    └── 2_VCFs
                        ├── filtered                                             # Filtered VCFs VCF-based metrics folder
                        │   ├── <..>.Genot.full.mainNoSex.mask.filt.vcf.bgz      # base pair resolution filtered gVCF
                        │   ├── <..>.Genot.full.mainNoSex.mask.filt.vcf.bgz.tbi
                        │   ├── <..>.Genot.full.mainNoSex.mask.filt.stats        # base pair resolution filtered gVCF full stats (number of SNPs, etc)
                        │   ├── <..>.Genot.PASS.bcf                              # filtered binary VCF
                        │   ├── <..>.Genot.PASS.bcf.csi
                        │   ├── <..>.Genot.PASS.stats                            # filtered binary VCF full stats (number of SNPs, etc)
                        │   ├── <..>.filt_heterozygosity                         # estimated heterozygosity
                        │   ├── <..>.main_scaffoldsNoSex_lengths                 # list of main scaffolds (>5Mbp) without Sex chrom names and lengths
                        │   ├── <..>.meanCov                                     # mean coverage based on the raw base pair resolution gVCF
                        │   └── <..>.meanCov_byChrom                             # mean coverage by scaffold based on the raw base pair resolution gVCF
                        ├── <..>.Genot.full.bcf                                  # raw (unfiltered) base pair resolution binary gVCF
                        ├── <..>.Genot.full.bcf.csi
                        ├── <..>.Genot.full.stats                                # raw (unfiltered) full stats (number of SNPs, etc)
                        └── ..
```

### How to run?

* PacBio HiFi trimmed reads should end with (trim\*fq, or fq, or trim\*fastq, or fastq).gz
* Illumina paired-end trimmed reads should end with (1.trim\*fq, or 1.fq, or 1.trim\*fastq, or 1.fastq).gz

1) Edit `1.calling_variables.cnf` file with the respective paths, values and parameters.

2) Run the variant calling pipeline: `bash 2.Run_calling.sh`

\*) The pipeline is configured to use up to 24 CPUs and 64 GB of RAM


### About the analysis and setting of the parameters:

During the variant calling analysis, short paired-end reads or long HiFi reads are mapped agains the assembly using bwa-mem2 or minimap, respectively. 
It accepts multiple reads files from the same sample (if available) and mapped them in parallel to finally merge all in a unique bam.
After deduplication, it will get metrics based on the bam for evaluation.

The variant calling step consist in splitting the analysis in scaffolds adding 200 Mbp (if possible) for better parallelisation, and running HaplotypeCaller followed by GenotypeGVCFs to produce a basepair resolution raw gVCF. Next all scaffolds shorter than 5 Mbp are removed together with scaffolds pointed as sex-chromosomes.
Next, the genotypes in the gVCF are turned into missing "./." in all the regions masked based on a bed file with the positions to the masked regions across the assembly. Finally, the following filters are applied, also turning the genotypes to missing when the criteria is not met:
Read depth:
Sample's Depth (DP)
Quality by Depth (QD)
Fisher Strand bias (FS)
Mapping Quality (MQ)
MQRankSum
ReadPosRankSum
Symmetric Odds Ratio (SOR)
number of alternate alleles
Allelic Depth (AD) 
indel

Important variables to run the analysis:

MASKED_BED: a 3 columns bed file with positions of masked segments (scaffold_name, start_position, end_position). This file is produced during the masking analysis. If the masking analysis was not performed, the script ../2.masking/scripts/softmasked_to_bed.py can produce the 3 columns bed file from a softmasked fasta file.

SEX_CHROMS:

TRIMMED_READS_DIR:

READ_TYPE:

SAMPLE_NAME:

MULTI_RUN:

MIN_DEPTH:

MAX_DEPTH:

MAP_QUAL:

