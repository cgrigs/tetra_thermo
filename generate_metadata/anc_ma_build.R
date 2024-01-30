#!/usr/bin/Rscript

# Load required library
suppressPackageStartupMessages(library(stringr))

# Function to process FASTQ file
main = function(filename) {
    
    # Determine if the file is gzipped and choose the appropriate function to read it
    read_func <- ifelse(grepl("\\.gz$", filename), gzfile, file)

    # Open the file using the determined functionRsc    
    con <- read_func(filename, "r")
    on.exit(close(con))

    # Read the first 400 lines from the file
    lines <- readLines(con, n = 400)

    # Split the first sequencing identifier to extract information
    a <- str_split(lines[1], "[: ]")[[1]]
    flowcell <- a[3]
    lane <- a[4]

    # Initialize index array
    index <- c()
    for (i in seq(1, 400, 4)) {
        a <- str_split(lines[i], "[: ]")[[1]]
        if (length(a) >= 11) {
            # Index exists, add to the array
            index <- c(index, a[11])
        } else {
            # Index does not exist, add a placeholder
            index <- c(index, "NA")
        }
    }

    # Determine the most frequent index
    index <- names(rev(sort(table(index))))[1]

    # Dynamically set run date based on condition
    run_date <- ifelse(grepl("2016", filename), "2016-01-19", "2017-04-14")

    # Construct identifiers
    rg_id <- paste(flowcell, lane, index, sep = ".")
    rg_pu <- paste(flowcell, lane, sep = ".")
    rg_pl <- "ILLUMINA"
    rg_lb <- str_extract(basename(filename), "^[-\\w]+(?=_S\\d+_L\\d\\d\\d)")
    rg_sm <- str_match(rg_lb, "^([-\\w]+?)(-[AB]+)?$")[2]
    base <- str_extract(basename(filename), "^[-\\w]+_S\\d+_L\\d\\d\\d(?=_R[12])")

    # Return list of information
    list(file = filename, base = base, ID = rg_id, LB = rg_lb, SM = rg_sm, PU = rg_pu, PL = rg_pl,
         DT = run_date, CN = "DNASU", PM = "NextSeq", DS = "\"T. thermophila Whole Genome DNA\"")
}

# Script execution for non-interactive mode
if (!interactive()) {
    # Define input and output paths
    data_dir <- "/scratch/cgrigsb2/TetMA/Tthermophila_fastqs/"
    output_file <- "/home/cgrigsb2/tet/generate_metadata/metadata_test.tsv"

    # List all FASTQ files in the data directory
    fastq_files <- list.files(path = data_dir, pattern = "\\.fastq\\.gz$", full.names = TRUE)

    # Process each file and collect results
    results <- lapply(fastq_files, main)

    # Combine results into a data frame and write to the output file
    output <- do.call(rbind.data.frame, results)
    write.table(output, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE)
}

# Function to capture and write warnings to a file
write_warnings_to_file <- function(script_code, file_name) {
    warnings_vec <- c()
    withCallingHandlers(script_code, warning = function(w) {
        warnings_vec <<- c(warnings_vec, conditionMessage(w))
        invokeRestart("muffleWarning")
    })
    writeLines(warnings_vec, file_name)
}

# Script execution for non-interactive mode
if (!interactive()) {
    # ... [existing code to define input and output paths] ...

    # Capture and write warnings to a file
    write_warnings_to_file({
        # Existing code to process FASTQ files
        fastq_files <- list.files(path = data_dir, pattern = "\\.fastq\\.gz$", full.names = TRUE)
        results <- lapply(fastq_files, main)
        output <- do.call(rbind.data.frame, results)
        write.table(output, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE)
    }, "metadata_warnings.txt")
}

