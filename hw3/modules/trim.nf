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
