# Usage: Rscript iupac_consensus.R input.fasta output.fasta
library(ape)

bases <- c(
  A = "A", C = "C", G = "G", T = "T",
  R = "AG", Y = "CT", S = "CG", W = "AT", K = "GT", M = "AC",
  B = "CGT", D = "AGT", H = "ACT", V = "ACG", N = "ACGT"
)
code <- setNames(names(bases), bases)
bases <- strsplit(bases, "")

getAmbi <- function(column) {
  key <- lapply(paste(sort(unique(column)), collapse = ""), toupper)[[1]]
  consensus <- code[[key]]
  return (consensus)
}

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2)
  stop("Usage: Rscript iupac_consensus.R input.fasta output.fasta")

sequences <- read.dna(args[1], format = "sequential", as.character = TRUE)

# Writes header
cat("5 ", dim(sequences)[2],  "\n", file = args[2], sep = "")

# This is hard coded to use files with 5 species, 8 sequences per species
for (pairs in 0:4)  {
  seq_pair <- (pairs*8 + 1):(pairs*8 + 2)
  ambi <- apply(sequences[seq_pair, ], 2, getAmbi)
  line <- paste("n", pairs+1, "\t", sep = "")

  cat(line, file = args[2], sep = "", append = TRUE)
  cat(paste(ambi, collapse = ""), file = args[2], append = TRUE)
  cat("\n", file= args[2], append = TRUE)

} 
