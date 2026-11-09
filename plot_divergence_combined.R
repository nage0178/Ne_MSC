library(tidyr)
library(ggplot2)
library(patchwork)
library(dplyr)

setwd("~/Ne_MSC")

#####
# Format PICL results

results_picl <- read.csv("picl_timesSNP.csv")
results_picl2 <- read.csv("picl_timesSNP_estTheta.csv")
results_picl$analysis <- "PICL"
results_picl2$analysis <- "PICL_est"
results_picl <- rbind(results_picl, results_picl2)

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

results_picl$CI_size <- NA
row <- which(results_picl$node == "t1")
results_picl$CI_size [row] <- (results_picl$t1_97.5 -results_picl$t1_2.5) [row]
row <- which(results_picl$node == "t2")
results_picl$CI_size [row] <- (results_picl$t2_97.5 -results_picl$t2_2.5) [row]
row <- which(results_picl$node == "t3")
results_picl$CI_size [row] <- (results_picl$t3_97.5 -results_picl$t3_2.5) [row]
row <- which(results_picl$node == "t4")
results_picl$CI_size [row] <- (results_picl$t4_97.5 -results_picl$t4_2.5) [row]

results_picl$X2.5HPD <- NA
row <- which(results_picl$node == "t1")
results_picl$X2.5HPD [row] <- (results_picl$t1_2.5) [row]
row <- which(results_picl$node == "t2")
results_picl$X2.5HPD [row] <- (results_picl$t2_2.5) [row]
row <- which(results_picl$node == "t3")
results_picl$X2.5HPD [row] <- (results_picl$t3_2.5) [row]
row <- which(results_picl$node == "t4")
results_picl$X2.5HPD [row] <- (results_picl$t4_2.5) [row]

results_picl$X97.5HPD <- NA
row <- which(results_picl$node == "t1")
results_picl$X97.5HPD [row] <- (results_picl$t1_97.5) [row]
row <- which(results_picl$node == "t2")
results_picl$X97.5HPD [row] <- (results_picl$t2_97.5) [row]
row <- which(results_picl$node == "t3")
results_picl$X97.5HPD [row] <- (results_picl$t3_97.5) [row]
row <- which(results_picl$node == "t4")
results_picl$X97.5HPD [row] <- (results_picl$t4_97.5) [row]


picl_cols <- c(1, 2, 3, 4, 5, 6, 7, 8, 9, 19, 20, 21, 22, 23, 24, 25, 18)
picl <- results_picl[, picl_cols]
colnames(picl)[11] <- "mean"
colnames(picl)[10] <- "parameter"

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
results_bpp$CI_size <- results_bpp$X97.5HPD-results_bpp$X2.5HPD

bpp_cols <- c(1, 2, 3, 4, 5, 6, 8, 9, 7, 10, 11, 14, 15, 16, 12, 13)
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
baseml$CI_size <- NA
baseml$X2.5HPD<- NA
baseml$X97.5HPD<- NA


#####
source("relabel_ghost.R")

#####
results_comb <- rbind(bpp, baseml)
results_comb <- rbind(results_comb, picl)
results_comb <- rbind(results_comb, results_ghost_rename)

#####
results_cov<- rbind(bpp, results_ghost_rename)

results_cov <- results_cov %>%
  mutate(loci_theta= interaction(loci, theta, sep = "_")) 

demo_labels <- c(
  "Ne_i.s1" = "constant",
  "Ne_d.s2" = "exponential\nsmaller",
  "Ne_i.s2" = "exponential\nlarger",
  "Ne_d.s3" = "piecewise\nsmaller", 
  "Ne_i.s3" = "piecewise\nlarger"
  
)

tree_row_B <- grep("B", results_cov$topology)
tree_row_U <- grep("U", results_cov$topology)

times_B <- results_cov[tree_row_B, ]
times_B$parameter <- factor(times_B$parameter, levels = c("ABCDE", "DE","ABC", "AB"))

times_U <- results_cov[tree_row_U, ]
times_U$parameter <- factor(times_U$parameter, levels = c("ABCDE", "ABCD", "ABC", "AB"))


times_U$loci_theta <- factor(times_U$loci_theta,
                             labels=c(expression(atop(paste(loci," = ", 40,),  paste( theta, " = 0.0025"))),
                                      expression(atop(paste(loci," = ", 160,), paste( theta, " = 0.0025"))),
                                      expression(atop(paste(loci," = ", 40,),  paste( theta, " = 0.01"))),
                                      expression(atop(paste(loci," = ", 160,), paste( theta, " = 0.01")))
                             ))
