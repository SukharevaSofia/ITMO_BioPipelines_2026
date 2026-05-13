process INDEX_REFERENCE {
    conda 'bioconda::samtools=1.19'

    input:
        path reference

    output:
        tuple path(reference), path("${reference}.fai")

    script:
        """
        samtools faidx ${reference}
        """
}
