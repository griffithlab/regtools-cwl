#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "gunzip" ]

arguments: [ "--keep" ]

requirements:
  - class: DockerRequirement
    dockerImageId:  biocontainers/vcftools
    dockerPull: biocontainers/vcftools
  - class: InitialWorkDirRequirement
    listing:
        - $(inputs.vcf_file)

inputs:
    vcf_file:
        type: File
        inputBinding:
            position: 1

outputs:
    decompress_vcf_file:
        type: File
        outputBinding:
            glob: "*.vcf"
