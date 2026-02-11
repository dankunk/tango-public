#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
TransrateSubModule_py2.py

Run TransRate in either sequence-only or read-mapping mode under Python 2.7.

Usage:
  python TransrateSubModule_py2.py \
    -i <assembly.fa> \
    [-r <reads_root_dir>] \
    [-o <output_dir>] \
    [-t <threads>]
"""

import argparse
import os
import subprocess
import sys

def main():
    parser = argparse.ArgumentParser(
        description="Run TransRate (sequence- or read-mapping mode)"
    )
    parser.add_argument("-i", "--assembly", required=True,
                        help="Path to transcriptome assembly FASTA")
    parser.add_argument("-r", "--reads-dir",
                        help="Root dir with fastp subdirs containing *_trim1.fq.gz and *_trim2.fq.gz")
    parser.add_argument("-o", "--output-dir", default="transrate_results",
                        help="Directory for TransRate output")
    parser.add_argument("-t", "--threads", type=int, default=4,
                        help="Number of threads for TransRate")
    args = parser.parse_args()

    out_dir = args.output_dir
    log_dir = os.path.join(out_dir, "logs")
    if not os.path.isdir(log_dir):
        os.makedirs(log_dir)
    log_file = os.path.join(log_dir, "run_transrate.log")

    # Base TransRate command
    cmd = [
        "transrate",
        "--assembly", args.assembly,
        "--output", out_dir,
        "--threads", str(args.threads),
        "--loglevel", "debug"
    ]

    # If reads-dir is provided, collect paired fastq files
    if args.reads_dir:
        left_reads = []
        right_reads = []
        for root, _, files in os.walk(args.reads_dir):
            for fname in files:
                if fname.endswith("_trim1.fq.gz"):
                    left_reads.append(os.path.join(root, fname))
                elif fname.endswith("_trim2.fq.gz"):
                    right_reads.append(os.path.join(root, fname))
        left_reads.sort()
        right_reads.sort()

        if not left_reads or not right_reads:
            sys.stderr.write(
                "ERROR: No paired reads found under {}\n".format(args.reads_dir)
            )
            sys.exit(1)

        if len(left_reads) != len(right_reads):
            sys.stderr.write(
                "WARNING: {} left vs {} right files\n".\
                format(len(left_reads), len(right_reads))
            )

        cmd.extend([
            "--left", ",".join(left_reads),
            "--right", ",".join(right_reads)
        ])

    # Run TransRate and capture output
    with open(log_file, "w") as lf:
        try:
            # Python 2.7: use check_call instead of run()
            subprocess.check_call(cmd, stdout=lf, stderr=subprocess.STDOUT)
        except subprocess.CalledProcessError as e:
            sys.stderr.write(
                "ERROR: TransRate failed (see log: {})\n".format(log_file)
            )
            sys.exit(e.returncode)

    sys.stdout.write(
        "TransRate completed successfully. Results in {}\n".format(out_dir)
    )

if __name__ == "__main__":
    main()
