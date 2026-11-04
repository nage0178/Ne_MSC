args  = commandArgs(trailingOnly = TRUE)
ghost = args[1]

if (ghost != 1)  {
	input_trees <- read.table("time_tree.txt", header = FALSE)#[, 1]
	lowESS <- read.table("bppTimeLowESS", header = FALSE)[,7]
	lowGelman <- read.table("notConvergedTimeGelman", header = TRUE, sep = ",")[,2]
	lowGelman <- c(paste0(lowGelman, "1/outBpp"), paste0(lowGelman, "2/outBpp"))
	lowESS <- c(lowESS, lowGelman)
	ghost_str <- ""
} else {
	input_trees <- read.table("lists/time_trees_ghost.txt", header = FALSE)#[, 1]
	lowESS <- read.table("bppTimeLowESS_ghost", header = FALSE)[,7]
	ghost_str <- "ghost_"
}

simulations <- unlist(apply(input_trees, 1, strsplit, split = "/"))
# Bpp has two additional directories in the path which we don't need to keep
simulations <- matrix(simulations,  nrow = nrow(input_trees), byrow =TRUE)

colnames(simulations) <-  c("experiment", "topology", "demography", "loci_samples", "theta", "Ne", "rep")
simulations <- as.data.frame(simulations)

# Extract the value of theta and replicate
simulations$theta   <- unlist(lapply(simulations$theta, substr, start = 6, stop = "11"))
simulations$rep     <- unlist(lapply(simulations$rep, substr, start = 4, stop = "6"))

# Extract the number of loci and the number of samples
loci_samples <- matrix(unlist(lapply(simulations$loci_samples, strsplit, split = "_")), nrow = nrow(input_trees), byrow = TRUE)
simulations$loci    <- unlist(lapply(loci_samples[,1], substr, start = 2, stop = 5))
simulations$samples <- unlist(lapply(loci_samples[,2], substr, start = 2, stop = 5))

all_result <- matrix(NA, ncol = 13, nrow = 0 )

for (i in 1:dim(input_trees)[1]) {
	file <- paste(input_trees[i, 1], "/bpp/", ghost_str, "1/time_sum.txt", sep = "")

	# If MCMC 1 has low ESS
	if ( sub("time_sum.txt", "outBpp", file) %in% lowESS) {
		file <- paste(input_trees[i, 1], "/bpp/", ghost_str, "2/time_sum.txt", sep = "")

		# If MCMC 2 has lowESS
		if ( sub("time_sum.txt", "outBpp", file) %in% lowESS && (ghost != 1)) {
		#if ( sub("time_sum.txt", "outBpp", file) %in% lowESS ) {
			next	
		}
	}
		
	result <- as.matrix(read.table(file, header = FALSE))
	tmp <- cbind(matrix(rep(simulations[i, ], dim(result)[1]), byrow = TRUE, nrow = dim(result)[1]), result)
	all_result <- rbind(all_result, tmp)
}

colnames(all_result) <- c(colnames(simulations), "parameter", "mean", "2.5HPD", "97.5HPD")

if ( ghost != 1) {
	write.csv(all_result, "bpp_divergence_sum.csv", quote = FALSE, row.names = FALSE)
} else {
	write.csv(all_result, "bpp_divergence_sum_ghost.csv", quote = FALSE, row.names = FALSE)
}
