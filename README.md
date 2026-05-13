# Homework 3

## Prerequisite

before working with the pipeline hw3, please run:
```sh
wget --output-document=ggal_ref.fna.gz 'https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/002/315/GCF_000002315.6_GRCg6a/GCF_000002315.6_GRCg6a_genomic.fna.gz'
gunzip ggal_ref.fna.gz
```

## Running

### Local

to run the pipeline with profile local:
```sh
nextflow run ./hw3/main.nf --local_file ./hw3/ --reference hw3/ggal_ref.fna --results_dir ./results_local -profile local -with-conda 
```

### Cluster
to run the pipeline with profile cluster:
```sh
nextflow run ./hw3/main.nf --local_file ./hw3/ --reference hw3/ggal_ref.fna --results_dir ./results_cluster -profile cluster
```

### Container
to run the pipeline with profile container:
```sh
nextflow run ./hw3/main.nf --local_file ./hw3/ --reference hw3/ggal_ref.fna --results_dir ./results_docker -profile container -with-docker sssofya/hw3-pipeline
```

## Docker info
docker hub location: sssofya/hw3-pipeline
