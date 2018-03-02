#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: [regtools cis-splice-effects identify]

requirements:
  - class: DockerRequirement
    dockerImageId: griffithlab/regtools

inputs:
    variants:
        type: File
        inputBinding:
            position: 1
    bam:
        type: File
        inputBinding:
            position: 2
    ref:
        type: File
        inputBinding:
            position: 3
    gtf:
        type: File
        inputBinding:
            position: 4

outputs:
    aberrant_splice_junctions:
        type: File
        outputBinding:
            glob: cis_splice_effects_identify.tsv
