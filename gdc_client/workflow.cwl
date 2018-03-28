#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: "gdc workflow"

requirements:
    - class: ScatterFeatureRequirement

inputs:
    gdc_token:
        type: File
        doc: gdc_token providing permission for downloading controlled access data
    tcga_sample:
        type: string
        doc: String giving the TCGA sample id, i.e. TCGA-01-0001-01A

outputs:
#    bam_manifest:
#        type: File
#        outputSource: obtain_manifest_bam/bam_manifest
#    bam_file:
#        type: File
#        outputSource: download_bam/bam_file
    vcf_manifest:
        type: File
        outputSource: obtain_manifest_vcf/vcf_manifest
    vcf_file:
        type: File[]
        outputSource: download_vcf/vcf_file
    decompress_vcf_file:
        type: File[]
        outputSource: decompress_vcf/decompress_vcf_file
    merged_vcf_file:
        type: File
        outputSource: merge_vcf/merged_vcf

steps:
#    obtain_manifest_bam:
#        run: obtain_manifest_bam.cwl
#        in:
#            gdc_token: gdc_token
#            tcga_sample: tcga_sample
#        out: [ bam_manifest ]
#    download_bam:
#        run: download_bam.cwl
#        in:
#            gdc_token: gdc_token
#            bam_manifest: obtain_manifest_bam/bam_manifest
#        out: [ bam_file ]
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
        out: [ vcf_index ]
    merge_vcf:
        run: merge_vcf.cwl
        in:
            vcf_file: [ bgzip_vcf/bgzip_vcf_file ]
            secondaryFiles: [ index_vcf/vcf_index ]
        out: [ merged_vcf ]
