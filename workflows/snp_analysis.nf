#!/usr/bin/env nextflow

include { setInputChannel } from '../modules/helper_functions.nf'
include { MASH_REFERENCE 
          MASH_DIST 
          NEAREST_REF } from '../modules/mash.nf'
include { SNIPPY 
          SNIPPY_CORE } from '../modules/snippy.nf'
include { SNP_DISTS } from '../modules/snp_dists.nf'
include { SNPEFF } from '../modules/snpeff.nf'
include { SNPSIFT } from '../modules/snpsift.nf'

workflow SNP_ANALYSIS {

    take:
    sample_ch

    main:
    ref_fasta_ch = Channel.fromPath("${params.refs}/*.fna", checkIfExists: true).collect()
    ref_gbff_ch = Channel.fromPath("${params.refs}/*.gbff", checkIfExists: true).collect()

    MASH_REFERENCE(ref_fasta_ch)

    MASH_DIST(sample_ch, MASH_REFERENCE.out.sketch)
    | NEAREST_REF
    
    ref_map = ref_gbff_ch.map { refs -> [refs].flatten().collectEntries { [(it.getBaseName()): it] } }

    NEAREST_REF.out.nearest_ref
        .combine(ref_map)
        .map { id, reads, ref_name, refs -> tuple(id, reads, refs[ref_name.trim().replaceAll(/\.fna$/, '')]) }
        .set { snippy_in_ch }
    
    SNIPPY(snippy_in_ch)

    snippy_core_ch = SNIPPY.out.snippy_out_ch
        .groupTuple(by: 2)
        .map { snp_dir, refs, refName -> tuple(snp_dir, refs[0], refName) }

    SNIPPY_CORE(snippy_core_ch)
    
    SNP_DISTS(SNIPPY_CORE.out.aln)
    SNPEFF(SNIPPY_CORE.out.vcf)

    SNPSIFT(SNPEFF.out.vcf)

}