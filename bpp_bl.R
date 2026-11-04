# Add bpp results
results_bpp <- read.csv("bpp_divergence_sum.csv")
results_bpp$true <- results_bpp$theta
row_b <- which(results_bpp$topology == "t_B")
row <- intersect(which(results_bpp$parameter == "tau:6"), row_b) # root
#results_bpp$true[row] <- results_bpp$true[row] * 5
results_bpp$parameter[row] <- "ABCDE"
row <- intersect(which(results_bpp$parameter == "tau:7"), row_b) # ABC
#results_bpp$true[row] <- results_bpp$true[row] * 4
results_bpp$parameter[row] <- "ABC"
row <- intersect(which(results_bpp$parameter == "tau:8"), row_b) # AB
#results_bpp$true[row] <- results_bpp$true[row] * 3
results_bpp$parameter[row] <- "AB"
row <- intersect(which(results_bpp$parameter == "tau:9"), row_b) # DE
#results_bpp$true[row] <- results_bpp$true[row] * 4.5
results_bpp$parameter[row] <- "DE"


row_u <- which(results_bpp$topology == "t_U")
row <- intersect(which(results_bpp$parameter == "tau:6"), row_u) # root
#results_bpp$true[row] <- results_bpp$true[row] * 5
results_bpp$parameter[row] <- "ABCDE"
row <- intersect(which(results_bpp$parameter == "tau:7"), row_u) # ABCD
#results_bpp$true[row] <- results_bpp$true[row] * 4
results_bpp$parameter[row] <- "ABCD"
row <- intersect(which(results_bpp$parameter == "tau:8"), row_u) # ABC
#results_bpp$true[row] <- results_bpp$true[row] * 3
results_bpp$parameter[row] <- "ABC"
row <- intersect(which(results_bpp$parameter == "tau:9"), row_u) # AB
#results_bpp$true[row] <- results_bpp$true[row] * 2.5
results_bpp$parameter[row] <- "AB"

bpp_row <- union(grep("theta", results_bpp$parameter), grep("lnL", results_bpp$parameter))
bpp <- results_bpp[-bpp_row, -c(12, 13, 14)]



wide_data <- bpp %>%
  pivot_wider(
    names_from = parameter, 
    values_from = mean
  )

row_b <- which(wide_data$topology == "t_B")
row_u <- which(wide_data$topology == "t_U")


wide_data$b_A <- wide_data$AB
wide_data$b_B <- wide_data$AB
wide_data$b_C <- wide_data$ABC
wide_data$b_D <-NA
wide_data$b_D[row_u] <- wide_data$ABCD[row_u]
wide_data$b_D[row_b] <- wide_data$DE[row_b] 
wide_data$b_E <-NA
wide_data$b_E[row_u] <- wide_data$ABCDE[row_u]
wide_data$b_E[row_b] <- wide_data$DE[row_b]

wide_data$b_AB <- wide_data$ABC - wide_data$AB
wide_data$b_ABC <-NA
wide_data$b_ABC[row_u] <- wide_data$ABCD[row_u] - wide_data$ABC[row_u]
wide_data$b_ABCDDE <-NA
wide_data$b_ABCDDE[row_u] <- wide_data$ABCDE[row_u] - wide_data$ABCD[row_u]

wide_data$b_ABC[row_b] <- wide_data$ABCDE[row_b] - wide_data$ABC[row_b]
wide_data$b_ABCDDE[row_b] <- wide_data$ABCDE[row_b] - wide_data$DE[row_b]

wide_data <- wide_data[, -c(10:14)]
colnames(wide_data)[10:17] <- unlist(lapply(strsplit(colnames(wide_data)[10:17], "_"), function(x) x[2]))
colnames(wide_data)[17] <- "ABCD_DE"

long_bl <- wide_data %>% pivot_longer( cols = 10:17,
                                       names_to = "node",
                                       values_to = "branch_length")
long_bl <- long_bl[, c(1,2, 3, 4, 5, 6, 8, 9, 7, 10, 11)]
