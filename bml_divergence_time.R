library(ape)

getTimes <- function(file) {
  tree <- read.tree(file)
  branching.times(tree)

}

input_trees <- read.table("lists/bml_list_tree.txt", header = FALSE)
trees <- unlist(apply(input_trees, 1, strsplit, split = "/"))
trees <- matrix(trees, nrow = nrow(input_trees), byrow =TRUE)

colnames(trees) <-  c("experiment", "topology", "demography", "loci_samples", "theta", "Ne", "rep", "analysis")
trees <- as.data.frame(trees)

# Extract the value of theta and replicate
trees$theta   <- unlist(lapply(trees$theta, substr, start = 6, stop = "11"))
trees$rep     <- unlist(lapply(trees$rep, substr, start = 4, stop = "6"))

# Extract the number of loci and the number of samples
loci_samples <- matrix(unlist(lapply(trees$loci_samples, strsplit, split = "_")), nrow = nrow(input_trees), byrow = TRUE)
trees$loci    <- unlist(lapply(loci_samples[,1], substr, start = 2, stop = 5))
trees$samples <- unlist(lapply(loci_samples[,2], substr, start = 2, stop = 5))

input_trees <- input_trees[, 1]
# Is the tree unbalanced?
unbalanced <- grepl("t_U", input_trees)
head(unbalanced)
head(trees)

times <- matrix(unlist(lapply(input_trees, getTimes)), ncol = 4, byrow = TRUE)
times <- cbind(trees,  times)

times_u <- times[which(unbalanced), ]
colnames(times_u) <- c(colnames(trees), "t_ABCDE", "t_ABCD", "t_ABC", "t_AB")
write.csv(times_u, "baseml_u.csv", quote = FALSE, row.names = FALSE)

times_b <- times[-which(unbalanced), ]
colnames(times_b) <- c(colnames(trees), "t_ABCDE", "t_ABC", "t_AB", "t_DE")
write.csv(times_b, "baseml_b.csv", quote = FALSE, row.names = FALSE)
