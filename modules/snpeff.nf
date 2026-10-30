process SNPEFF {
    // https://pcingola.github.io/SnpEff/
    cpus 1
    tag "${refName}"

    container "quay.io/biocontainers/snpeff:5.4.0c--hdfd78af_0"

    publishDir "${params.outdir}"

    input:
    tuple val(refName), path(vcf)

    output:
    tuple val(refName), path("${refName}.ann.vcf"), emit: vcf
    path("${refName}.snpEff.html"), emit: html
    tuple val('snpeff'), eval("snpEff -version | cut -f 2 -d '\t'"), topic: versions

    script:
    """
    if [ ${refName} = "PAO1" ]; then
        database="Pseudomonas_aeruginosa_pao1_gca_000006765"
        cat ${vcf} | sed "s/^NC_002516/Chromosome/" > ${refName}_updated.vcf
    elif [ ${refName} = "PA07" ]; then
        cat ${vcf} | sed "s/^NC_009656/Chromosome/" > ${refName}_updated.vcf
        database="Pseudomonas_aeruginosa_pa7_gca_000017205"
    elif [ ${refName} = "PA14" ]; then
        cat ${vcf} | sed "s/^NC_008463/Chromosome/" > ${refName}_updated.vcf
        database="Pseudomonas_aeruginosa_ucbpp_pa14_gca_000014625"
    fi

    snpEff \\
        download \$database \\
        -dataDir \${PWD}/snpeff_cache

    snpEff \\
        -XX:-UsePerfData \\
        \$database \\
        -stats ${refName}.snpEff.html \\
        -dataDir \${PWD}/snpeff_cache \\
        -no-downstream \\
        -no-upstream \\
        -no-utr \\
        ${refName}_updated.vcf \\
        > ${refName}.ann.vcf
    """
}