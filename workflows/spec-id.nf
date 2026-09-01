/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT MODULES / SUBWORKFLOWS / FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
include { paramsSummaryLog; validateParameters; samplesheetToList } from 'plugin/nf-schema'


include { KRAKEN2 } from "../modules/local/kraken2.nf"
include { CONIFER } from "../modules/local/conifer.nf"
include { KRAKEN_TOOLS } from "../modules/local/kraken_tools.nf"
include { KRONA } from "../modules/local/krona.nf"
include { SEQTK_SEQ } from "../modules/local/seqtk_seq.nf"
include { GANON } from "../modules/local/ganon.nf"

//include { methodsDescriptionText } from '../subworkflows/local/utils_nfcore_spec-id_pipeline'

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    RUN MAIN WORKFLOW
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow SPEC_ID {

    take:
    ch_samplesheet // channel: samplesheet read in from --input
    outdir

    main:
    validateParameters();
    log.info paramsSummaryLog(workflow);
    ch_input = channel.fromList(samplesheetToList(ch_samplesheet, "assets/schema_input.json"))

    if (!params.kraken2.db) { // manual check until nf-schema and the the schema_intput.json work together
        log.error ("No kraken2 database passed exiting.")
        exit 1, "ERROR: No kraken2 database passed."
    }

    def ch_versions = channel.empty()
    def kraken2_assigned = KRAKEN2(ch_input,  file(params.kraken2.db))
    ch_versions = ch_versions.mix(kraken2_assigned.versions)
    def conifer_outputs = CONIFER(kraken2_assigned.report, file([params.kraken2.db, params.conifer.required_file].join(File.separator)))
    ch_versions = ch_versions.mix(conifer_outputs.versions)

    // Prepare the krona text file
    def krona_text = KRAKEN_TOOLS(kraken2_assigned.report)
    ch_versions = ch_versions.mix(krona_text.versions)

    def krona_file = KRONA(krona_text.krona_text)
    ch_versions = ch_versions.mix(krona_file.versions)

    if(!(params.ganon.db && params.ganon.db_prefix)){
        log.error ("No Ganon database or database prefix passed exiting.")
        exit 1, "ERROR: Missing Ganon configuration database or database prefix."
    }
    def assemblies_as_reads = SEQTK_SEQ(ch_input)
    ch_versions = ch_versions.mix(assemblies_as_reads.versions)
    
    def db_prefix = Channel.value(params.ganon.db_prefix)
    def ganon_out = GANON(assemblies_as_reads.fastq, file(params.ganon.db), db_prefix)


 
}

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    THE END
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
