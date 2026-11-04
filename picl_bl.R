results_picl <- read.csv("picl_timesSNP.csv")
results_picl <- results_picl[, 1:13]


results_picl$A <- NA
results_picl$B <- NA
results_picl$C <- NA
results_picl$D <- NA
results_picl$E <- NA
results_picl$AB <- NA
results_picl$ABC <- NA
results_picl$ABCD_DE <- NA


rows_b <- which(results_picl$topology == "t_B")
results_picl$A[rows_b] <- results_picl$t3[rows_b]
results_picl$B[rows_b] <- results_picl$t3[rows_b]
results_picl$C[rows_b] <- results_picl$t2[rows_b]
results_picl$D[rows_b] <- results_picl$t4[rows_b]
results_picl$E[rows_b] <- results_picl$t4[rows_b]
results_picl$AB[rows_b] <- results_picl$t2[rows_b] - results_picl$t3[rows_b]
results_picl$ABC[rows_b] <- results_picl$t1[rows_b] - results_picl$t2[rows_b]
results_picl$ABCD_DE[rows_b] <- results_picl$t1[rows_b] - results_picl$t4[rows_b]

rows_u <- which(results_picl$topology == "t_U")
results_picl$A[rows_u] <- results_picl$t4[rows_u]
results_picl$B[rows_u] <- results_picl$t4[rows_u]
results_picl$C[rows_u] <- results_picl$t3[rows_u]
results_picl$D[rows_u] <- results_picl$t2[rows_u]
results_picl$E[rows_u] <- results_picl$t1[rows_u]
results_picl$AB[rows_u] <- results_picl$t3[rows_u]-results_picl$t4[rows_u]
results_picl$ABC[rows_u] <- results_picl$t2[rows_u]-results_picl$t3[rows_u]
results_picl$ABCD_DE[rows_u] <- results_picl$t1[rows_u]-results_picl$t2[rows_u]

results_picl <- results_picl[, -c(10:13)]

results_picl<- results_picl %>% pivot_longer( cols = 10:17,
                                              names_to = "node",
                                              values_to = "branch_length")

results_picl$loci[which(results_picl$loci == "20000")] <- "40"
results_picl$loci[which(results_picl$loci == "80000")] <- "160"

