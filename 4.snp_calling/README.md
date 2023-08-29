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
                    │   │   ├── <..>.merged_RefCov.md                            # markdown table for coverage
                    │   │   └── <..>.rmd_PrimAligRead                            # Number of primary aligned reads
                    │   ├── <..>.merged.bam
                    │   └── <..>.merged.bam.bai
                    └── 2_VCFs
                        ├── filtered                                             # Filtered VCFs VCF-based metrics folder
                        │   ├── <..>.Genot.full.mainNoSex.mask.filt.vcf.bgz      # base pair resolution filtered gVCF
                        │   ├── <..>.Genot.full.mainNoSex.mask.filt.vcf.bgz.tbi
                        │   ├── <..>.Genot.full.mainNoSex.mask.filt.stats        # base pair resolution filtered gVCF full stats (number of SNPs, etc)
                        │   ├── <..>.ERR6412365.Genot.PASS.bcf                   # filtered binary VCF
                        │   ├── <..>.ERR6412365.Genot.PASS.bcf.csi
                        │   ├── <..>.ERR6412365.Genot.PASS.stats                 # filtered binary VCF full stats (number of SNPs, etc)
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
