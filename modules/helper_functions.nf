#!/usr/bin/env nextflow

def printHelp() {
    log.info """
Usage:
    nextflow run main.nf --input <path/to/manifest.csv> --refs <path/to/refs>

    --refs                              Path to dir containing PAO1, PA14 and PA7 refs
    --input                             Path to SNP Analysis input manifest (e.g. <path/to/manifest>)
"""
}

def asFile(path) {
    return file(path, checkIfExists: true)
}

def setInputChannel() {
    def rows = channel.fromPath(params.input).splitCsv(header: true)
    return rows.map { row ->
        tuple(row.ID, [asFile(row.R1), asFile(row.R2)], asFile(row.fasta))
    }
}

def validateRefs() {
    def fnaIds  = files("${params.refs}/*.fna",  checkIfExists: true).collect { it.baseName } as Set
    def gbffIds = files("${params.refs}/*.gbff", checkIfExists: true).collect { it.baseName } as Set

    if (fnaIds != gbffIds) {
        error "Reference mismatch in '${params.refs}': " +
              ".fna without .gbff: ${(fnaIds - gbffIds).sort()}, " +
              ".gbff without .fna: ${(gbffIds - fnaIds).sort()}"
    }
}

def validateParams() {
    if (!params.input) {
        error "Missing: --input <path/to/manifest>"
    }
    if (!params.refs) {
        error "Missing: --refs <path/to/refs_dir>"
    }
}

def validateManifest() {
    def headers = file(params.input, checkIfExists: true).readLines().first().split(',')*.trim()
    def missing = ['ID', 'R1', 'R2', 'fasta'] - headers
    if (missing) {
        error "Manifest is missing required columns: ${missing.join(', ')}"
    }
}