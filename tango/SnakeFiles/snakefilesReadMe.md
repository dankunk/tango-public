# SnakeFiles README

This directory contains the core Snakemake workflow files for **Tango**.

## What’s in this folder

- `Snakefile`  
  The main Snakemake workflow defining all rules (fastp → HISAT2/samtools → StringTie → gffcompare/gffread → BUSCO → Salmon, etc.).

- `tango_Snakemake_config.yaml`  
  User-editable configuration file. This is where you set:
  - `rawdata_dir` (where your FASTQs live)
  - `output_dir` (**recommended: scratch**)
  - reference paths (`fasta`, `gff`, `trans_fasta`)
  - other pipeline settings (e.g., `hisat2_index_extension`)

- `ClusterProfiles/slurm/`  
  Snakemake SLURM profile used for running Tango on HPC. Edit this to match your cluster
  (partition/account/qos/runtime defaults, memory, cpus-per-task, etc.).

- `execute_snakemake.sbatch`  
  Example “master” SLURM job script that launches Snakemake using the SLURM profile. This
  submits downstream jobs for each rule according to the profile/resource settings.

## Running from this directory

From `tango/SnakeFiles/`:

### Local run
```bash
snakemake -j 8 -p
```
## SLURM run (recommended on HPC)

```bash
snakemake --workflow-profile ClusterProfiles/slurm -p
```
Or submit the provided master scheduler script:
```
sbatch execute_snakemake.sbatch
```
---

## Dry-run (test mode)

Dry-run to preview what would execute without running anything:

```snakemake -n -p```

With SLURM profile enabled:

```snakemake --workflow-profile ClusterProfiles/slurm -n -p```

## Workflow visualization (DAG)

You can visualize the workflow graph (requires graphviz / dot):

```snakemake --dag | dot -Tpng > tango_dag.png```
```snakemake --rulegraph | dot -Tpng > tango_rulegraph.png```

## Notes

- Outputs are written to the output_dir set in tango_Snakemake_config.yaml.

- output_dir does not need to be inside the Tango repository; using scratch is strongly recommended for large datasets.

- Many rules request resources (threads/memory/time). When running on SLURM, job resources are controlled by the SLURM profile and rule definitions.

### Snakemake documentation

Snakemake docs: https://snakemake.readthedocs.io/

CLI reference: https://snakemake.readthedocs.io/en/stable/executing/cli.html
