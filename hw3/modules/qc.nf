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
