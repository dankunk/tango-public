#!/usr/bin/env bash
# ------------------------------------------------------------------
#  filterClassCodes.sh  <stringtiecompare.tmap>  [ids_to_remove.txt]
#
#  A transcript is marked for removal if
#     • its gffcompare class‑code is in BAD_CODES  (default u,x,y,s)
#       (override on the command line:  BAD_CODES="u,x,y,s,k" )
#     • OR it has only 1 exon (num_exons column in .tmap)
#
#  Output: one qry_id per line  ➜  feed to  gffread -K
#
#  Example workflow
#     bash filterClassCodes.sh stringtiecompare.tmap bad_ids.txt
#     gffread -T stringtie_merged.gtf -K bad_ids.txt \
#             -o stringtie_merged.filtered.gtf
# ------------------------------------------------------------------
set -euo pipefail

[[ $# -lt 1 ]] && {
    echo "Usage: $0  stringtiecompare.tmap  [ids_to_remove.txt]" >&2
    exit 1
}

tmap=$1
out=${2:-ids_to_remove.txt}
BAD_CODES=${BAD_CODES:-"u,x,p,s"}          # comma‑separated list

awk -F'\t' -v bad="$BAD_CODES" -v OUT="$out" '
BEGIN{
    # turn comma‐separated BAD_CODES into a hash table
    n = split(bad, arr, /,/)
    for (i = 1; i <= n; i++) badcode[arr[i]] = 1
    hdr = 1           # first line is header
}
hdr { hdr = 0; next } # skip header

{
    code   = $3        # class_code
    exons  = $6 + 0    # num_exons
    tid    = $5        # qry_id

    if ((code in badcode) || (exons == 1))
        print tid >> OUT
}
END{
    print "Wrote " NR-1 " transcript IDs to " OUT > "/dev/stderr"
}
' "$tmap"
