#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: ["regtools","junctions","extract"]

stdout: junctions_extract.bed

requirements:
  - class: DockerRequirement
    dockerImageId: griffithlab/regtools

inputs:
    bam:
        type: File
        inputBinding:
            position: 1
        secondaryFiles: [ ^.bai ]

outputs:
    junctions:
        type: stdout
