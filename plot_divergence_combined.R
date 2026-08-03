library(tidyr)
library(ggplot2)
library(patchwork)

setwd("~/Ne_MSC")
results_picl <- read.csv("picl_times.csv")



#####
# Format PICL results
results_picl<- results_picl %>% pivot_longer( cols = 10:13, 
                                              names_to = "node", 
                                              values_to = "time")

results_picl$true <- results_picl$theta
row_b <- which(results_picl$topology == "t_B")
rows <- intersect(which(results_picl$node == "t1"), row_b) # root
results_picl$true[rows] <- results_picl$true[rows] * 5
results_picl$node[rows] <- "ABCDE"
rows <- intersect(which(results_picl$node == "t2"), row_b) # ABC
results_picl$true[rows] <- results_picl$true[rows] * 4
results_picl$node[rows] <- "ABC"
rows <- intersect(which(results_picl$node == "t3"), row_b) # AB
results_picl$true[rows] <- results_picl$true[rows] * 3
results_picl$node[rows] <- "AB"
rows <- intersect(which(results_picl$node == "t4"), row_b) # DE
results_picl$true[rows] <- results_picl$true[rows] * 4.5
results_picl$node[rows] <- "DE"

# 
row_u <- which(results_picl$topology == "t_U")
rows <- intersect(which(results_picl$node == "t1"), row_u) # root
results_picl$true[rows] <- results_picl$true[rows] * 5
results_picl$node[rows] <- "ABCDE"
rows <- intersect(which(results_picl$node == "t2"), row_u) # ABCD
results_picl$true[rows] <- results_picl$true[rows] * 4
results_picl$node[rows] <- "ABCD"
rows <- intersect(which(results_picl$node == "t3"), row_u) # ABC
results_picl$true[rows] <- results_picl$true[rows] * 3
results_picl$node[rows] <- "ABC"
rows <- intersect(which(results_picl$node == "t4"), row_u) # AB
results_picl$true[rows] <- results_picl$true[rows] * 2.5
results_picl$node[rows] <- "AB"

# 
results_picl$coverage <- NA
row <- which(results_picl$node == "t1")
results_picl$coverage[row] <- ((results_picl$true > results_picl$t1_2.5) * 
                                 (results_picl$true < results_picl$t1_97.5))[row]
row <- which(results_picl$node == "t2")
results_picl$coverage[row] <- ((results_picl$true > results_picl$t2_2.5) * 
                                 (results_picl$true < results_picl$t2_97.5))[row]
row <- which(results_picl$node == "t3")
results_picl$coverage[row] <- ((results_picl$true > results_picl$t3_2.5) * 
                                 (results_picl$true < results_picl$t3_97.5))[row]
row <- which(results_picl$node == "t4")
results_picl$coverage[row] <- ((results_picl$true > results_picl$t4_2.5) * 
                                 (results_picl$true < results_picl$t4_97.5))[row]

picl_cols <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 18, 19, 20, 21)
picl <- results_picl[, picl_cols]
colnames(picl)[11] <- "mean"
colnames(picl)[10] <- "parameter"
picl$analysis <- "picl"

#####
# Format bpp results
results_bpp <- read.csv("bpp_divergence_sum.csv")
results_bpp$true <- results_bpp$theta
row_b <- which(results_bpp$topology == "t_B")
rows <- intersect(which(results_bpp$parameter == "tau:6"), row_b) # root
results_bpp$true[rows] <- results_bpp$true[rows] * 5
results_bpp$parameter[rows] <- "ABCDE"
rows <- intersect(which(results_bpp$parameter == "tau:7"), row_b) # ABC
results_bpp$true[rows] <- results_bpp$true[rows] * 4
results_bpp$parameter[rows] <- "ABC"
rows <- intersect(which(results_bpp$parameter == "tau:8"), row_b) # AB
results_bpp$true[rows] <- results_bpp$true[rows] * 3
results_bpp$parameter[rows] <- "AB"
rows <- intersect(which(results_bpp$parameter == "tau:9"), row_b) # DE
results_bpp$true[rows] <- results_bpp$true[rows] * 4.5
results_bpp$parameter[rows] <- "DE"


row_u <- which(results_bpp$topology == "t_U")
rows <- intersect(which(results_bpp$parameter == "tau:6"), row_u) # root
results_bpp$true[rows] <- results_bpp$true[rows] * 5
results_bpp$parameter[rows] <- "ABCDE"
rows <- intersect(which(results_bpp$parameter == "tau:7"), row_u) # ABCD
results_bpp$true[rows] <- results_bpp$true[rows] * 4
results_bpp$parameter[rows] <- "ABCD"
rows <- intersect(which(results_bpp$parameter == "tau:8"), row_u) # ABC
results_bpp$true[rows] <- results_bpp$true[rows] * 3
results_bpp$parameter[rows] <- "ABC"
rows <- intersect(which(results_bpp$parameter == "tau:9"), row_u) # AB
results_bpp$true[rows] <- results_bpp$true[rows] * 2.5
results_bpp$parameter[rows] <- "AB"

