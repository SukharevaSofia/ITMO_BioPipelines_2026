process MAP_READS {
    conda 'bioconda::bwa=0.7.17 bioconda::samtools=1.19'
    
    input:
        tuple val(sample_id), path(reads)
        path reference
    
    output:
        tuple val(sample_id), path("${sample_id}.sorted.bam"), path("${sample_id}.sorted.bam.bai")
    
    script:
        """
        if [ ! -f ${reference}.bwt ]; then
            bwa index ${reference}
        fi
        bwa mem -t ${task.cpus} ${reference} ${reads[0]} ${reads[1]} | \
            samtools view -bS - | \
            samtools sort -o ${sample_id}.sorted.bam -
        samtools index ${sample_id}.sorted.bam
        """
}
