library(phangorn)

# Read in list of files
# There is only one tree file for bpp (not one for each MCMC)
input_trees <- read.table("list_tree.txt", header = FALSE)

# Remove MCMCs that did not converge
not_converged <- read.table("notConverged.csv", header = FALSE)[, 1]

simulations <- unlist(apply(input_trees, 1, strsplit, split = "/"))
# Bpp has two additional directories in the path which we don't need to keep
rm_bpp1 <- union(which(simulations == "bpp"), which(simulations == "1"))
simulations <- matrix(simulations[-rm_bpp1], nrow = nrow(input_trees), byrow =TRUE)

colnames(simulations) <-  c("experiment", "topology", "demography", "loci_samples", "theta", "Ne", "rep", "analysis")
simulations <- as.data.frame(simulations)

# Extract the value of theta and replicate
simulations$theta   <- unlist(lapply(simulations$theta, substr, start = 6, stop = "11"))
simulations$rep     <- unlist(lapply(simulations$rep, substr, start = 4, stop = "6"))

# Extract the number of loci and the number of samples
loci_samples <- matrix(unlist(lapply(simulations$loci_samples, strsplit, split = "_")), nrow = nrow(input_trees), byrow = TRUE)
simulations$loci    <- unlist(lapply(loci_samples[,1], substr, start = 2, stop = 5))
simulations$samples <- unlist(lapply(loci_samples[,2], substr, start = 2, stop = 5))

input_trees <- input_trees[, 1]
# Is the tree unbalanced?
unbalanced <- grepl("t_U", input_trees)

# Read in true tree
t_trueU <- read.tree("unbalanced.tre")
t_trueB <- read.tree("balanced.tre")

dist <- rep(NA, length(input_trees))

# For every tree find the RF distance to the true tree
for (i in 1:length(input_trees)) {
  t_infer <- read.tree(input_trees[i])
  rooted_tree <- root(t_infer, outgroup = "O", resolve.root = TRUE)	

  # Double check the labels match
  if ( ! all.equal(t_infer, rooted_tree)) {
	      print("problem")
	      print(i)
	      quit()
  }

  # Skip trees that did not converge
  if (input_trees[i] %in% not_converged){
	 dist[i] <- NA
	 next 
  }

  if (unbalanced[i]) 
  	dist[i] <- treedist(t_infer, t_trueU)[1]
  else 
  	dist[i] <- treedist(t_infer, t_trueB)[1]
}

write.csv(cbind(simulations,dist), "results.csv", quote = FALSE, row.names = FALSE)