results_bpp$coverage <- (results_bpp$true < results_bpp$X97.5HPD) * (results_bpp$true > results_bpp$X2.5HPD)
bpp_cols <- c(1, 2, 3, 4, 5, 6, 8, 9, 7, 10, 11, 14, 15)
bpp_rows <- union(grep("theta", results_bpp$parameter), grep("lnL", results_bpp$parameter))
bpp <- results_bpp[-bpp_rows, bpp_cols]
bpp$analysis <- "bpp"

#####
# Format baseml
results_b <- read.csv("baseml_b.csv")
results_u <- read.csv("baseml_u.csv")

long_b <- results_b %>% pivot_longer( cols = 11:14, 
                                      names_to = "node", 
                                      values_to = "time")

long_u <- results_u %>% pivot_longer( cols = 11:14, 
                                      names_to = "node", 
                                      values_to = "time")

long_b$true_time <- long_b$theta 
rows <- which(long_b$node ==    "t_AB")
long_b$true_time[rows] <- long_b$true_time[rows] * 3
long_b$node[rows] <- "AB"
rows <- which(long_b$node ==    "t_ABC")
long_b$true_time[rows] <- long_b$true_time[rows] * 4
long_b$node[rows] <- "ABC"
rows <- which(long_b$node ==    "t_DE")
long_b$true_time[rows] <- long_b$true_time[rows] * 4.5
long_b$node[rows] <- "DE"
rows <- which(long_b$node ==    "t_ABCDE")
long_b$true_time[rows] <- long_b$true_time[rows] * 5
long_b$node[rows] <- "ABCDE"

long_u$true_time <- long_u$theta 
rows <- which(long_u$node ==    "t_AB")
long_u$true_time[rows] <- long_u$true_time[rows] * 2.5
long_u$node[rows] <- "AB"
rows <- which(long_u$node ==    "t_ABC")
long_u$true_time[rows] <- long_u$true_time[rows] * 3
long_u$node[rows] <- "ABC"
rows <- which(long_u$node ==    "t_ABCD")
long_u$true_time[rows] <- long_u$true_time[rows] * 4
long_u$node[rows] <- "ABCD"
rows <- which(long_u$node ==    "t_ABCDE")
long_u$true_time[rows] <- long_u$true_time[rows] * 5
long_u$node[rows] <- "ABCDE"

baseml <- results <- rbind(long_b, long_u)
colnames(baseml)[11] <- "parameter"
colnames(baseml)[12] <- "mean"
colnames(baseml)[13] <- "true"
baseml_col <- c(1, 2, 3, 4, 5, 6, 9, 10, 7, 11, 12, 13)
baseml <- baseml[, baseml_col]
baseml$analysis <- "baseml"
baseml$coverage <- NA
#####
results_comb <- rbind(bpp, picl)
results_comb <- rbind(results_comb, baseml)

results_comb <- results_comb %>%
  mutate(loci_theta= interaction(loci, theta, sep = "_")) 

results_comb$loci_theta <- factor(results_comb$loci_theta,
                             labels=c(expression(atop(paste(loci," = ", 40,),  paste( theta, " = 0.0025"))),
                                      expression(atop(paste(loci," = ", 160,), paste( theta, " = 0.0025"))),
                                      expression(atop(paste(loci," = ", 40,),  paste( theta, " = 0.01"))),
                                      expression(atop(paste(loci," = ", 160,), paste( theta, " = 0.01")))
                             ))


tree_row_B <- grep("B", results_comb$topology)
tree_row_U <- grep("U", results_comb$topology)
 
times_B <- results_comb[tree_row_B, ]
times_B$parameter <- factor(times_B$parameter, levels = c("ABCDE", "DE","ABC", "AB"))

times_U <- results_comb[tree_row_U, ]
times_U$parameter <- factor(times_U$parameter, levels = c("ABCDE", "ABCD", "ABC", "AB"))


samples_1_b <- which(times_B$samples == 1)
samples_1_u <- which(times_U$samples == 1)
samples_8_b <- which(times_B$samples == 8)
samples_8_u <- which(times_U$samples == 8)

