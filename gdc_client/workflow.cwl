#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "gdc workflow"

requirements:
    - class: ScatterFeatureRequirement
    - class: SubworkflowFeatureRequirement

inputs:
    gdc_token:
        type: File
        doc: gdc_token providing permission for downloading controlled access data
    tcga_sample:
        type: string
        doc: String giving the TCGA sample id, i.e. TCGA-01-0001-01A
    reference:
        type: File
        doc: Fasta file containing the reference corresponding to the bam files
    transcriptome:
        type: File
        doc: GTF file giving the transcriptome used to annotate against

outputs:
    filtered_vcf_file:
        type: File
        outputSource: filter_vcf/filtered_vcf

steps:
    obtain_manifest_bam:
        run: obtain_manifest_bam.cwl
        in:
            gdc_token: gdc_token
            tcga_sample: tcga_sample
        out: [ bam_manifest ]
    download_bam:
        run: download_bam.cwl
        in:
            gdc_token: gdc_token
            bam_manifest: obtain_manifest_bam/bam_manifest
        out: [ bam_file ]
    obtain_manifest_vcf:
        run: obtain_manifest_vcf.cwl
        in:
            gdc_token: gdc_token
            tcga_sample: tcga_sample
        out: [ vcf_manifest ]
    download_vcf:
        run: download_vcf.cwl
        in:
            gdc_token: gdc_token
            vcf_manifest: obtain_manifest_vcf/vcf_manifest
        out: [ vcf_file ]
    decompress_vcf:
        scatter: [ vcf_file ]
        scatterMethod: dotproduct
        run: decompress_vcf.cwl
        in:
            vcf_file: download_vcf/vcf_file
        out: [ decompress_vcf_file ]
    bgzip_vcf:
        scatter: [ vcf_file ]
        scatterMethod: dotproduct
        run: bgzip_vcf.cwl
        in:
            vcf_file: decompress_vcf/decompress_vcf_file
        out: [ bgzip_vcf_file ]
    index_vcf:
        scatter: [ vcf_file ]
        scatterMethod: dotproduct
        run: index_vcf.cwl
        in:
            vcf_file: bgzip_vcf/bgzip_vcf_file
        out: [ indexed_vcf ]
    merge_vcf:
        run: merge_vcf.cwl
        in:
            vcf_file: [ index_vcf/indexed_vcf ]
        out: [ merged_vcf ]
    filter_vcf:
        run: filter_vcf.cwl
        in:
            merged_vcf_file: merge_vcf/merged_vcf
            caller_vcf_file: [ index_vcf/indexed_vcf ]
        out: [ filtered_vcf ]
    regtools:
        run: ../regtools/workflow.cwl
        in:
            rna_tumor_bam: download_bam/bam_file
            reference: reference
            transcriptome: transcriptome
            variants: filter_vcf/filtered_vcf
        out: []
