# 🧬 → 🙏 → 🤖 → 📊 → 🥹 ...Coming soon!




### How to run?

Requirements:
* [Slurm](https://slurm.schedmd.com)
* [Conda](https://docs.conda.io)
* [Singularity](https://sylabs.io/guides/3.0/user-guide/index.html)


1) Clone this repo, i.e.: `git clone https://github.com/diegomics/jATG.git`

2) Edit the file `0.general_variables.cnf` with the respective paths, values and parameters.

3) Install needed software with: `bash install_jATG_dependencies.sh`

4) Enter each folder to configure and run the particular analysis



---

In the end, the pipeline produces the following output structure:
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
                ├── 4.het_roh
                │   └── ..
                └── 5.psmc
                    └── ..

```
