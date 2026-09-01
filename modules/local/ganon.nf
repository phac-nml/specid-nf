
process GANON {
    tag "$meta.id"
    label "process_low" // Setting as low for now as intended use is the 8GB database (for now)
    container "${workflow.containerEngine == 'singularity' || workflow.containerEngine == 'apptainer' ? task.ext.parameters.get('singularity') : task.ext.parameters.get('docker')}"


    input:
    tuple val(meta), path(fasta)
    path db // db is specified so it is staged in the directory
    val prefix

    output:
    tuple val(meta), path("${meta.id}${params.ganon.rep_output_suffix}"), emit: repersentative
    tuple val(meta), path("${meta.id}${params.ganon.tax_ranks_suffix}"), emit: taxonomic_ranks
    tuple val(meta), path("*.log"), emit: logs
    path "versions.yml", emit: versions

    script:
    """
    ganon classify --db-prefix ${db}/${prefix} \\
    --threads $task.cpus --multiple-matches lca --output-all \\
    --output-prefix $meta.id \\
    --rel-cutoff ${params.ganon.rel_cutoff} \\
    --rel-filter ${params.ganon.rel_filter} \\
    --report-type ${params.ganon.report_type} \\
    --min-count ${params.ganon.min_count} \\
    --single-reads $fasta 2>&1 | tee ${meta.id}.log
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        ganon: \$(echo \$(ganon -v 2>&1) | sed 's/version: ganon //')
    END_VERSIONS
    """
    }
