process SNIPPY {
    // https://github.com/tseemann/snippy
    tag "${ID}"
    cpus 16

    container "quay.io/staphb/snippy:4.6.0-SC2"

    input:
    tuple val(ID), path(reads), path(ref)

    output:
    tuple path("${ID}_snps"), path(ref), val(ref.simpleName), emit: snippy_out_ch
    tuple val('snippy'), eval("snippy --version | sed 's/snippy //'"), topic: versions

    script:
    def R1="${reads[0]}"
    def R2="${reads[1]}"
    """
    snippy \\
        --cpus ${task.cpus} \\
        --outdir ${ID}_snps \\
        --ref ${ref} \\
        --R1 ${R1} \\
        --R2 ${R2}
    """

    stub:
    """
    touch ${ID}_snps
    """
}

process SNIPPY_CORE {
    // https://github.com/tseemann/snippy
    tag "${refName}"
    scratch true

    container "quay.io/staphb/snippy:4.6.0-SC2"

    publishDir "${params.outdir}", pattern: "*.aln"

    input:
    tuple path(snps_dirs), path(ref), val(refName)

    output:
    tuple val(refName), path("${refName}.aln"), emit: aln
    tuple val(refName), path("${refName}.vcf"), emit: vcf
    tuple val('snippy'), eval("snippy --version | sed 's/snippy //'"), topic: versions

    script:
    """
    snippy-core \\
        --ref ${ref} \\
        --prefix ${refName} \\
        ${snps_dirs}
    """

    stub:
    """
    touch ${refName}.aln
    touch ${refName}.vcf
    """
}