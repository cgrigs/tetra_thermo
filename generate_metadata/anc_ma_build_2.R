#!/usr/bin/Rscript

# Load required libraries
library(stringr)
library(readr)



# Function to process FASTQ file
main = function(filename) {
   
    lines <- read_lines(filename, n_max = 400)
    a <- str_split(lines[1], "[: ]")[[1]]
    flowcell <- a[3]
    lane <- a[4]

    lines <- lines[seq(1, 400, 4)]
    lines_split <- str_split(lines, "[: ]")
    index <- sapply(lines_split, `[`, 11)
    index <- names(rev(sort(table(index))))[1]

    # Set metadata based on flowcell ID
    if(flowcell == "HNCFLBGXX") {
        PL <- "ILLUMINA"
        PM <- "NextSeq"
        DT <- "2016-01-19"
    } else if(flowcell == "H2KCTBGX2") {
        PL <- "ILLUMINA"
        PM <- "NextSeq"
        DT <- "2017-04-14"
    } else if(flowcell == "HLVMKAFXX") {
        PL <- "ILLUMINA"
        PM <- "NextSeq"
        DT <- "2017-05-26"
    } else if(flowcell == "000000000-AL996") {
        PL <- "ILLUMINA"
        PM <- "MiSeq"
        DT <- "2016-02-10"
    } else {
        # Default or unknown flowcell
        PL <- "Unknown"
        PM <- "Unknown"
        DT <- "Unknown"
    }

     # Construct identifiers
    rg_id <- paste(flowcell, lane, index, sep = ".")
    rg_pu <- paste(flowcell, lane, sep = ".")
    rg_pl <- PL
    rg_lb_original <- str_extract(basename(filename), "^[-\\w]+(?=_S\\d+_L\\d\\d\\d)")
    rg_lb = str_replace(rg_lb_original, "Anc-(\\d+)-([A-Za-z]+)", "AncGE\\1\\2")

    rg_sm <- rg_lb  # Assign transformed rg_lb to rg_sm
    base <- str_extract(basename(filename), "^[-\\w]+_S\\d+_L\\d\\d\\d(?=_R[12])")

    # Using basename(filename) to include only the file's basename
    list(file = basename(filename), base = base, ID = rg_id, LB = rg_lb, SM = rg_sm,
         DT = DT, CN = "DNASU", PM = PM, DS = "\"T. thermophila Whole Genome DNA\"")

}

# Script execution for non-interactive mode
if (!interactive() || TRUE) {
    data_dir <- "/scratch/cgrigsb2/tet/TetMA/Tthermophila_fastqs/"
    output_file <- "/home/cgrigsb2/tet/tetra_thermo/generate_metadata/metadata.tsv"

    fastq_files <- list.files(path = data_dir, pattern = "\\.fastq\\.gz$", full.names = TRUE)
    results <- lapply(fastq_files, main)
    output <- do.call(rbind.data.frame, results)
    write.table(output, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE)
}
