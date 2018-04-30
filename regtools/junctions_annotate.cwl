#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: ["regtools","junctions","annotate"]

stdout: junctions_annotate.bed

requirements:
  - class: DockerRequirement
    dockerImageId: griffithlab/regtools
    dockerPull: griffithlab/regtools

inputs:
    junctions:
        type: File
        inputBinding:
            position: 1
    ref:
        type: File
        inputBinding:
            position: 2
        secondaryFiles: [^.fa.fai]
    gtf:
        type: File
        inputBinding:
            position: 3

outputs:
    junctions_annotated:
        type: stdout
