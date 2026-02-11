#!/usr/bin/env bash
# --------------------------------------------------------------------
# single_exon_transcripts.sh   <stringtiecompare.tmap>  [out.tsv|-]
#
#   • Lists every transcript whose num_exons == 1
#   • Columns: qry_id  class_code  qry_gene_id  len  FPKM  TPM
#
#   If the 2nd argument is “-” the table is sent to stdout.
#   Otherwise it defaults to <tmap_basename>.single_exon.tsv.
# --------------------------------------------------------------------
set -euo pipefail

[[ $# -lt 1 ]] && { echo "Usage: $0  stringtiecompare.tmap  [out.tsv|-]" >&2; exit 1; }
tmap="$1"
out=${2:-${tmap%.tmap}.single_exon.tsv}

[[ "$out" != "-" ]] && mkdir -p "$(dirname "$out")"

awk -F'\t' -v OFS='\t' -v OUT="$out" '
NR==1 {                           # save header indices (1-based)
    # ref_gene_id ref_id class_code qry_gene_id qry_id num_exons FPKM TPM cov len ...
    hdr["class"]   = 3
    hdr["gene"]    = 4
    hdr["tx"]      = 5
    hdr["exons"]   = 6
    hdr["fpkm"]    = 7
    hdr["tpm"]     = 8
    hdr["len"]     = 10
    next
}
$hdr["exons"] == 1 {
    print  $hdr["tx"],  $hdr["class"], $hdr["gene"],
           $hdr["len"], $hdr["fpkm"],  $hdr["tpm"]   >> ((OUT=="-")?"/dev/stdout":OUT)
}
' "$tmap"

[[ "$out" != "-" ]] && {
  echo "Wrote single-exon table → $out  ( $(wc -l < "$out") lines )"
}