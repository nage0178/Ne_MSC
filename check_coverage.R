library(phangorn)
library(stringr)
library(dplyr)

# Read in list of files
# There is only one tree file for bpp (not one for each MCMC)
input_files <- read.table("lists/cov_bpp.txt", header = FALSE)

# Remove MCMCs that did not converge
not_converged <- read.table("bpp_files/notTopologyConverged.csv", header = FALSE)[, 1]

simulations <- unlist(apply(input_files, 1, strsplit, split = "/"))
# Bpp has two additional directories in the path which we don't need to keep
rm_bpp1 <- union(which(simulations == "bpp"), which(simulations == "1"))

simulations <- matrix(simulations[-rm_bpp1], nrow = nrow(input_files), byrow =TRUE)

colnames(simulations) <-  c("experiment", "topology", "demography", "loci_samples", "theta", "Ne", "rep", "analysis")
simulations <- as.data.frame(simulations)

# Extract the value of theta and replicate
simulations$theta   <- unlist(lapply(simulations$theta, substr, start = 6, stop = "11"))
simulations$rep     <- unlist(lapply(simulations$rep, substr, start = 4, stop = "6"))

# Extract the number of loci and the number of samples
loci_samples <- matrix(unlist(lapply(simulations$loci_samples, strsplit, split = "_")), nrow = nrow(input_files), byrow = TRUE)
simulations$loci    <- unlist(lapply(loci_samples[,1], substring, first = 2))
simulations$samples <- unlist(lapply(loci_samples[,2], substr, start = 2, stop = 5))

input_files <- input_files[, 1]
# Is the tree unbalanced?
unbalanced <- grepl("t_U", input_files)

# Read in true tree
t_trueU <- read.tree("trees/unbalanced_noO.tre")
t_trueB <- read.tree("trees/balanced_noO.tre")

simulations$coverage <- rep(NA, length(input_files))

check_cov <- function(file, true_tree) {
	total_prob <- 0 
	tree_found <- 0 
	for (i in 1:dim(file)[1]) {

		tree <- read.tree(text = file$tree[i])
		same <- all.equal(tree, true_tree, use.edge.length = FALSE)

		# The MAP tree has greater than .95 posterior probability
		if (i == 1 & file[i,2] > 0.95) {
			return (same)
		# The correct tree is in the 95% credible set, we don't have to keep looking
		} else if (file[i, 3] < 0.95 && same)  {
			return (same)	
		} else if (file[i, 3] > 0.95 && same)  {
			print(i)
			# The fraction is the proportion of the probability of the tree that is over 0.95
			# the second column is the probability of the tree. 
			# The third column is the cumulative probability
			print(file)
			
			print(1 - ((file[i, 3]- 0.95) / file[i, 2]))
			return(1 - ((file[i, 3]- 0.95) / file[i, 2]))
		} else if (file[i,3] > 0.95) {
			return (same)
		}

	}
		print(paste("not found", same))
	return (same)
}

# For every tree find the RF distance to the true tree
for (i in 1:length(input_files)) {

  tree_table <- read.table(input_files[i])
  tree_table$tree <- (apply(tree_table[, 4:8], 1, function(x) paste(x[1], x[2], x[3], x[4], x[5])))



  tree_file <- paste(str_sub(input_files[i], end = -14), "MAP.txt", sep = "")
  # Skip trees that did not converge

  if (tree_file %in% not_converged){
         simulations$coverage[i] <- NA
         next 
  }

  if (unbalanced[i]) 
  	simulations$coverage[i] <- check_cov(tree_table, t_trueU)
  else 
  	simulations$coverage[i] <- check_cov(tree_table, t_trueB)
}

simulations$topology[which(simulations$topology == "t_U")] <- "unbalanced"
simulations$topology[which(simulations$topology == "t_B")] <- "balanced"
simulations$demographic_model <- NA
simulations$demographic_model[intersect(which(simulations$demography  == "s1"), which(simulations$Ne == "Ne_i"))] <- "constant"
simulations$demographic_model[intersect(which(simulations$demography  == "s2"), which(simulations$Ne == "Ne_i"))] <- "exponential larger"
simulations$demographic_model[intersect(which(simulations$demography  == "s2"), which(simulations$Ne == "Ne_d"))] <- "exponential smaller"
simulations$demographic_model[intersect(which(simulations$demography  == "s3"), which(simulations$Ne == "Ne_i"))] <- "piecewise larger"
simulations$demographic_model[intersect(which(simulations$demography  == "s3"), which(simulations$Ne == "Ne_d"))] <- "piecewise smaller"

cov_summary <- simulations %>%
  group_by(topology,theta,  demographic_model, loci, samples) %>%
  summarize(mean_cov = mean(coverage, na.rm = TRUE))

colnames(cov_summary)[6] <- "coverage"
colnames(cov_summary)[3] <- "demographic model"
cov_summary$coverage <- round(cov_summary$coverage, digits = 3)
write.csv(cov_summary, "results_cov.csv", quote = FALSE, row.names = FALSE)
