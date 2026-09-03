library(phrynomics)
# Prepare data for SNPAPP
#directories <- read.table("lists/dirListTime", header = FALSE)[,1]
directories <- read.table("lists/dirListTimeSNP", header = FALSE)[,1]

args <- commandArgs(trailingOnly = TRUE)
rep  <- as.numeric(args[1])

prep_snps <- function(dir, i) {
	file <- paste(dir,"/rep", i, "/data.phy", sep = "")
	print(file)
	snps <- ReadSNP(file, fileFormat="phy", extralinestoskip = 1)
	snps <- RemoveNonBinary(snps)
	#snps <- TakeSingleSNPfromEachLocus(snps)$snpdata
	#snps <- TranslateBases(snps, translateMissingChar="?", ordered=TRUE)
	outfile <- paste(dir, "/rep", i,  "/snps.nex", sep = "")
	WriteSNP(snps, file=outfile, format="nexus", missing="?")
}

lapply(directories, prep_snps, i=rep)