times_B$loci_theta <- factor(times_B$loci_theta,
                             labels=c(expression(atop(paste(loci," = ", 40,),  paste( theta, " = 0.0025"))),
                                      expression(atop(paste(loci," = ", 160,), paste( theta, " = 0.0025"))),
                                      expression(atop(paste(loci," = ", 40,),  paste( theta, " = 0.01"))),
                                      expression(atop(paste(loci," = ", 160,), paste( theta, " = 0.01")))
                             ))


times_U_cov <- times_U %>%
  mutate(analysis_samples= interaction(analysis, samples, sep = "_")) 
times_U_cov$analysis_samples<- factor(times_U_cov$analysis_samples,
                                      labels=c(expression(atop("bpp",   "1 sample")),
                                               expression(atop("bpp ghost", "1 sample")),
                                               expression(atop("bpp",   "8 samples")),
                                               expression(atop("bpp ghost", "8 samples"))
                                      ))


times_B_cov <- times_B %>%
  mutate(analysis_samples= interaction(analysis, samples, sep = "_")) 
times_B_cov$analysis_samples<- factor(times_B_cov$analysis_samples,
                                      labels=c(expression(atop("bpp",   "1 sample")),
                                               expression(atop("bpp ghost", "1 sample")),
                                               expression(atop("bpp",   "8 samples")),
                                               expression(atop("bpp ghost", "8 samples"))
                                      ))



cov_b <- ggplot(times_B_cov, aes(x = interaction(Ne, demography), y = coverage, fill = parameter)) + 
  geom_bar(stat = "summary", fun = "mean", position = position_dodge()) + #, alpha = .6
  facet_grid(loci_theta~analysis_samples, scales = "free", labeller = label_parsed, space = "free_x") +
  geom_hline(yintercept = .95,  linetype = "dashed", ) +
  scale_x_discrete(
    labels = demo_labels
  ) +  theme_bw() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), 
        plot.tag = element_text(face = "bold")) + 
  labs(fill = "balanced\ntree node", x = "", y = "divergence time coverage") + 
  labs(tag = "a")  
 

cov_u <- ggplot(times_U_cov, aes(x = interaction(Ne, demography), y = coverage, fill = parameter)) + 
  geom_bar(stat = "summary", fun = "mean", position = position_dodge()) + #, alpha = .6
  facet_grid(loci_theta~analysis_samples, scales = "free", labeller = label_parsed, space = "free_x") +
  geom_hline(yintercept = .95,  linetype = "dashed", ) +
  scale_x_discrete(
    labels = demo_labels
  ) +  theme_bw() +
  labs(fill = "unbalanced\ntree node", x = "", y = "divergence time coverage") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.4, hjust = -0,  size = 7.5),
        strip.text.x = element_blank(),       # Removes the text inside the top facet bars
        strip.background.x = element_blank(),   # Optional: Removes the gray background boxes
        plot.tag = element_text(face = "bold"), 
  ) +   labs(tag = "b") 

pdf("~/Ne_MSC_write/manuscript/figs/bpp_ghost_cov_both.pdf", width = 9, height = 8)
cov_b/cov_u & theme(plot.margin = margin(0, 0, -10, 0, "pt"))
dev.off()

#####

results_comb$analysis[which(results_comb$analysis=="ghost")] <- 'bpp ghost'

results_comb <- results_comb %>%
  mutate(loci_theta= interaction(loci, theta, sep = "_"))

results_comb$loci_theta[which(results_comb$loci_theta == "20000_0.0025")] <- "40_0.0025"
results_comb$loci_theta[which(results_comb$loci_theta == "20000_0.01")] <- "40_0.01"
results_comb$loci_theta[which(results_comb$loci_theta == "80000_0.0025")] <- "160_0.0025"
results_comb$loci_theta[which(results_comb$loci_theta == "80000_0.01")] <- "160_0.01"
results_comb$loci_theta <- factor(results_comb$loci_theta)

results_comb$loci_theta <- factor(
  results_comb$loci_theta,
  labels = c(
    "loci = 40<br>sites = 20000<br>&theta; = 0.0025",
    "loci = 160<br>sites = 80000<br>&theta; = 0.0025",
    "loci = 40<br>sites = 20000<br>&theta; = 0.01",
    "loci = 160<br>sites = 80000<br>&theta; = 0.01"
  )
)

