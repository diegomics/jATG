# Variant Calling
🧬🧐🧬🧐🧬🧐🧬🧐

This step does the variant calling 



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
                    │   ├── eval ### BAM-based metrics
                    │   │   ├── <..>.markdup_metrics.txt ### dups metrics
                    │   │   ├── <..>.merged_MeanCov ### mean coverage
                    │   │   ├── <..>.merged_RefCov.md ### markdown table for coverage
                    │   │   └── <..>.rmd_PrimAligRead ### Number of primary aligned reads [CHECK THIS, it's counting dups?]
                    │   ├── <..>.merged.bam
                    │   └── <..>.merged.bam.bai
                    └── 2_VCFs
                        ├── filt ### VCF-based metrics and filtered VCFs
                        │   ├── <..>.PASS.lqual ### [site quality]
                        │   ├── <..>.PASS.ldepth.mean  ### [mean coverage depth per site]
                        │   ├── <..>.PASS.vcf_meanCov ### [Mean and SD coverage]
                        │   ├── <..>.PASS_snps_amount ### [Amount of total and filtered SNPs]
                        │   ├── <..>.PASS_filtered.vcf.gz ### [filtered VCF]
                        │   ├── <..>.PASS_filtered.vcf.gz.csi
                        │   ├── <..>.PASS.masked_filtered.vcf.gz ### [filtered & masked VCF]
                        │   └── <..>.PASS.masked_filtered.vcf.gz.csi
                        ├── <..>.g.vcf.gz
                        ├── <..>.g.vcf.gz.tbi
                        ├── <..>.FULL.g.vcf.gz  ### [base pair resolution gVCF]
                        ├── <..>.FULL.g.vcf.gz.csi
                        ├── <..>.vcf.gz
                        ├── <..>.vcf.gz.tbi
                        ├── <..>.PASS.vcf.gz ### [unfiltered VCF]
                        ├── <..>.PASS.vcf.gz.csi
                        └── <..>.visual_report.html
```

### How to run?

Requirements:
* [Slurm](https://slurm.schedmd.com)
* [Conda](https://docs.conda.io)
* [Singularity](https://sylabs.io/guides/3.0/user-guide/index.html)
* PacBio HiFi trimmed reads should end with (trim\*fq, or fq or trim\*fastq or fastq).gz
* Illumina paired-end trimmed reads should end with (1.trim\*fq, or 1.fq or 1.trim\*fastq or 1.fastq).gz

1) Edit `1.calling_variables.cnf` file with the respective paths, values and parameters.

2) Install needed software with: `bash 2.install_dependencies.sh`

3) Run the variant calling pipeline in _Slurm_ with: `bash 3.Run_DeepVariant_calling.sh`

\*) The pipeline is configured to use 24 CPUs and 64 GB of RAM
