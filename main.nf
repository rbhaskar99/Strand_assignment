#!/usr/bin/env nextflow
/*
*  RNA-Seq Contaminant Detection Pipeline
*/

// Parameters
params.reads = "$projectDir/data/*_{1,2}.fastq.gz"
params.globaldb = "$projectDir/db/microbial.kc.fasta.gz"
params.localkmer = "$projectDir/db/Prevotella_nigrescens_F0103_uid43119.kmer.fasta"
params.localgenome = "$projectDir/db/Prevotella_nigrescens_F0103_uid43119.fasta"
params.outdir = "results"
params.downsampled_reads = "downsampled_reads"
params.logs = "logs"

// Downsampling 1 Million reads from R1 and R2 of each sample with seqtk
process DOWNSAMPLE {
    input:
    tuple val(sample_id), path(reads)

    output:
    tuple val(sample_id), path("downsampled_${sample_id}_R1.fastq.gz"), path("downsampled_${sample_id}_R2.fastq.gz")

    script:
    """
    seqtk sample -s100 ${reads[0]} 1000000 > downsampled_${sample_id}_R1.fastq.gz
    seqtk sample -s100 ${reads[1]} 1000000 > downsampled_${sample_id}_R2.fastq.gz
    """
}

// Performing Global contaminant detection with fastv against entire bacterial +
// viral contaminant k-mer database.
process GLOBAL_CONTAMINAT {
    input:
        tuple val(sample_id), path(fastq1), path(fastq2) // Tuple of sample ID, FASTQ1, and FASTQ2 files // Global database for contamination analysis
    
    output:
        path "global_report_${sample_id}.html"

    script:
        """
        fastv   -i ${fastq1} \
                -I ${fastq2} \
                -c ${params.globaldb} \
                -o global_${sample_id}_report \
                -j global_${sample_id}_report.json \
                --out2 /dev/null 
        """
}

// Performing local contaminant detection with fastv against the k-mer and genome fasta
//files of P. nigrescens.
process LOCAL_CONTAMINAT {
    input:
    tuple val(sample_id), path(fastq1), path(fastq2)

    output:
    path("local_${sample_id}_report.html")

    script:
    """
    fastv   -i $fastq1 \
            -I $fastq2 \
            -c ${params.localkmer} \
            -g ${params.localgenome} \
            -o local_${sample_id}_report \
            -j local_${sample_id}_report.json \
            --out2  /dev/null 
    """
}

// Workflow 
workflow {
    Channel
    .fromFilePairs(params.reads)
    .set { read_pairs }

    read_pairs
    | DOWNSAMPLE
    | GLOBAL_CONTAMINAT
    | LOCAL_CONTAMINAT
}
