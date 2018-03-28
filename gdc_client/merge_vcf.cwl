#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "vcf-merge" ]

arguments: [ "-d" ]

stdout: merged.vcf

requirements:
  - class: DockerRequirement
    dockerImageId:  biocontainers/vcftools

inputs:
    vcf_file:
        type: File[]
        inputBinding:
            position: 1
        secondaryFiles: [ ^.tbi ]

outputs:
    merged_vcf:
        type: stdout
