results_ghost <- read.csv("bpp_divergence_sum_ghost.csv")

results_ghost$true <- results_ghost$theta
results_ghost$node <- NA
row_b <- intersect(which(results_ghost$topology == "t_B"), which(results_ghost$samples == 1))
rows <- intersect(which(results_ghost$parameter == "tau:8"), row_b) # root
results_ghost$true[rows] <- results_ghost$true[rows] * 5
results_ghost$node[rows] = "ABCDE"
rows <- intersect(which(results_ghost$parameter == "tau:9"), row_b) # ABC
results_ghost$true[rows] <- results_ghost$true[rows] * 4
results_ghost$node[rows] = "ABC"
rows <- intersect(which(results_ghost$parameter == "tau:10"), row_b) # AB
results_ghost$true[rows] <- results_ghost$true[rows] * 3
results_ghost$node[rows] = "AB"
rows <- intersect(which(results_ghost$parameter == "tau:11"), row_b) # DE
results_ghost$true[rows] <- results_ghost$true[rows] * (4.5 + (.5 * 2 / 3))
rows <- intersect(which(results_ghost$parameter == "tau:12"), row_b) # DE
results_ghost$true[rows] <- results_ghost$true[rows] * (4.5 + (.5 * 1/3))
rows <- intersect(which(results_ghost$parameter == "tau:13"), row_b) # DE
results_ghost$true[rows] <- results_ghost$true[rows] * 4.5
results_ghost$node[rows] = "DE"

row_b <- intersect(which(results_ghost$topology == "t_B"), which(results_ghost$samples == 8))
rows <- intersect(which(results_ghost$parameter == "tau:10"), row_b) # root
results_ghost$true[rows] <- results_ghost$true[rows] * 5
results_ghost$node[rows] = "ABCDE"
rows <- intersect(which(results_ghost$parameter == "tau:11"), row_b) # ABC
results_ghost$true[rows] <- results_ghost$true[rows] * 4
results_ghost$node[rows] = "ABC"
rows <- intersect(which(results_ghost$parameter == "tau:12"), row_b) # AB
results_ghost$true[rows] <- results_ghost$true[rows] * 3
results_ghost$node[rows] = "AB"
rows <- intersect(which(results_ghost$parameter == "tau:13"), row_b) # AB
results_ghost$true[rows] <- results_ghost$true[rows] * 2
rows <- intersect(which(results_ghost$parameter == "tau:14"), row_b) # AB
results_ghost$true[rows] <- results_ghost$true[rows] * 1
rows <- intersect(which(results_ghost$parameter == "tau:15"), row_b) # DE
results_ghost$true[rows] <- results_ghost$true[rows] * (4.5 + (.5 * 2 / 3))
rows <- intersect(which(results_ghost$parameter == "tau:16"), row_b) # DE
results_ghost$true[rows] <- results_ghost$true[rows] * (4.5 + (.5 * 1/3))
rows <- intersect(which(results_ghost$parameter == "tau:17"), row_b) # DE
results_ghost$true[rows] <- results_ghost$true[rows] * 4.5
results_ghost$node[rows] = "DE"


row_u <- intersect(which(results_ghost$topology == "t_U"), which(results_ghost$samples == 1))
rows <- intersect(which(results_ghost$parameter == "tau:8"), row_u) # root
results_ghost$true[rows] <- results_ghost$true[rows] * 5
results_ghost$node[rows] = "ABCDE"
rows <- intersect(which(results_ghost$parameter == "tau:9"), row_u) # ABCDG1G2
results_ghost$true[rows] <- results_ghost$true[rows] * 4.67
rows <- intersect(which(results_ghost$parameter == "tau:10"), row_u) # ABCDG1
results_ghost$true[rows] <- results_ghost$true[rows] * 4.33
rows <- intersect(which(results_ghost$parameter == "tau:11"), row_u) # ABCD
results_ghost$true[rows] <- results_ghost$true[rows] * 4
results_ghost$node[rows] = "ABCD"
rows <- intersect(which(results_ghost$parameter == "tau:12"), row_u) # ABC
results_ghost$true[rows] <- results_ghost$true[rows] * 3
results_ghost$node[rows] = "ABC"
rows <- intersect(which(results_ghost$parameter == "tau:13"), row_u) # AB
results_ghost$true[rows] <- results_ghost$true[rows] * 2.5
results_ghost$node[rows] = "AB"

row_u <- intersect(which(results_ghost$topology == "t_U"), which(results_ghost$samples == 8))
rows <- intersect(which(results_ghost$parameter == "tau:10"), row_u) # root
results_ghost$true[rows] <- results_ghost$true[rows] * 5
results_ghost$node[rows] = "ABCDE"
rows <- intersect(which(results_ghost$parameter == "tau:11"), row_u) # ABCDG1G2
results_ghost$true[rows] <- results_ghost$true[rows] * 4.67
rows <- intersect(which(results_ghost$parameter == "tau:12"), row_u) # ABCDG1
results_ghost$true[rows] <- results_ghost$true[rows] * 4.33
rows <- intersect(which(results_ghost$parameter == "tau:13"), row_u) # ABCD
results_ghost$true[rows] <- results_ghost$true[rows] * 4
results_ghost$node[rows] = "ABCD"
rows <- intersect(which(results_ghost$parameter == "tau:14"), row_u) # ABC
results_ghost$true[rows] <- results_ghost$true[rows] * 3
results_ghost$node[rows] = "ABC"
rows <- intersect(which(results_ghost$parameter == "tau:15"), row_u) # AB
results_ghost$true[rows] <- results_ghost$true[rows] * 2.5
results_ghost$node[rows] = "AB"
rows <- intersect(which(results_ghost$parameter == "tau:16"), row_u) # ABG1G2
results_ghost$true[rows] <- results_ghost$true[rows] * 2.5 * 2/3
rows <- intersect(which(results_ghost$parameter == "tau:17"), row_u) # ABG1
results_ghost$true[rows] <- results_ghost$true[rows] * 2.5/3

results_ghost$coverage <- (results_ghost$true < results_ghost$X97.5HPD) * (results_ghost$true > results_ghost$X2.5HPD)
results_ghost$CI_size <- results_ghost$X97.5HPD-results_ghost$X2.5HPD

results_ghost_time <- results_ghost[which(! is.na(results_ghost$node)), ]
results_ghost_col <- c(1, 2, 3, 4, 5, 6, 8, 9, 7, 15, 11, 14, 16, 17, 12, 13)
results_ghost_rename <- results_ghost[, results_ghost_col]
colnames(results_ghost_rename)[10] <- "parameter"
results_ghost_rename$analysis <- "ghost"
results_ghost_rename <- results_ghost_rename[ which(! is.na(results_ghost_rename$parameter)), ]

