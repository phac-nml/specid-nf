
process CONIFER {
    tag "$meta.id"
    label "process_low" // Setting as low for now as intended use is the 8GB database (for now)
    container "${workflow.containerEngine == 'singularity' || workflow.containerEngine == 'apptainer' ? task.ext.parameters.get('singularity') : task.ext.parameters.get('docker')}"


    input:
    tuple val(meta), path(kraken2_output)
    path taxo_k2d

    output:
    tuple val(meta), path(output), emit: confier_results
    path "versions.yml", emit: versions

    script:
    output = "${meta.id}.txt"
    """
    conifer --both_scores -i ${kraken2_output} -d ${taxo_k2d} > ${output}
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        conifer: \$(echo \$(conifer --version 2>&1) | sed 's/Conifer //')
    END_VERSIONS
    """
}
