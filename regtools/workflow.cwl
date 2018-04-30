#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "regtools workflow"

requirements:
    - class: ScatterFeatureRequirement

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
    e:
        type: string[]?
        default: ["2", "5"]
    i:
        type: string[]?
        default: ["3", "50"]

outputs:
    cis_splice_effects_identify:
        type: File[]
        outputSource: cis_splice_effects/aberrant_splice_junctions
    cis_splice_effects_identify_v2:
        type: File[]
        outputSource: cis_splice_effects/aberrant_splice_junctions_v2
    cis_splice_effects_identify_v3:
        type: File[]
        outputSource: cis_splice_effects/aberrant_splice_junctions_v3
    junctions_extract_out:
        type: File
        outputSource: junctions_extract/junctions
    junctions_annotate_out:
        type: File
        outputSource: junctions_annotate/junctions_annotated

steps:
    cis_splice_effects:
        scatter: [ e, i ]
        scatterMethod: dotproduct
        run: cis_splice_effects.cwl
        in:
            e: e
            i: i
            variants: variants
            bam: rna_tumor_bam
            ref: reference
            gtf: transcriptome
        out: [ aberrant_splice_junctions ]
    cis_splice_effects_v2:
        run: cis_splice_effects_v2.cwl
        in:
            variants: variants
            bam: rna_tumor_bam
            ref: reference
            gtf: transcriptome
        out: [ aberrant_splice_junctions_v2 ]
    cis_splice_effects_v3:
        run: cis_splice_effects_v3.cwl
        in:
            variants: variants
            bam: rna_tumor_bam
            ref: reference
            gtf: transcriptome
        out: [ aberrant_splice_junctions_v3 ]
    junctions_extract:
        run: junctions_extract.cwl
        in:
            bam: rna_tumor_bam
        out: [ junctions ]
    junctions_annotate:
        run: junctions_annotate.cwl
        in:
            junctions: junctions_extract/junctions
            ref: reference
            gtf: transcriptome
        out: [ junctions_annotated ]
