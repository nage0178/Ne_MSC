library("rwty")
#library("rwty", lib.loc = "R-4.5.1/library")
args        = commandArgs(trailingOnly = TRUE)
inputDir   = args[1]
outputDir  = args[2]
#outputFile = args[3]

my.trees  <- load.trees(paste(inputDir, "1/mcmc_no_theta.txt", sep = ""), type = "newick", gens.per.tree = 1)
my.trees2 <- load.trees(paste(inputDir, "2/mcmc_no_theta.txt", sep = ""), type = "newick", gens.per.tree = 1)
#plot1 <- makeplot.splitfreqs.cumulative(list(my.trees, my.trees2))
#plot2 <- makeplot.splitfreqs.sliding(list(my.trees, my.trees2), window.size = 400)
#
#pdf(paste(outputDir, "/", outputFile, "_cum_splitfreq", ".pdf", sep = ""))
#plot1
#dev.off()
#
#pdf(paste(outputDir, "/", outputFile, "_slide_splitfreq", ".pdf", sep = ""))
#plot2
#dev.off()

noBurnESS   <- topological.approx.ess(list(my.trees, my.trees2), burnin = 0)

write.table(noBurnESS$approx.ess, paste(outputDir, "/",  "approx_ess.txt", sep = ""))

