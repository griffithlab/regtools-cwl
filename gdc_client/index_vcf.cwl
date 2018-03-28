#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "tabix" ]

arguments: [ "-p", "vcf" ]

requirements:
  - class: DockerRequirement
    dockerImageId:  biocontainers/vcftools
  - class: InitialWorkDirRequirement
    listing:
        - $(inputs.vcf_file)

inputs:
    vcf_file:
        type: File
        inputBinding:
            position: 1

outputs:
    indexed_vcf:
        type: File
        secondaryFiles: [ .tbi ]
        outputBinding:
            glob: "*.vcf.gz"
