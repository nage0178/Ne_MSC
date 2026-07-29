library(phangorn)

# Get RF distance between species tree and gene tree 
check_dist <- function(input_tree, true_tree=rooted_tree) {
  t_infer <- read.tree(input_tree)

  return (treedist(t_infer, true_tree)[1])
}

# For each tree topology
for (tree_top in c("u", "b")) {

	# Read in table with names of all simulated gene trees
	input_trees <- read.table(paste("lists/", tree_top, "_list_gtree.txt", sep = ""), header = FALSE)
	input_trees <- input_trees[, 1]

	# Read in the tree, get the RF distance
	gtree <- read.tree(paste("gtree_", tree_top, ".tre", sep = ""))
	dist  <- unlist(lapply(input_trees, check_dist, true_tree=gtree))

	simulations <- matrix(unlist(lapply(input_trees, strsplit, split = "/")), nrow = length(input_trees), byrow =TRUE)

	colnames(simulations) <-  c("experiment", "topology", "demography", "loci_samples", "theta", "Ne", "rep", "analysis", "locus")
	simulations         <- as.data.frame(simulations)
	simulations$theta   <- unlist(lapply(simulations$theta, substr, start = 6, stop = "11"))
	simulations$rep     <- unlist(lapply(simulations$rep, substr, start = 4, stop = "6"))
	
	loci_samples        <- matrix(unlist(lapply(simulations$loci_samples, strsplit, split = "_")), nrow = length(input_trees), byrow = TRUE)
	simulations$loci    <- unlist(lapply(loci_samples[,1], substr, start = 2, stop = 5))
	simulations$samples <- unlist(lapply(loci_samples[,2], substr, start = 2, stop = 5))
	summary <- cbind(simulations,dist)
	
	# Write distribute to a table
	write.csv(summary, paste(tree_top, "_gtree_dist.csv", sep = ""), quote = FALSE, row.names = FALSE)

}

