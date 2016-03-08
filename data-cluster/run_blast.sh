#!/bin/sh

. /etc/profile.d/module.sh
module add blastplus

QUERY=/cip0/research/projects/cluster_demo/sample.fa
BLAST_OPTS='6 qseqid sseqid evalue bitscore sgi sacc staxids sscinames scomnames stitle'
BLASTDB=/cip0/db/ncbi/nt/default
export BLASTDB
blastn -db /cip0/db/ncbi/nt/default/nt -max_target_seqs 1 -outfmt $BLAST_OPTS \
  -evalue "1e-30" -query $QUERY -out blast_results.txt