# Reorder analyses
results_comb$analysis <- factor(results_comb$analysis)
results_comb <- results_comb %>%mutate(analysis = fct_relevel(analysis, c("bpp", 'bpp ghost', "PICL", "PICL_est", "baseml")))

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
  geom_hline(data = times_B[samples_1_b, ], aes(yintercept = true, color = parameter), linetype = "dashed", ) +
  geom_violin(position=position_dodge(width = 0.0)) + #, alpha = .6
  facet_grid(loci_theta~analysis, scales = "free", space = "free_x") + 
  scale_x_discrete(labels = demo_labels ) +  
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1), 
        strip.text.y = ggtext::element_markdown(
          angle = 270,
          lineheight = 1.1
        ), 
       ) + 
  labs(fill = "balanced\ntree node", x = "", y = "divergence time", color = "balanced\ntree node") + 
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), 
          plot.tag = element_text(face = "bold")) + 
  labs(tag = "a")  

tau_u <- ggplot(times_U[samples_1_u, ], aes(x = interaction(Ne, demography), y = mean, fill = parameter)) + 
  geom_hline(data = times_U[samples_1_u, ], aes(yintercept = true, color = parameter), linetype = "dashed", ) +
  geom_violin(position=position_dodge(width = 0.0)) + #, alpha = .6
  facet_grid(loci_theta~analysis, scales = "free", space = "free_x") + 
  scale_x_discrete(labels = demo_labels ) +  
  theme_bw() +
  labs(fill = "unbalanced\ntree node", x = "", y = "divergence time", color = "unbalanced\ntree node") +  
  theme(axis.text.x = element_text(angle = 90, vjust = 0.4, hjust =0,  size = 7.5),
        strip.text.x = element_blank(),       # Removes the text inside the top facet bars
        strip.background.x = element_blank(),   # Optional: Removes the gray background boxes
        plot.tag = element_text(face = "bold"), 
        strip.text.y = ggtext::element_markdown(
          angle = 270,
          lineheight = 1.1
        ), 
  ) +   labs(tag = "b") 
 
p <- tau_b/tau_u & theme(plot.margin = margin(0, 0, -10, 0, "pt"))
ggsave(
  "~/Ne_MSC_write/manuscript/figs/divergence_time_1.pdf",
  plot = p,
  device = cairo_pdf,
  width = 8,
  height = 10
)

times_B$analysis <- factor(
  times_B$analysis,
  labels = c(
    "bpp",
    "bpp ghost",
    "PICL", 
    "PICL est. &theta;", 
    "baseml"
  )
)

tau_b <- ggplot(times_B[samples_8_b, ], aes(x = interaction(Ne, demography), y = mean, fill = parameter)) + 
  geom_hline(data = times_B[samples_8_b, ], aes(yintercept = true, color = parameter), linetype = "dashed", ) +
  geom_violin(position=position_dodge(width = 0.0)) + #, alpha = .6
  facet_grid(loci_theta~analysis, scales = "free", space = "free_x") + 
  scale_x_discrete(labels = demo_labels ) +  
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) + 
  labs(fill = "balanced\ntree node", x = "", y = "divergence time", color = "balanced\ntree node") + 
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), 
        plot.margin = margin(b = 3, t = 5, l = 5, r = 5), 
        plot.tag = element_text(face = "bold"), 
        strip.text.y = ggtext::element_markdown(
          angle = 270,
          lineheight = 1.1
        ), strip.text.x = ggtext::element_markdown(
          lineheight = 1.1
        )) + 
  labs(tag = "a")  

tau_u <- ggplot(times_U[samples_8_u, ], aes(x = interaction(Ne, demography), y = mean, fill = parameter)) + 
  geom_hline(data = times_U[samples_8_u, ], aes(yintercept = true, color = parameter), linetype = "dashed", ) +
  geom_violin(position=position_dodge(width = 0.0)) + #, alpha = .6
  facet_grid(loci_theta~analysis, scales = "free", space = "free_x") + 
  scale_x_discrete(labels = demo_labels ) +  
  theme_bw() +
  labs(fill = "unbalanced\ntree node", x = "", y = "divergence time", color = "unbalanced\ntree node") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.4, hjust = -0,  size = 7.5),

        strip.text.x = element_blank(),       # Removes the text inside the top facet bars
        strip.background.x = element_blank(),   # Optional: Removes the gray background boxes
        plot.tag = element_text(face = "bold"), 
        strip.text.y = ggtext::element_markdown(
          angle = 270,
          lineheight = 1.1
        )
  ) +   labs(tag = "b")

