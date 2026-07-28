library(ape)

rep <- 50
#directories <- read.table("dirListTimeTwo", header = FALSE)
directories <- read.table("dirListTime", header = FALSE)

# Repeat each directory 50 times for the replicates
trees <- c(matrix(directories[,1], nrow = rep, ncol = length(directories[,1]), byrow = TRUE))

# Get the conditions into separate fields
trees <- unlist(lapply(trees,strsplit, split = "/"))
trees <- matrix(trees, nrow = dim(directories)[1] * rep, byrow =TRUE)

colnames(trees) <-  c("experiment", "topology", "demography", "loci_samples", "theta", "Ne")
trees <- as.data.frame(trees)

# Extract the value of theta and replicate
trees$theta   <- unlist(lapply(trees$theta, substr, start = 6, stop = "11"))
trees$rep     <- unlist(lapply(trees$rep, substr, start = 4, stop = "6"))

# Extract the number of loci and the number of samples
loci_samples <- matrix(unlist(lapply(trees$loci_samples, strsplit, split = "_")), nrow = dim(directories)[1] * rep, byrow = TRUE)
trees$loci    <- unlist(lapply(loci_samples[,1], substr, start = 2, stop = 5))
trees$samples <- unlist(lapply(loci_samples[,2], substr, start = 2, stop = 5))

# Add the replicates
trees$rep <- c(1:50)

directories <- directories[, 1]

get_times <- function(dir) {
	rep <- 50
	times <- matrix(NA, nrow = rep, ncol = 4)
	for (i in c(1:rep)) {
		file <- paste(dir,"/rep", i, "/picl_best.tre", sep = "")
		if (! file.exists(file)) {
			next	
		}
		tree <- read.tree(file)
		times[i, ] <- branching.times(tree)
	}
	return (times)
}

get_CI <- function(dir) {
	rep <- 50
	CI <- matrix(NA, nrow = rep, ncol = 8)
	for (i in c(1:rep)) {
		file <- paste(dir,"/rep", i, "/boots.dat", sep = "")
		if (! (file.exists(file) && file.info(file)$size > 0)) {
			next	
		}
		boot <- read.table(file)
		if ( dim(boot)[1] != 200) 
			next
		sorted <- apply(boot, 2, sort)
		CI[i, ] <- c(sorted[6, ], sorted[195,])

	}
	return (CI)
}

# Get the divergence times
times <- do.call(rbind, lapply(directories, get_times))
colnames(times) <- c("t1", "t2", "t3", "t4")

# Get the confidence internals 
tmp <-lapply(directories, get_CI)
print(tmp)
CI <- do.call(rbind, lapply(directories, get_CI))
colnames(CI) <-  c("t1_2.5", "t2_2.5", "t3_2.5", "t4_2.5","t1_97.5", "t2_97.5", "t3_97.5", "t4_97.5")

write.csv(cbind(trees, times, CI), "picl_times.csv", row.names = FALSE, quote = FALSE)
