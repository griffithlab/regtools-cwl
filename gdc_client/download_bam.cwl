#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "gdc-client" ]

arguments: [ "download", "-m", $(inputs.bam_manifest), "-t", $(inputs.gdc_token) ]

requirements:
  - class: DockerRequirement
    dockerImageId: mgibio/gdc-client

inputs:
    bam_manifest:
        type: File
    gdc_token:
        type: File

outputs:
    bam_file:
        type: File
        secondaryFiles: [.bai]
        outputBinding:
            glob: "*/*.bam"
