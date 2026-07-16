library(coda)
analysis <- read.table("bpp_time_trees.txt", header = FALSE)[, 1]

for (run in analysis) {
	checkManual <- c()
	run1 <- read.table(paste(run, "1/out.mcmc.txt", sep = ""), header = TRUE)
	#print(run1)

  	#keep <- (floor(dim(run1)[1]*.25) + 1): dim(run1)[1]
	mcmc1 <- as.mcmc(x = run1[-1])
	ess1 <- effectiveSize(mcmc1)
	
	run2 <- read.table(paste(run, "2/out.mcmc.txt", sep = ""), header = TRUE)
	mcmc2 <- as.mcmc(x = run2[-1])
	
	ess2 <- effectiveSize(mcmc2)
	
	gd <- gelman.diag(list(mcmc1,mcmc2))
	print(ess1)
	print(ess2)
	
	if (any(ess1 < 200) || any(ess2 < 200) || any(gd$psrf[, 1] > 1.1)) {
	        checkManual <- c(checkManual, run) 
	        print(run)
	}
	write.csv(checkManual,"notConvergedTimeGelman")

}