p <- tau_b/tau_u & theme(plot.margin = margin(0, 0, -10, 0, "pt"))
ggsave(
  "~/Ne_MSC_write/manuscript/figs/divergence_time_8.pdf",
  plot = p,
  device = cairo_pdf,
  width =8,
  height = 10
)

bpp_only <- union(which(times_B$analysis == "bpp"), which(times_B$analysis == "bpp ghost"))

tau_b <- ggplot(times_B[intersect(samples_8_b, bpp_only), ], aes(x = interaction(Ne, demography), y = CI_size, fill = parameter)) + 
  geom_violin() +
  facet_grid(loci_theta~analysis, scales = "free", space = "free_x") + 
  scale_x_discrete(labels = demo_labels ) +  
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) + 
  labs(fill = "balanced\ntree node", x = "", y = "divergence time", color = "balanced\ntree node") + 
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), 
        plot.margin = margin(b = 3, t = 5, l = 5, r = 5), 
        plot.tag = element_text(face = "bold"), 
        strip.text.y = ggtext::element_markdown(
          angle = 270,
          lineheight = 1.1
        ), strip.text.x = ggtext::element_markdown(
          lineheight = 1.1
        )) + 
  labs(tag = "a")  

tau_u <- ggplot(times_U[intersect(samples_8_u, bpp_only), ], aes(x = interaction(Ne, demography), y = CI_size, fill = parameter)) + 
  geom_violin() + 
  facet_grid(loci_theta~analysis, scales = "free", space = "free_x") + 
  scale_x_discrete(labels = demo_labels ) +  
  theme_bw() +
  labs(fill = "unbalanced\ntree node", x = "", y = "divergence time", color = "unbalanced\ntree node") +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 7.5),
        strip.text.x = element_blank(),       # Removes the text inside the top facet bars
        strip.background.x = element_blank(),   # Optional: Removes the gray background boxes
        plot.tag = element_text(face = "bold"), 
        strip.text.y = ggtext::element_markdown(
          angle = 270,
          lineheight = 1.1
        )
  ) +   labs(tag = "b")

p <- tau_b/tau_u & theme(plot.margin = margin(0, 0, -10, 0, "pt"))


#####
ex <- which(times_U_cov$demography == "s3")
ex <- intersect(which(times_U_cov$parameter == "ABCD"), ex)
ex <- intersect(which(times_U_cov$Ne == "Ne_i"), ex)
ex <- intersect(which(times_U_cov$samples == "1"), ex)
ex <- intersect(which(times_U_cov$theta == 0.01), ex)

times_U_cov$analysis[which(times_U_cov$analysis == "ghost")] <- "bpp ghost"

times_U_cov$coverage <- as.factor(times_U_cov$coverage)

# Coverage plots
p_cov <- ggplot(times_U_cov[ex,], aes(x = rep, y = mean)) + 
  geom_hline(data = times_U_cov[ex, ], aes(yintercept = true), linetype = "dashed", ) +
  geom_errorbar(mapping=aes( ymin=X2.5HPD, ymax=X97.5HPD, color = coverage)) +
  geom_point() + 
  facet_grid(analysis~loci, scales = "free", space = "free_x") + 
  scale_x_discrete(labels = demo_labels ) +  
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) + 
  labs(fill = "balanced\ntree node", x = "", y = "divergence time of ABCD") + 
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), 
        plot.tag = element_text(face = "bold")) 

pdf("~/Ne_MSC_write/manuscript/figs/CI_coverage.pdf", width=6.5, height=5)
p_cov
dev.off()

# ex <- intersect(which(times_U_cov$loci == 40), ex)
# ex <- intersect(which(times_U_cov$theta == 0.01), ex)
# ex_bpp <- intersect(which(times_U_cov$analysis == "bpp"), ex)
# ex_ghost <- intersect(which(times_U_cov$analysis == "bpp ghost"), ex)

# mean(times_U_cov$CI_size[ex_bpp])
# mean(times_U_cov$CI_size[ex_ghost])
# 
# mean(times_U_cov$mean[ex_bpp])
# mean(times_U_cov$mean[ex_ghost])
