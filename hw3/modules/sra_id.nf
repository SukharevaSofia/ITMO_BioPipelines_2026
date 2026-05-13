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

