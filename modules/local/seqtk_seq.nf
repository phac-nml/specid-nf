
process SEQTK_SEQ{
    tag "$meta.id"
    label "process_low" // Setting as low for now as intended use is the 8GB database (for now)
    container "${workflow.containerEngine == 'singularity' || workflow.containerEngine == 'apptainer' ? task.ext.parameters.get('singularity') : task.ext.parameters.get('docker')}"
    
    input:
    tuple val(meta), path(contigs)

    output:
    tuple val(meta), path(fastq), emit: fastq
    path "versions.yml", emit: versions

    script:
    fastq = "${meta.id}.fastq"
    """
    CONTIG=$contigs
    if file --mime-type $contigs | grep -q 'application/x-gzip'; then
        FILES_NEW_NAME=unzipped.contigs.fasta 
        zcat $contigs > \$FILES_NEW_NAME
        CONTIG=\$FILES_NEW_NAME
    fi 
    seqtk seq -F 'I' \$CONTIG > $fastq 
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        seqtk: \$(seqtk 2>&1 | grep 'Version:' | sed 's/Version: //')
    END_VERSIONS
    """

    }
