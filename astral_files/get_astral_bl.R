library(ape)

get_bl <- function(dir) {
	rep <- 50
	bl <- matrix(NA, nrow = rep, ncol = 9)
	for (i in c(1:rep)) {
		file <- paste(dir,"/rep", i, "/astral.tre", sep = "")
		if (! file.exists(file)) {
			print(file)
			next	
		}

		tree <- read.tree(file)

		tipBl <- get_bl_tip(tree)
		tB <- grepl("t_B", file)

		if (tB)
			intBl <- get_bl_b(tree)
		else
			intBl <- get_bl_u(tree)
		bl[i, ] <- c(tipBl, intBl)

	}
	return (bl)
}

get_bl_u <- function(tree) {

	intLength <- rep(NA, 4)
	edges <- list(c("A", "B"),
		      c("A", "B", "C"),
		      c("C", "D"),
		      c("A", "B", "C", "D", "E"))
	for (i in 1:length(edges)) {
		index <- getMRCA(tree, edges[[i]])
		bl_index <- which(tree$edge[,2] == index)
		intLength[i] <- tree$edge.length[bl_index]
	}

	return (intLength)
}

get_bl_b <- function(tree) {

	intLength <- rep(NA, 4)
	edges <- list(c("A", "B"),
		      c("A", "B", "C"),
		      c("D", "E"),
		      c("A", "B", "C", "D", "E"))
	for (i in 1:length(edges)) {
		index <- getMRCA(tree, edges[[i]])
		bl_index <- which(tree$edge[,2] == index)
		intLength[i] <- tree$edge.length[bl_index]
	}

	return (intLength)
}

get_bl_tip <- function(tree) {
	tipLength <- rep(NA, 5)
	tips <- c("A", "B", "C", "D", "E")
	for (i in 1:length(tips)) {
		index <- which(tree$tip.label == tips[i])
		bl_index <- which(tree$edge[,2] == index)
		tipLength[i] <- tree$edge.length[bl_index]
	}

	return (tipLength)
}

# Change
dir <- "lists/astral_bl"
output <- "astral_bl.csv"

rep <- 50
directories <- read.table(dir, header = FALSE)

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
trees$loci    <- unlist(lapply(loci_samples[,1], substring, first = 2))
trees$samples <- unlist(lapply(loci_samples[,2], substr, start = 2, stop = 5))

# Add the replicates
trees$rep <- c(1:rep)

directories <- directories[, 1]

# Get the branch lengths
bl <- do.call(rbind, lapply(directories, get_bl))
colnames(bl) <- c("A", "B", "C", "D", "E", "AB", "ABC", "ABCD_DE", "ABCDE")

write.csv(cbind(trees, bl), output, row.names = FALSE, quote = FALSE)
