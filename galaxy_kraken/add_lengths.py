import matplotlib.pyplot as plt
from Bio import SeqIO
import pandas as pd

def plot_fasta_length_distribution(fasta_file):
    seq_to_length = {}    
    for record in SeqIO.parse(fasta_file, "fasta"):
        seq_to_length[record.id] = len(record.seq)
    
    return seq_to_length

# Usage example
lengths = plot_fasta_length_distribution('/share/dennislab/users/mhussien/khoe_san/2025-khoe-san-novel/chm13_analysis/contamination/sorted_unmapped_contigs.fa')

print(lengths)


kraken_report = pd.read_csv("/share/dennislab/users/mhussien/khoe_san/2025-khoe-san-novel/galaxy_kraken/Galaxy14-[Kraken-translate on data 10_ Translated classification].tabular", sep="\t", header=None)

# cols id, classification
kraken_report.columns = ["id", "classification"]
kraken_report["length"] = kraken_report["id"].map(lengths)
# make length second column
kraken_report = kraken_report[["id", "length", "classification"]]

# write to disk again
kraken_report.to_csv("/share/dennislab/users/mhussien/khoe_san/2025-khoe-san-novel/galaxy_kraken/bacteria_summary.tsv", sep="\t", index=False)