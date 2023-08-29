🧬 → 🙏 → 🤖 → 📊 → 🥹
# ...Coming soon!



### How to run?

Requirements:
* [Slurm](https://slurm.schedmd.com)
* [Conda](https://docs.conda.io)
* [Singularity](https://sylabs.io/guides/3.0/user-guide/index.html)


1) Clone this repo, i.e.: `git clone https://github.com/diegomics/jATG.git`

2) Edit the file `0.general_variables.cnf` with the respective paths, values and parameters.

3) Install needed software with: `bash install_jATG_dependencies.sh` **IMPORTANT:** this should be done only once!

4) Enter each folder to configure and run the particular analysis



---

In the end, the analysis produces the following output structure:
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
                ├── 5.het_roh.w..
                │   └── ..
                └── 6.psmc
                    └── ..

```
