#!/usr/bin/env cwl-runner

class: CommandLineTool

cwlVersion: v1.0

baseCommand: [ "Rscript", "helper.R" ]

requirements:
  - class: DockerRequirement
    dockerImageId:  zlskdimore/regtools-cwl
  - class: InitialWorkDirRequirement
    listing:
    - entryname: 'helper.R'
      entry: |
        ################################################################################
        ################# Set up arguments #############################################

        library(data.table)

        args <- commandArgs(trailingOnly=TRUE)
        merged_vcf <- args[1]
        vcf_files <- args[2:length(args)]

        ################################################################################
        ################## read the master merged variant file #########################

        # read in merged variant header
        fileHeader_merge <- readLines(merged_vcf, n=500)

        # read in just the merged variant data based on the last line of the header
        fileData_merge <- fread(merged_vcf, skip=which(grepl("#CHROM", fileHeader_merge))-1)
        fileHeader_merge <- fileHeader_merge[grepl("^##", fileHeader_merge)]

        # key the file for merge later
        fileData_merge$key <- paste(fileData_merge$`#CHROM`, fileData_merge$`POS`, fileData_merge$`REF`, fileData_merge$`ALT`, sep=":")

        ################################################################################
        ################### read in individual caller variant files ####################

        # anonymous function to read in individual variant files
        a <- function(x){
          fileHeader <- readLines(x, n=500)
          caller <- fileHeader[which(grepl("somatic_mutation_calling_workflow", fileHeader))]
          caller <- gsub(".*Name=", "", caller)
          caller <- gsub(",Desc.*", "", caller)

          fileData <- fread(input=paste("zcat", "<", x), skip=which(grepl("#CHROM", fileHeader))-1)
          fileData$key <- paste(fileData$`#CHROM`, fileData$`POS`, fileData$`REF`, fileData$`ALT`, sep=":")

          fileData$present <- 1
          fileData <- fileData[,c("key", "present")]
          colnames(fileData)[2] <- caller
          return(fileData)
        }

        vcf_data <- lapply(vcf_files, a)

        # add the merged vcf to our list of vcf data from individual callers
        vcf_data[[length(vcf_data) + 1]] <- fileData_merge
        vcf_data <- rev(vcf_data)

        ################################################################################
        ##################### merge master variant file with individual calers #########

        # merge the variants of the merged vcf with the individual callers
        out <- Reduce(function(x, y) merge(x, y, all=TRUE), vcf_data)
        out$key <- NULL

        # nothing in the #CHROM column should be na, if it is remove it
        out <- out[!is.na(out$`#CHROM`),]

        ################################################################################
        ############### tally the total number of callers per variant ##################

        # create tally
        callers <- c("muse", "varscan2", "mutect2", "somaticsniper")
        out$callerCount <- rowSums(out[,callers, with=FALSE], na.rm=TRUE)

        # filter results to only variants called in >= 2 callers
        out <- out[out$callerCount >= 2,]

        ################################################################################
        ############ write output ######################################################
        write.table(fileHeader_merge, "merged.filtered.vcf", quote=F, sep="\t", row.names=FALSE, col.names=FALSE)
        write.table(out, "merged.filtered.vcf", quote=FALSE, sep="\t", row.names=FALSE, append=TRUE)

inputs:
    merged_vcf_file:
        type: File
        inputBinding:
            position: 1
    caller_vcf_file:
        type: File[]
        inputBinding:
            position: 2

outputs:
    filtered_vcf:
      type: File
      outputBinding:
        glob: "*.vcf"
