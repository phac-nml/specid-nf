
process KRAKEN2{
    tag "$meta.id"
    label "process_low" // Setting as low for now as intended use is the 8GB database (for now)
    container "${workflow.containerEngine == 'singularity' || workflow.containerEngine == 'apptainer' ? task.ext.parameters.get('singularity') : task.ext.parameters.get('docker')}"


    input:
    tuple val(meta), path(contigs)
    path db

    output:
    tuple val(meta), path("*.${params.kraken2.classified_suffix}*"), optional: true, emit: classified_contigs
    tuple val(meta), path("*.${params.kraken2.unclassified_suffix}*"), optional: true, emit: unclassified_contigs
    tuple val(meta), path("*.${params.kraken2.output_suffix}.txt"), emit: kraken_output
    tuple val(meta), path("*${params.kraken2.report_suffix}.txt"), emit: report
    path "versions.yml", emit: versions

    script:
    def args = task.ext.args ?: ""
    def run_arg = db.name.endsWith(".gz") ? "--gzip-compressed $contigs" : "$contigs"
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    kraken2 --db $db --memory-mapping --threads $task.cpus --output ${prefix}.${params.kraken2.output_suffix}.txt --report ${prefix}.kraken2.${params.kraken2.report_suffix}.txt --classified-out ${meta.id}.${params.kraken2.classified_suffix}.fasta --unclassified-out ${meta.id}.${params.kraken2.unclassified_suffix}.fasta $args $run_arg
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        kraken2: \$(echo \$(kraken2 --version 2>&1) | sed 's/^.*Kraken version //; s/ .*\$//')
    END_VERSIONS
    """
    }
