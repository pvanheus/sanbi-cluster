#!/bin/sh

. /etc/profile.d/module.sh

module add velvet

SHORTREAD_DIR=/cip0/research/projects/cluster_demo/shortreads
/usr/bin/time -v velveth Assem 31 -shortPaired -fastq -separate $SHORTREAD_DIR/full_forward.fastq $SHORTREAD_DIR/full_reverse.fastq
/usr/bin/time -v velvetg Assem
