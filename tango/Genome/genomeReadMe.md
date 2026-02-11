## Genome directory (optional)

The `tango/Genome/` directory is an **optional** place to store reference genome resources used by the pipeline, such as:

- genome FASTA (e.g., `.fa`, `.fasta`)
- annotation GFF/GFF3 (e.g., `.gff`, `.gff3`)
- (optional) reference transcriptome FASTA for Salmon/BUSCO (e.g., `.fa`, `.fasta`)

**Note:** Tango does not require these files to live inside `tango/Genome/`. You can keep genomes/annotations anywhere (including shared lab storage or scratch), and point to them in `tango/SnakeFiles/tango_Snakemake_config.yaml` via:

- `fasta: /path/to/genome.fa`
- `gff: /path/to/annotation.gff3`
- `trans_fasta: /path/to/transcriptome.fa` (optional but recommended if available)

On HPC systems, it’s common to keep reference files in a stable shared location (project space) and write large, run-specific outputs to scratch via `output_dir`.
