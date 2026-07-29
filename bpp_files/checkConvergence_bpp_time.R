library(coda)
analysis <- read.table("lists/bpp_time_trees.txt", header = FALSE)[, 1]

for (run in analysis) {
	checkManual <- c()
	run1 <- read.table(paste(run, "1/out.mcmc.txt", sep = ""), header = TRUE)

	mcmc1 <- as.mcmc(x = run1[-1])
	ess1 <- effectiveSize(mcmc1)
	
	run2 <- read.table(paste(run, "2/out.mcmc.txt", sep = ""), header = TRUE)
	mcmc2 <- as.mcmc(x = run2[-1])
	
	ess2 <- effectiveSize(mcmc2)
	
	gd <- gelman.diag(list(mcmc1,mcmc2))

	if (any(ess1 < 200) || any(ess2 < 200) || any(gd$psrf[, 1] > 1.1)) {
	        checkManual <- c(checkManual, run) 
	        print(run)
	}
	write.csv(checkManual,"notConvergedTimeGelman")

}