tau_b <- ggplot(times_B[samples_1_b, ], aes(x = interaction(Ne, demography), y = mean, fill = parameter)) + 
  geom_hline(data = times_B, aes(yintercept = true, color = parameter), linetype = "dashed", ) +
  geom_violin(position=position_dodge(width = 0.0)) + #, alpha = .6
  facet_grid(loci_theta~analysis, scales = "free", labeller = label_parsed) + 
  scale_x_discrete(
    labels = c(
      "Ne_i.s1" = "constant",
      "Ne_d.s2" = "exponential\nsmaller",
      "Ne_i.s2" = "exponential\nlarger",
      "Ne_d.s3" = "piecewise\nsmaller", 
      "Ne_i.s3" = "piecewise\nlarger"
      
    )
  ) +  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) + 
  labs(fill = "node", x = "", y = "divergence time", color = "node") + 
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), 
        #  plot.margin = margin(b = 3, t = 5, l = 5, r = 5), 
          plot.tag = element_text(face = "bold")) + 
  labs(tag = "a")  

tau_u <- ggplot(times_U[samples_1_u, ], aes(x = interaction(Ne, demography), y = mean, fill = parameter)) + 
  geom_hline(data = times_U, aes(yintercept = true, color = parameter), linetype = "dashed", ) +
  geom_violin(position=position_dodge(width = 0.0)) + #, alpha = .6
  facet_grid(loci_theta~analysis, scales = "free", labeller = label_parsed) + 
  scale_x_discrete(
    labels = c(
      "Ne_i.s1" = "constant",
      "Ne_d.s2" = "exponential\nsmaller",
      "Ne_i.s2" = "exponential\nlarger",
      "Ne_d.s3" = "piecewise\nsmaller", 
      "Ne_i.s3" = "piecewise\nlarger"
      
    )
  ) +  theme_bw() +
  labs(fill = "node", x = "", y = "divergence time", color = "node") + #+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 7.5),
        strip.text.x = element_blank(),       # Removes the text inside the top facet bars
        strip.background.x = element_blank(),   # Optional: Removes the gray background boxes
        plot.tag = element_text(face = "bold"), 
  ) +   labs(tag = "b") 

scale <- 1
pdf("~/Ne_MSC_write/manuscript/figs/divergence_time_1.pdf", width = 8 * scale, height = 10 * scale)
tau_b/tau_u & theme(plot.margin = margin(0, 0, -20, 0, "pt"))
dev.off()

tau_b <- ggplot(times_B[samples_8_b, ], aes(x = interaction(Ne, demography), y = mean, fill = parameter)) + 
  geom_hline(data = times_B[samples_8_b, ], aes(yintercept = true, color = parameter), linetype = "dashed", ) +
  geom_violin(position=position_dodge(width = 0.0)) + #, alpha = .6
  facet_grid(loci_theta~analysis, scales = "free", labeller = label_parsed) + 
  scale_x_discrete(
    labels = c(
      "Ne_i.s1" = "constant",
      "Ne_d.s2" = "exponential\nsmaller",
      "Ne_i.s2" = "exponential\nlarger",
      "Ne_d.s3" = "piecewise\nsmaller", 
      "Ne_i.s3" = "piecewise\nlarger"
      
    )
  ) +  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) + 
  labs(fill = "node", x = "", y = "divergence time", color = "node") + 
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), 
        plot.margin = margin(b = 3, t = 5, l = 5, r = 5), 
        plot.tag = element_text(face = "bold")) + 
  labs(tag = "a")  

tau_u <- ggplot(times_U[samples_8_u, ], aes(x = interaction(Ne, demography), y = mean, fill = parameter)) + 
  geom_hline(data = times_U[samples_8_u, ], aes(yintercept = true, color = parameter), linetype = "dashed", ) +
  geom_violin(position=position_dodge(width = 0.0)) + #, alpha = .6
  facet_grid(loci_theta~analysis, scales = "free", labeller = label_parsed) + 
  scale_x_discrete(
    labels = c(
      "Ne_i.s1" = "constant",
      "Ne_d.s2" = "exponential\nsmaller",
      "Ne_i.s2" = "exponential\nlarger",
      "Ne_d.s3" = "piecewise\nsmaller", 
      "Ne_i.s3" = "piecewise\nlarger"
      
    )
  ) +  theme_bw() +
  labs(fill = "node", x = "", y = "divergence time", color = "node") + #+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 7.5),
        strip.text.x = element_blank(),       # Removes the text inside the top facet bars
        strip.background.x = element_blank(),   # Optional: Removes the gray background boxes
        plot.tag = element_text(face = "bold")
  ) +   labs(tag = "b")

scale <- 1
pdf("~/Ne_MSC_write/manuscript/figs/divergence_time_8.pdf", width = 6 * scale, height = 10 * scale)
tau_b/tau_u & theme(plot.margin = margin(0, 0, -20, 0, "pt"))
dev.off()

