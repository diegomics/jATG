## Requirements:
* [Slurm](https://slurm.schedmd.com)
* [Conda](https://docs.conda.io)
* [Singularity](https://singularity-userdoc.readthedocs.io/en/latest/index.html)

**RAW READS:** 
<---- TODO: QC/Trimming job 

. PacBio HiFi reads should end with .fq.gz

. Illumina paired-end reads should end with .R1.fq.gz and .R2.fq.gz

**TRIMMED READS:**

* HiFi reads should end with .trimmed.fq.gz
* paired-end reads should end with _R1.trimmed.fq.gz and _R2.trimmed.fq.gz


The pipeline is configured to use 24 CPUs and 64 GB of RAM

## 1) Getting ready:
Edit `1.calling_variables.cnf` file with the respective paths, values and parameters.

## 2) Install dependecies:
```
bash 2.install_dependencies.sh
```

## *) -Optional- QC and filtering of reads:
If reads are already trimmed uncomment and complete TRIMM_DIR variable, and comment FQ_DIR variable in `1.calling_variables.cnf` file

## 3) Run the variant calling pipeline:
```
bash 3.Run_DeepVariant_calling.sh
```


*) Output:

```bash
<output_folder>
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

