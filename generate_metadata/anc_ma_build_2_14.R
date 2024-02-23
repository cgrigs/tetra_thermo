#!/usr/bin/Rscript

#SBATCH -J QC
#SBATCH -p general
#SBATCH -N 1
#SBATCH -c 4
#SBATCH --mem=32G
#SBATCH -t 0-1:00:00
#SBATCH -o slurm.%j.out
#SBATCH -e slurm.%j.err


module load r-4.3.2-gcc-11.2.0 

# Load required library
library(stringr)
library(readr)

# Function to check if a gzipped file is corrupt
is_corrupt <- function(filename) {
    command <- paste("gzip -t", shQuote(filename))
    result <- system(command, ignore.stdout = TRUE, ignore.stderr = TRUE)
    return(result != 0) 
}


main = function(filename) {

       # Skip processing if the file is corrupt
    if (is_corrupt(filename)) {
        message("Skipping corrupt file: ", filename)
        return(NULL)
    }

    print(filename)

   
    lines <- read_lines(filename, n_max = 400)
    a <- str_split(lines[1], "[: ]")[[1]]
    flowcell <- a[3]
    lane <- a[4]

    # Get fastq headers
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

   
    rg_id <- paste(flowcell, lane, index, sep = ".")
    rg_pu <- paste(flowcell, lane, sep = ".")
    rg_pl <- PL
    rg_lb <- str_extract(basename(filename), "^[-\\w]+(?=_S\\d+_L\\d\\d\\d)")
    rg_sm <- str_match(rg_lb, "^([-\\w]+?)(-[AB]+)?$")[2]
    base <- str_extract(basename(filename), "^[-\\w]+_S\\d+_L\\d\\d\\d(?=_R[12])")


    list(file = filename, base = base, ID = rg_id, LB = rg_lb, SM = rg_sm, PU = rg_pu, PL = rg_pl,
         DT = run_date, CN = "DNASU", PM = PM, DS = "\"T. thermophila Whole Genome DNA\"")
}


if (!interactive() || TRUE) {

    #data_dir <- "/scratch/cgrigsb2/TetMA/Tthermophila_fastqs/"
    data_dir <- "/scratch/rcartwri/Tthermophila_fastqs/"
    output_file <- "/home/cgrigsb2/tet/generate_metadata/metadata.tsv"

    fastq_files <- list.files(path = data_dir, pattern = "\\.fastq\\.gz$", full.names = TRUE)
    results <- lapply(fastq_files, main)
    output <- do.call(rbind.data.frame, results)
    write.table(output, file = output_file, sep = "\t", quote = FALSE, row.names = FALSE)
}
