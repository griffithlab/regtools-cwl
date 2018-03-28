#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

arguments: [ { valueFrom: "token=`cat $(inputs.gdc_token.path)`", shellQuote : false }, "curl", "-O", "-J", "-H", { valueFrom: '"X-Auth-Token: $token"', shellQuote : false }, "https://api.gdc.cancer.gov/files?filters=%7B%0A%20%20%20%20%22op%22%3A%22and%22%2C%0A%20%20%20%20%22content%22%3A%5B%0A%20%20%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%22op%22%3A%22%3D%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22content%22%3A%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22field%22%3A%22cases.samples.submitter_id%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22value%22%3A%22$(inputs.tcga_sample)%22%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%22op%22%3A%22%3D%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22content%22%3A%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22field%22%3A%22data_type%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22value%22%3A%22Annotated%20Somatic%20Mutation%22%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%22op%22%3A%22%3D%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22content%22%3A%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22field%22%3A%22experimental_strategy%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22value%22%3A%22WXS%22%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%7D%2C%0A%20%20%20%20%20%20%20%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%22op%22%3A%22%3D%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%22content%22%3A%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22field%22%3A%22data_format%22%2C%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%22value%22%3A%22VCF%22%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%5D%0A%7D&sort=updated_datetime:dsc&return_type=manifest" ]

requirements:
  - class: DockerRequirement
    dockerImageId: mgibio/gdc-client
  - class: ShellCommandRequirement

inputs:
    gdc_token:
        type: File
    tcga_sample:
        type: string

outputs:
    vcf_manifest:
        type: File
        outputBinding:
            glob: "*.txt"
