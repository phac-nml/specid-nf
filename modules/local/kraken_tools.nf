

process KRAKEN_TOOLS {
    tag "$meta.id"
    label "process_low" // Setting as low for now as intended use is the 8GB database (for now)
    container "${workflow.containerEngine == 'singularity' || workflow.containerEngine == 'apptainer' ? task.ext.parameters.get('singularity') : task.ext.parameters.get('docker')}"
    input:
    tuple val(meta), path(kreport)

    output:
    tuple val(meta), path(krona_file), emit: krona_text
    path 'versions.yml', emit: versions

    script:
    krona_file = "${meta.id}.krona.txt"
    def args = task.ext.args ?: ''
    """
    kreport2krona.py -r ${kreport} -o ${krona_file} ${args}
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        krakentools: ${params.kraken_tools.version}
    END_VERSIONS
    """

}
