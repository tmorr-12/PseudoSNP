#!/usr/bin/env nextflow

include { printHelp 
          setInputChannel
          validateRefs
          validateParams
          validateManifest } from './modules/helper_functions.nf'

include { SNP_ANALYSIS } from './workflows/snp_analysis.nf'

workflow {

    if (params.help) {
        printHelp()
        exit 0
    }

    validateParams()
    validateRefs()
    validateManifest()
    
    input_ch = setInputChannel()

    SNP_ANALYSIS(input_ch) 

    channel.topic('versions')
        .unique()
        .map { tool, version -> "${tool}\t${version}" }
        .collectFile(
            storeDir: "${params.outdir}/pipeline-info",
            name: 'software_versions.tsv',
            newLine: true,
            sort: true
        )

}