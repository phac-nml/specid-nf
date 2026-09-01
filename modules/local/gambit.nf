
process GAMBIT {
    tag "$meta.id"
    label "process_medium" // Setting as low for now as intended use is the 8GB database (for now)
    container "${workflow.containerEngine == 'singularity' || workflow.containerEngine == 'apptainer' ? task.ext.parameters.get('singularity') : task.ext.parameters.get('docker')}"

    input:
    tuple val(meta), path(contigs)
    path db

    output:
    tuple val(meta), path("*.csv"), emit: gambit_results
    path 'versions.yml', emit: versions


    script:
    """
    gambit --db $db query -c $task.cpus --no-progress -f csv -o ${meta.id}.csv $contigs
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        gambit: \$(echo \$(gambit --version 2>&1) | sed 's/gambit, version //')
    END_VERSIONS
    """

}
