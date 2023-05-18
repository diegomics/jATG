import ssl

ssl._create_default_https_context = ssl._create_unverified_context

import argparse
from Bio import Entrez

def get_genes_linked_to_sex_chromosomes(species, email):
    Entrez.email = email  # Always tell NCBI who you are
    species_formatted = species.replace('_', ' ')
    query = f"{species_formatted}[Orgn] AND (X[Chromosome] OR Y[Chromosome] OR Z[Chromosome] OR W[Chromosome])"

    handle = Entrez.esearch(db="gene", term=query)
    record = Entrez.read(handle)
    handle.close()

    gene_ids = record["IdList"]
    genes = []
    fasta_sequences = []

    for gene_id in gene_ids:
        handle = Entrez.efetch(db="gene", id=gene_id, rettype="xml")
        gene_record = Entrez.read(handle)
        handle.close()
        gene_info = gene_record[0]['Entrezgene_gene']['Gene-ref']
        gene_output = f"{gene_info.get('Gene-ref_locus', 'N/A')}\nInterim Symbol: {gene_info.get('Gene-ref_locus', 'N/A')} and Name: {gene_info.get('Gene-ref_desc', 'N/A')} [{species_formatted}]"
        genes.append(gene_output)

        # Link the gene ID to corresponding protein IDs
        link_handle = Entrez.elink(dbfrom="gene", db="protein", id=gene_id)
        link_record = Entrez.read(link_handle)
        link_handle.close()

        # Fetch the nucleotide sequence for each linked protein ID
        for link in link_record[0]["LinkSetDb"][0]["Link"]:
            prot_id = link["Id"]
            seq_handle = Entrez.efetch(db="protein", id=prot_id, rettype="fasta", retmode="text")
            fasta_sequence = seq_handle.read()
            seq_handle.close()
            fasta_sequences.append(fasta_sequence)

    if not genes:
        print("Nothing found for the given species name. Maybe try another name?")
        return None, None
    else:
        return genes, fasta_sequences

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("email", help="Email for NCBI tracking")
    parser.add_argument("species", help="Species name with underscores instead of spaces, e.g. Gallus_gallus")
    args = parser.parse_args()

    genes, fasta_sequences = get_genes_linked_to_sex_chromosomes(args.species, args.email)

    if genes:
        with open(f"{args.species}_sexChrGenes.txt", 'w') as f:
            for gene in genes:
                f.write(gene + "\n\n")

        with open(f"{args.species}_sexChrSeqs.faa", 'w') as f:
            for fasta_sequence in fasta_sequences:
                f.write(fasta_sequence + "\n")

if __name__ == "__main__":
    main()

