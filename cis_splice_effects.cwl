#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: ["regtools","cis-splice-effects","identify"]

stdout: cis_splice_effects_identify.tsv

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
        secondaryFiles: [^.bam.bai]
    ref:
        type: File
        inputBinding:
            position: 3
        secondaryFiles: [^.fa.fai]
    gtf:
        type: File
        inputBinding:
            position: 4

outputs:
    aberrant_splice_junctions:
        type: stdout
