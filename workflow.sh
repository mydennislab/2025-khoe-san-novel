# vars
base_dir=/home/mhussien/khoe_san/2025-khoe-san-novel/
total_unmapped=${base_dir}/dani_unmapped_to_t2t.fa
filterd_less_than_1000=${base_dir}/dani_unmapped_to_t2t_less_than_1000.fa

seqkit seq -m 1000 -g $total_unmapped > $filterd_less_than_1000


# HPRC preparation (chm vg files)
cd $base_dir/hprc
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/pangenomes/freeze/freeze1/minigraph-cactus/hprc-v1.1-mc-chm13/hprc-v1.1-mc-chm13.d9.gbz
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/pangenomes/freeze/freeze1/minigraph-cactus/hprc-v1.1-mc-chm13/hprc-v1.1-mc-chm13.d9.dist
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/pangenomes/freeze/freeze1/minigraph-cactus/hprc-v1.1-mc-chm13/hprc-v1.1-mc-chm13.min
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/pangenomes/freeze/freeze1/minigraph-cactus/hprc-v1.1-mc-chm13/hprc-v1.1-mc-chm13.snarls
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/pangenomes/freeze/freeze1/minigraph-cactus/hprc-v1.1-mc-chm13/hprc-v1.1-mc-chm13.hapl


vg giraffe -Z hprc-v1.1-mc-chm13.d9.gbz -m hprc-v1.1-mc-chm13.min -d hprc-v1.1-mc-chm13.d9.dist -f $filterd_less_than_1000 -t 128 -p > $(basename $filterd_less_than_1000).gam 
vg giraffe -Z hprc-v1.1-mc-chm13.d9.gbz -m hprc-v1.1-mc-chm13.min -d hprc-v1.1-mc-chm13.d9.dist -o BAM -f $filterd_less_than_1000 -t 128 -p > $(basename $filterd_less_than_1000).bam

vg stats -a $(basename $filterd_less_than_1000).gam > $(basename $filterd_less_than_1000).gam.stats

vg pack -g $(basename $filterd_less_than_1000).gam  -Q 5 -o aln.pack

# yielded zero alignments

# -----------------------

