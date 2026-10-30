process MASH_REFERENCE {
    // https://github.com/marbl/Mash
    cpus 32

    container "quay.io/biocontainers/mash:2.3--hf85e966_11"

    input:
    path(refs)

    output:
    path("reference.msh"), emit: sketch
    tuple val("mash"), eval("mash --version"), topic: versions

    script:
    """
    mash sketch -p ${task.cpus} -o reference *.fna
    """

    stub:
    """
    touch reference.msh
    """
}

process MASH_DIST {
    // https://github.com/marbl/Mash
    tag "${ID}"
    cpus 1

    container "quay.io/biocontainers/mash:2.3--hf85e966_11"

    input:
    tuple val(ID), path(reads), path(fasta)
    path ref_sketch

    output:
    tuple val(ID), path(reads), path("${fasta.simpleName}.dist.tsv")

    script:
    """
    mash dist ${ref_sketch} ${fasta} > ${fasta.simpleName}.dist.tsv
    """

    stub:
    """
    touch ${fasta.simpleName}.dist.tsv
    """
}

process NEAREST_REF {
    tag "${ID}"
    cpus 1

    container "quay.io/biocontainers/pandas:2.2.1"

    input:
    tuple val(ID), path(reads), path(mash_dist)

    output:
    tuple val(ID), path(reads), stdout, emit: nearest_ref

    script:
    def command="${projectDir}/bin/nearest_ref.py"
    """
    ${command} ${mash_dist}
    """

    stub:
    """
    echo PAO1
    """
}