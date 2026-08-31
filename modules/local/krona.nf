
process KRONA {
    tag "$meta.id"
    label "process_low" // Setting as low for now as intended use is the 8GB database (for now)
    container "${workflow.containerEngine == 'singularity' || workflow.containerEngine == 'apptainer' ? task.ext.parameters.get('singularity') : task.ext.parameters.get('docker')}"

    input:
    tuple val(meta), path(krona_txt)

    output:
    tuple val(meta), path ('*.krona.html'), emit: html
    path "versions.yml",                    emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    ktImportText  \\
        $args \\
        -o ${prefix}.krona.html \\
        $krona_txt

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        krona: \$( echo \$(ktImportText 2>&1) | sed 's/^.*KronaTools //g; s/- ktImportText.*\$//g')
    END_VERSIONS
    """

    }
