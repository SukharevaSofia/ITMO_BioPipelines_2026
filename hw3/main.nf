#!/usr/bin/env nextflow

include {QC_ON_READS as first_qc; QC_ON_READS as trimmed_qc} from "./modules/qc.nf"
include {TRIMMING} from "./modules/trim.nf"
include {DOWNLOAD_BY_ID} from "./modules/sra_id.nf"
include {MAP_READS} from "./modules/mapping.nf"
include {INDEX_REFERENCE} from "./modules/indexing.nf"

include { BCFTOOLS_MPILEUP } from './modules/nf-core/bcftools/mpileup/main'
include { BCFTOOLS_CALL } from './modules/nf-core/bcftools/call/main'

workflow {
  if (params.sra_id) {
    DOWNLOAD_BY_ID(params.sra_id)
    input_reads = DOWNLOAD_BY_ID.out
  } else if (params.local_file) {
    input_reads = Channel.fromFilePairs("${params.local_file}/*_{1,2}.fq", checkIfExists: true)
  } else {
    error "must have --sra_id or --local_file."
  }

  initial_qc_result = first_qc('initial', input_reads)
  trimmed_reads = TRIMMING(input_reads)
  trimmed_qc_result = trimmed_qc('trimmed', trimmed_reads)

  ref_fasta = file(params.reference, checkIfExists: true)
  ref_and_index = INDEX_REFERENCE(ref_fasta) // (3) Creates [ref.fa, ref.fa.fai]

  bam_ch = MAP_READS(trimmed_reads, ref_fasta)

  bam_for_mpileup = bam_ch.map { sample_id, bam, bai ->
      [ [id: sample_id], bam, [], [] ]
  }

  ref_with_meta = ref_and_index.map { fasta, fai -> 
      [ [id: 'reference'], fasta, fai ] 
  }
  
  BCFTOOLS_MPILEUP(bam_for_mpileup, ref_with_meta, params.save_mpileup)

}

