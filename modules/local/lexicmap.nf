
process LEXICMAP {
    tag "$meta.id"
    label "process_medium"
    container "${workflow.containerEngine == 'singularity' || workflow.containerEngine == 'apptainer' ? task.ext.parameters.get('singularity') : task.ext.parameters.get('docker')}"

    input:
    tuple val(meta), path(contigs)
    path db

    output:
    tuple val(meta), path(output_name), emit: lexicmap_outputs
    path 'versions.yml', emit: versions

    script:
    output_name = "${meta.id}${params.lexicmap.output_suffix}"
    """
    lexicmap search --align-min-match-pident ${params.lexicmap.align_min_match_pident} \\
    --min-qcov-per-hsp ${params.lexicmap.min_qcov_per_hsp} \\
    --min-qcov-per-genome ${params.lexicmap.min_qcov_per_genome} \\
    --align-min-match-len ${params.lexicmap.align_min_match_len} \\
    --top-n-genomes ${params.lexicmap.top_n_genomes} \\
    -d ${db} ${contigs} -o ${output_name} -j $task.cpus
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        lexicmap: \$(echo \$(lexicmap version 2>&1) | sed 's/LexicMap //')
    END_VERSIONS
    """
}
