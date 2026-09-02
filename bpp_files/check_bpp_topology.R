library(phangorn)
#input_trees <- read.table("lists/bpp_tree_samples_8.txt", header = FALSE)
input_trees <- read.table("lists/bpp_tree.txt", header = FALSE)

simulations <- unlist(apply(input_trees, 1, strsplit, split = "/"))
rm_bpp1 <-which(simulations == "bpp")
simulations <- matrix(simulations[-rm_bpp1], nrow = nrow(input_trees), byrow =TRUE)


colnames(simulations) <-  c("experiment", "topology", "demography", "loci_samples", "theta", "Ne", "rep", "MCMC", "analysis")
simulations <- as.data.frame(simulations)
simulations$theta   <- unlist(lapply(simulations$theta, substr, start = 6, stop = "11"))
simulations$rep     <- unlist(lapply(simulations$rep, substr, start = 4, stop = "6"))

loci_samples <- matrix(unlist(lapply(simulations$loci_samples, strsplit, split = "_")), nrow = nrow(input_trees), byrow = TRUE)
simulations$loci    <- unlist(lapply(loci_samples[,1], substr, start = 2, stop = 5))
simulations$samples <- unlist(lapply(loci_samples[,2], substr, start = 2, stop = 5))

input_trees <- input_trees[, 1]

dist <- rep(NA, length(input_trees))

for (i in seq(from= 1, to = length(input_trees), by = 2)) {
	print(input_trees[i])
  MCMC_1 <- read.tree(input_trees[i])
  MCMC_2 <- read.tree(input_trees[i + 1])
  
  dist[i] <- treedist(MCMC_1, MCMC_2)[1]
}

write.table(input_trees[which(dist != 0)], file = "bpp_files/notTopologyConverged.csv", quote = FALSE, row.names = FALSE, col.names = FALSE)
dist <- dist[-seq(from =2, by =2, to = length(input_trees))]
mean(dist)
head(dist)

table(dist)
