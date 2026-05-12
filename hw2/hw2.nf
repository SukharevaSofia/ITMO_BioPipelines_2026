#!/usr/bin/env nextflow

params.sra_id = null
params.local_file = null
params.reference = null

process DOWNLOAD_BY_ID {
  conda 'bioconda::sra-tools=3.0.3'
  input:
  val sra_id

  output:
  tuple val(sra_id), path("${sra_id}_{1,2}.fastq")

  script:
    """
    fasterq-dump --threads ${task.cpus} --split-files $sra_id
    """
}

process QC_ON_READS {    
  conda 'bioconda::fastqc=0.12.1'
  input:
    val reads_type
    tuple val(reads_label), path(reads)
  output:
    path "${reads_type}_qc_report/", type:'folder'
  script:
    """
    mkdir ${reads_type}_qc_report
    fastqc -o ${reads_type}_qc_report/ $reads
    """

}

process TRIMMING {
  conda 'bioconda::trimmomatic=0.39'
  input:
    tuple val(reads_label), path(reads)
  output:
    tuple val(reads_label ), path("out_R?_p.fq.gz")
  script:
    """
    trimmomatic PE $reads \
        out_R1_p.fq.gz out_R1_u.fq.gz \
        out_R2_p.fq.gz out_R2_u.fq.gz \
ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 MINLEN:36
    """

}

workflow QC_FOR_TRIMMED{
  take:
    reads
  main:
    QC_ON_READS('trimmed', reads)
  emit:
    QC_ON_READS.out
}

workflow {

  if (params.sra_id){
    DOWNLOAD_BY_ID(params.sra_id)
    input_reads = DOWNLOAD_BY_ID.out
  }else if (params.local_file){
      input_reads = Channel.fromFilePairs("${params.local_file}/*_{1,2}.fq", checkIfExists: true)
  }else{
    error "must have --sra_id or --local_file."
  }

  initial_qc_result = QC_ON_READS('initial', input_reads)
  trimmed_reads = TRIMMING(input_reads)
  trimmed_qc_result = QC_FOR_TRIMMED(trimmed_reads)

}

