## Output directory and where files are saved

All Tango outputs are written under the directory specified by `output_dir` in:

- `tango/SnakeFiles/tango_Snakemake_config.yaml`

**Important:** `output_dir` does **not** need to be inside the Tango repository. For HPC usage, it is strongly recommended to point `output_dir` to **scratch space** (e.g., `/scratch/<user>/tango_run1/`) because the workflow can generate very large intermediate and result files (trimmed FASTQs, BAMs, Salmon indices, BUSCO outputs, etc.).

Example:

```yaml
# tango/SnakeFiles/tango_Snakemake_config.yaml
output_dir: /scratch/<user>/tango_Output_myproject/
rawdata_dir: /scratch/<user>/raw_reads/
```

### What gets created inside `output_dir`

Tango will create a set of subfolders under `output_dir` as it runs, for example:

- `fastp/` — trimmed FASTQs + fastp QC reports (HTML/JSON)
- `hisat2_index/` — HISAT2 genome index and splice/exon site files
- `hisat2_samtools/` — sorted BAMs, BAI indices, and BigWigs
- `stringtie/` — per-sample assemblies, merged assembly outputs, and prepDE count matrices
- `gff_compare/` — gffcompare outputs (class codes, tracking, summaries)
- `busco/` — BUSCO QC runs (denovo transcriptome, and optional reference transcriptome)
- `salmon/` — Salmon indices and per-sample quantification outputs (`ref_quant/`, `denovo_quant/`)

---

### Notes on disk usage

Tango can be disk-intensive, especially for large studies (100–200+ samples). In typical runs:

- `fastp/` (trimmed FASTQs) and `hisat2_samtools/` (BAMs) are often the largest folders.
- Using scratch for `output_dir` helps avoid quota issues and improves I/O performance on most clusters.
