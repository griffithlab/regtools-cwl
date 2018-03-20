#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "regtools workflow"

inputs:
    rna_tumor_bam:
        type: File
        doc: RNAseq aligned tumor bam
    reference:
        type: File
        doc: Fasta file containing the reference corresponding to the bam files
    transcriptome:
        type: File
        doc: GTF file giving the transcriptome used to annotate against
    variants:
        type: File
        doc: VCF file providing somatic variant calls

outputs:
    cis_splice_effects_identify:
        type: File
        outputSource: cis_splice_effects/aberrant_splice_junctions

steps:
    cis_splice_effects:
        run: cis_splice_effects.cwl
        in:
            variants: variants
            bam: rna_tumor_bam
            ref: reference
            gtf: transcriptome
        out: [ aberrant_splice_junctions ]
