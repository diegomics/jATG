# Genome-wide GC and Telomeric Regions Identification
🧬📈🧬🔚🧬📈🧬🔚🧬📈🧬🔚🧬📈🧬🔚🧬📈🧬🔚🧬📈🧬🔚🧬📈🧬🔚🧬📈

The GC content may be correlated with underlying rates of recombination through GC-biased gene conversion.
Telo blabla

## Output:
```
[OUT_DIR]
└── jATG
    └── [SPECIES_NAME]
        └── [ASSEMBLY_ID]
            ├── 1.stats
                └── ..
            ├── 2.masking
                            └── ..
            └── 3.gc_telo
                ├── <..>     # 
                └── ..

```

### How to run?

Requirements:
* [Conda](https://docs.conda.io)


1) Edit `1.gc_telo_variables.cnf` file with the respective paths, values and parameters.

2) Install needed software with: `bash 2.install_gc_telo_dependencies.sh`

3) Run the masking pipeline in _Slurm_ with: `bash 3.run_GC_Telo.sh`
