#!/usr/bin/env Rscript
# Usage: Rscript iupac_consensus.R input.fasta output.fasta
# Requires seqinr. Accepts DNA IUPAC codes in either case; rejects gaps.

bases <- c(
  A = "A", C = "C", G = "G", T = "T",
  R = "AG", Y = "CT", S = "CG", W = "AT", K = "GT", M = "AC",
  B = "CGT", D = "AGT", H = "ACT", V = "ACG", N = "ACGT"
)
code <- setNames(names(bases), bases)
bases <- strsplit(bases, "")

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 2)
  stop("Usage: Rscript iupac_consensus.R input.fasta output.fasta")

#library(seqinr)
library(ape)
sequences <- read.dna(args[1], format = "sequential", as.character = TRUE)
#sequences <- read.alignment(args[1], format = "phylip")
#sequences <- lapply(seqinr::read.fasta(args[1], seqonly = TRUE), toupper)
#sequences <- lapply(seqinr::read.alignment(args[1], seqonly = TRUE, format = "phylip"), toupper)
typeof( sequences)
getAmbi <- function(column) {
#	print(column)
  key <- lapply(paste(sort(unique(column)), collapse = ""), toupper)[[1]]
  #print(key)
  consensus <- code[[key]]
  return (consensus)
}

consensus <- character(length(sequences[[1]]))
#for (i in seq_along(consensus)) {
  ambi <- apply(sequences, 2, getAmbi)
  # Expand ambiguity codes and form the sorted union of represented bases.
#}
print(ambi)

writeLines(c(">consensus", paste(ambi, collapse = "")), args[2])

