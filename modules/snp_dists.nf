process SNP_DISTS {
    // https://github.com/tseemann/snp-dists
    cpus 1
    tag "${refName}"

    container "quay.io/biocontainers/snp-dists:1.2.0--h577a1d6_0"

    publishDir "${params.outdir}"

    input:
    tuple val(refName), path(core_aln)

    output:
    path("${refName}_dists.tsv"), emit: snp_dists
    tuple val('snpdists'), eval('snp-dists -v | sed "s/snp-dists //;"'), topic: versions

    script:
    """
    snp-dists ${core_aln} > ${refName}_dists.tsv
    """

    stub:
    """
    touch ${refName}_dists.tsv
    """
}