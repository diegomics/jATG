import argparse
import csv
from Bio import Entrez

def genes_exist_for_species(species, email):
    Entrez.email = email
    species_formatted = species.replace('_', ' ')
    query = f"{species_formatted}[Orgn] AND (X[Chromosome] OR Y[Chromosome] OR Z[Chromosome] OR W[Chromosome])"

    handle = Entrez.esearch(db="gene", term=query)
    record = Entrez.read(handle)
    handle.close()

    return bool(record["IdList"])


def get_genes_linked_to_sex_chromosomes(species, email):
    Entrez.email = email
    species_formatted = species.replace('_', ' ')
    query = f"{species_formatted}[Orgn] AND (X[Chromosome] OR Y[Chromosome] OR Z[Chromosome] OR W[Chromosome])"

    handle = Entrez.esearch(db="gene", term=query)
    record = Entrez.read(handle)
    handle.close()

    gene_ids = record["IdList"]
    genes = []
    fasta_sequences = []

    for gene_id in gene_ids:
        try:
            handle = Entrez.efetch(db="gene", id=str(gene_id), rettype="xml")
            gene_record = Entrez.read(handle)
            handle.close()

            gene_info = gene_record[0]['Entrezgene_gene']['Gene-ref']
            gene_loc = "Chromosome location not found"

            for commentary in gene_record[0].get('Entrezgene_locus', []):
                label = commentary.get('Gene-commentary_label', '')
                if 'Chromosome' in label:
                    gene_loc = label
                    break

            gene_dict = {
                'Symbol': gene_info['Gene-ref_locus'],
                'Name': gene_info['Gene-ref_desc'],
                'Location': gene_loc
            }
            genes.append(gene_dict)

            link_handle = Entrez.elink(dbfrom="gene", db="protein", id=str(gene_id))
            link_record = Entrez.read(link_handle)
            link_handle.close()

            for link in link_record[0]["LinkSetDb"][0]["Link"]:
                prot_id = link["Id"]

                try:
                    seq_handle = Entrez.efetch(db="protein", id=prot_id, rettype="fasta", retmode="text")
                    fasta_sequence = seq_handle.read()
                    seq_handle.close()
                    fasta_sequences.append(fasta_sequence)
                except Exception as e:
                    print(f"Error fetching protein sequence for ID {prot_id}: {e}")
        except Exception as e:
            print(f"Error processing gene ID {gene_id}: {e}")

    if not genes:
        print("Nothing found for the given species name. Try running 2.reference_check.sh with another name")
        return None, None
    else:
        return genes, fasta_sequences


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("email", help="Email for NCBI tracking")
    parser.add_argument("species", help="Species name with underscores instead of spaces, e.g. Gallus_gallus")
    parser.add_argument("--ask", action="store_true", help="Check if information exists for the given species name")
    parser.add_argument("--get", action="store_true", help="Get genes and sequences linked to sex chromosomes for the species")
    args = parser.parse_args()

    if args.ask:
        exists = genes_exist_for_species(args.species, args.email)
        if exists:
            print(f"Genes linked to sex chromosomes found for species: {args.species.replace('_', ' ')}. Continue with 3.Run_stats.sh")
        else:
            print(f"No genes linked to sex chromosomes found for species: {args.species.replace('_', ' ')}. Maybe try another name?")
    elif args.get:
        genes, fasta_sequences = get_genes_linked_to_sex_chromosomes(args.species, args.email)
        
        if genes:
            with open(f"temp_{args.species}_sexChrGenes.tsv", 'w', newline='') as f:
                writer = csv.DictWriter(f, fieldnames=['Symbol', 'Name', 'Location'], delimiter='\t')
                writer.writeheader()
                for gene in genes:
                    writer.writerow(gene)

            with open(f"{args.species}_sexChrSeqs.faa", 'w') as f:
                for fasta_sequence in fasta_sequences:
                    f.write(fasta_sequence + "\n")

if __name__ == "__main__":
    main()
