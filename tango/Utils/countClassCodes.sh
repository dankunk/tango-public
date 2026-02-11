#!/usr/bin/env bash
# ------------------------------------------------------------------
# countClassCodes.sh   <stringtiecompare.tmap> <annotated.gtf> [out.txt|-]
# ------------------------------------------------------------------
set -euo pipefail

if [[ $# -lt 2 ]]; then
    echo "Usage: $0  stringtiecompare.tmap  stringtiecompare.annotated.gtf  [out.txt|-]" >&2
    exit 1
fi

tmap=$1
gtf=$2
out=${3:-${tmap%.tmap}.qc_summary.txt}
[[ "$out" != "-" ]] && mkdir -p "$(dirname "$out")"

############################################################################
# 1. Pre-scan annotated GTF → exon-count + length for each transcript_id
############################################################################
tmp_info=$(mktemp)
awk '
  $3=="exon"{
      if (match($0,/transcript_id "([^"]+)"/,m)){
          id=m[1]
          ex[id]++
          ln[id]+=($5-$4+1)
      }
  }
  END{for (t in ex) printf "%s\t%d\t%d\n",t,ex[t],ln[t]}
' "$gtf" > "$tmp_info"

############################################################################
# 2. Main scan of the *.tmap (using your column order)
############################################################################
awk -F'\t' -v INFO="$tmp_info" -v OUT="$out" -v OFS='\t' '
BEGIN{
    # load per-transcript exon count & length
    while ((getline < INFO) > 0){
        ex[$1]=$2
        ln[$1]=$3
    }
    close(INFO)

    # seed all 14 gffcompare class codes
    split("= c j e i o p r u x y s k m n", codes, " ")
    for (i in codes){
        c = codes[i]
        counts[c]=0
        len_sum[c]=0
        n_len[c]=0
    }
}
NR==1 {next}                       # skip header
{
    total_tx++

    code = $3                 # class_code
    id   = $5                 # qry_id  -> unique transcript key
    nex  = $6+0               # num_exons from tmap
    L    = $10+0              # length column

    counts[code]++
    len_sum[code]+=L
    n_len[code]++

    (nex==1) ? single++ : multi++
}
END{
    dest = (OUT=="-") ? "/dev/stdout" : OUT

    print  "=== gffcompare QC summary ==="           >dest
    printf "Total transcripts : %d\n", total_tx       >>dest
    print  "--------------------------------"        >>dest
    print  "Class-code counts"                        >>dest
    print  "Code\tCount"                              >>dest
    PROCINFO["sorted_in"]="@val_num_desc"
    for (c in counts) printf "%s\t%d\n", c, counts[c] >>dest

    print  "\nMean transcript length by code (bp):"   >>dest
    print  "Code\tMeanLen"                            >>dest
    PROCINFO["sorted_in"]="@ind_str_asc"
    for (i in codes){
        c = codes[i]
        mean = (n_len[c] ? len_sum[c]/n_len[c] : 0)
        printf "%s\t%.1f\n", c, mean                  >>dest
    }

    printf "\nSingle-exon transcripts : %d\n", single >>dest
    printf "Multi-exon transcripts  : %d\n", multi    >>dest
}' "$tmap"

rm -f "$tmp_info"
echo "Finished QC on $tmap" >&2
[[ "$out" != "-" ]] && echo "Summary written to $out"
