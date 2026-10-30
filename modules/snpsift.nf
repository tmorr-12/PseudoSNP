process SNPSIFT {
    // https://pcingola.github.io/SnpEff/snpsift/introduction/
    cpus 1
    tag "${refName}"

    container "quay.io/biocontainers/snpsift:5.4.0c--hdfd78af_0"

    publishDir "${params.outdir}"
    
    input:
    tuple val(refName), path(annvcf)

    output:
    path("${refName}_snps.tsv"), emit: tsv
    tuple val('snpsift'), eval("SnpSift -version 2>&1 | grep -oE '[0-9]+\\.[0-9]+[a-z]?'"), topic: versions

    script:
    """
    SnpSift \\
        extractFields \\
        -s "." \\
        ${annvcf} \\
        "CHROM" \\
        "POS" \\
        "REF" \\
        "ALT" \\
        "ANN[0].EFFECT" \\
        "ANN[*].IMPACT" \\
        "ANN[*].GENE" \\
        "ANN[*].GENEID" \\
        "ANN[*].HGVS_P" \\
    > ${refName}_snps.tsv
    """

    stub:
    """
    touch ${refName}_snps.tsv
    """
}