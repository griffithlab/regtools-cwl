#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "regtools workflow"

inputs:
    rna_tumor_bam:
        type: File
        doc: RNAseq aligned tumor bam
#    dna_tumor_bam:
#        type: File
#        doc: DNA aligned tumor bam
    reference:
        type: File
        doc: Fasta file containing the reference corresponding to the bam files
    transcriptome:
        type: File
        doc: GTF file giving the transcriptome used to annotate against
    variants:
        type: File
        doc: VCF file providing somatic variant calls
#    polymorphisms:
#        type: File
#        doc: VCF file providing polymorphic loci in order to determine allele specific expression

outputs:
    cis_splice_effects_identify:
        type: File
        outputSource: cis_splice_effects/aberrant_splice_junctions
#    cis_ase_identify:
#        type: File
#        outputSource: cis_ase
#    junctions_extract:
#        type: File
#        outputSource: junctions
#    junctions_annotate:
#        type: File
#        outputSource: junctions
#    variants_annotate:
#        type: File
#        outputSource: annotate

steps:
    cis_splice_effects:
        run: cis_splice_effects.cwl
        in:
            variants: variants
            bam: rna_tumor_bam
            ref: reference
            gtf: transcriptome
        out: [ aberrant_splice_junctions ]
#    cis_ase:
#        run: cis_ase.cwl
#        in:
#            variants: variants
#            polymorphisms: polymorphisms
#            dna: dna_tumor_bam
#            rna: rna_tumor_bam
#            ref: reference
#            gtf: transcriptome
#        out: [ allele_specific_expression ]
#    junctions:
#        run: junctions.cwl
#        in:
#            rna: rna_tumor_bam
#        out: [ junctions ]
#    variants:
#        run: variants.cwl
#        in:
#            variants: variants
#            gtf: transcriptome
#        out: [ variants_annotated ]
