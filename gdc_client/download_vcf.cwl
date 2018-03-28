#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "gdc-client" ]

arguments: [ "download", "-m", $(inputs.vcf_manifest), "-t", $(inputs.gdc_token) ]

requirements:
  - class: DockerRequirement
    dockerImageId: mgibio/gdc-client

inputs:
    vcf_manifest:
        type: File
    gdc_token:
        type: File

outputs:
    vcf_file:
        type: File[]
        outputBinding:
            glob: "*/*.vcf.gz"
