# Variant Calling & Filtering
🧬🧐🧬🧐🧬🧐🧬🧐🧬🧐🧬🧐🧬🧐🧬🧐

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
                        │   ├── <..>.filt_heterozygosity                         # estimated genome-wide heterozygosity(bp): hetCalls/totalCalls
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

---
### About the analysis and setting of the parameters:

During the variant calling analysis, short paired-end reads or long HiFi reads are mapped agains the assembly using bwa-mem2 or minimap2, respectively. 
It accepts multiple reads files from the same sample (if available) and maps them in parallel to finally merge all in a unique bam.
After deduplication, it will get metrics based on the BAM for evaluation.

The variant calling step consists of splitting the analysis in scaffolds, adding 200 Mbp (if possible) for better parallelisation, and running HaplotypeCaller followed by GenotypeGVCFs to produce a basepair resolution raw gVCF. Next, all scaffolds shorter than 5 Mbp are removed together with scaffolds pointed as sex chromosomes.
Next, the genotypes in the gVCF are turned into missing "./." in all the regions masked based on a bed file with the positions of the masked regions across the assembly.

Finally, the following [recommended](https://gatk.broadinstitute.org/hc/en-us/articles/360035890471-Hard-filtering-germline-short-variants) variant filters are applied, also turning the genotypes to missing:

- Sample's Depth (DP): less than *MIN_DEPTH* or more than *MAX_DEPTH*
- Quality by Depth (QD) < 2.0
- Fisher Strand bias (FS) > 60.0
- Mapping Quality (MQ) < *MAP_QUAL*
- MQRankSum < -12.5
- ReadPosRankSum < -8.0; ReadPosRankSum > 8.0
- Symmetric Odds Ratio (SOR) > 3.0
- number of alternate alleles > 1
- Allelic Depth (AD): 0/1 < 20%; 0/1 > 80%; 0/0 or 1/1 >10% 
- InDels: all

After filtering, it will get metrics based on the VCF (before and after) for evaluation.

\>\>\>\>\> Important variables when running the analysis:

**MASKED_BED**: a 3-column bed file with positions of masked segments (scaffold_name, start_position, end_position)
> This file is produced during the masking analysis. If the masking analysis was not performed, the script `../2.masking/scripts/softmasked_to_bed.py` can produce the 3 columns bed file from a softmasked fasta file.

**SEX_CHROMS**: names of the scaffold that has sex chromosome identity. If more than one scaffold, use a comma between names
> These scaffolds will be filtered

**TRIMMED_READS_DIR**: folder with the trimmed reads files
> All reads should be in the same folder

**READ_TYPE**: "HiFi" or "illuminaPE"

**SAMPLE_NAME**: name of the sample where the reads are coming

**MULTI_RUN**: if you have more several read files from the same sample, set it to "True"

The following VCF filtering criteria are adjustable:

**MIN_DEPTH**: minimum read depth
> The default value is 1/3 * mean coverage 

**MAX_DEPTH**: maximum read depth
> The default value is 2 * mean coverage

**MAP_QUAL**: minimum mapping quality
> The default value is 40

