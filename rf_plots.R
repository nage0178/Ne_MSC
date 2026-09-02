library(ggplot2)
library(forcats)
library(dplyr)
library(patchwork)
setwd("~/Ne_MSC")
results_original <- read.csv("results.csv")
# Remove the MCMCs that did not converge
results_original <- results_original[- which(is.na(results_original$dist)), ]

# Calculate the mean PP for each set of conditions
results = results_original%>% 
  group_by(loci,theta,topology,samples, Ne, demography, analysis) %>% 
  mutate(pp_mean = mean(PP))

# Rename the analyses
results$analysis[which(results$analysis == "astral.tre")] <- "ASTRAL"
results$analysis[which(results$analysis == "mpest_best.tre")] <- "MP-EST"
results$analysis[which(results$analysis == "picl_best.tre")] <- "PICL"
results$analysis[which(results$analysis == "MAP.txt")] <- "bpp"
results_SNP <- results[which(results$analysis == "PICL"), ]
results <- results[-which(results$analysis == "PICL"), ]

# Rename the topologies
results$topology[which(results$topology == "t_U")] <- "unbalanced"
results$topology[which(results$topology == "t_B")] <- "balanced"

# Treat distance as a factor
results$dist <- as.factor(results$dist)

# Remove extra analyses you ran
extra_const <- intersect(which(results$demography == "s1"), which(results$Ne == "Ne_d"))
results_sub <- results[-extra_const, ]

# Set up interaction names
samples1 <- which(results_sub$samples == 1)
samples8 <- which(results_sub$samples == 8)

results_interact_1 <- results_sub[samples1, ] %>%
  mutate(loci_theta= interaction(loci, theta, sep = "_")) 

results_interact_1$loci_theta = factor(results_interact_1$loci_theta,
                                     labels=c(expression(atop(paste(loci," = ", 40,),  paste( theta, " = 0.0025"))),
                                              expression(atop(paste(loci," = ", 160,), paste( theta, " = 0.0025"))),
                                              expression(atop(paste(loci," = ", 40,),  paste( theta, " = 0.01"))),
                                              expression(atop(paste(loci," = ", 160,), paste( theta, " = 0.01")))
                                     ))

unbalanced <- which(results_interact_1$topology == "unbalanced")
balanced <- which(results_interact_1$topology == "balanced")

p1 <- ggplot(results_interact_1[balanced, ], aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + 
  facet_grid(loci_theta~analysis ,  labeller = label_parsed) +
  geom_bar(position = "fill") +  scale_fill_viridis_d(option = "viridis") + 
  labs(fill = "RF\ndistance", x = "", y = "balanced\nproportion of trees") +theme_bw() + 
  scale_x_discrete(
    labels = c(
      "Ne_i.s1" = "constant",
      "Ne_d.s2" = "exponential\nsmaller",
      "Ne_i.s2" = "exponential\nlarger",
      "Ne_d.s3" = "piecewise\nsmaller", 
      "Ne_i.s3" = "piecewise\nlarger"
      
    )
  ) + theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), 
            plot.margin = margin(b = 5, t = 5, l = 5, r = 5), 
            legend.position = "none", plot.tag = element_text(face = "bold")) + 
  labs(tag = "a") + geom_errorbar(aes(x = interaction(Ne, demography), ymax = pp_mean, ymin = pp_mean))


p2 <- ggplot(results_interact_1[unbalanced, ], aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + 
  facet_grid(loci_theta~analysis ,  labeller = label_parsed) +
  geom_bar(position = "fill") +  scale_fill_viridis_d(option = "viridis") + 
  labs(fill = "RF\ndistance", x = "demography", y = "unbalanced\nproportion of trees") +theme_bw() + 
  scale_x_discrete(
    labels = c(
      "Ne_i.s1" = "constant",
      "Ne_d.s2" = "exponential\nsmaller",
      "Ne_i.s2" = "exponential\nlarger",
      "Ne_d.s3" = "piecewise\nsmaller", 
      "Ne_i.s3" = "piecewise\nlarger"
      
    )
  ) +   theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1,  size = 7.5),
          strip.text.x = element_blank(),       # Removes the text inside the top facet bars
          strip.background.x = element_blank(),   # Optional: Removes the gray background boxes
          legend.position = "none", plot.tag = element_text(face = "bold")
) +   labs(tag = "b") + 
  geom_errorbar(aes(x = interaction(Ne, demography), ymax = pp_mean, ymin = pp_mean))


pLegend <- ggplot(results_interact_1[unbalanced, ], aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + 
  facet_grid(analysis~loci_theta ,  labeller = label_parsed) +
  geom_bar(position = "fill") +  scale_fill_viridis_d(option = "viridis") + 
  labs(fill = "RF distance")+ theme(legend.position = "bottom")
legend1 <- cowplot::get_legend(pLegend)

scale <- 1
pdf("~/Ne_MSC_write/manuscript/figs/topology_1.pdf", width = 6 * scale, height = 9 * scale)
ggpubr::ggarrange(p1/p2 & theme(plot.margin = margin(0, 0, -20, 0, "pt")), legend1, labels = c(),
                  nrow =2, ncol = 1, heights = c(2,  .1))
dev.off()

# Eight samples
results_interact <- results_sub[samples8, ] %>%
  mutate(loci_theta= interaction(loci, theta, sep = "_")) 

results_interact$loci_theta <- factor(results_interact$loci_theta,
       labels=c(expression(atop(paste(loci," = ", 40,),  paste( theta, " = 0.0025"))),
                expression(atop(paste(loci," = ", 160,), paste( theta, " = 0.0025"))),
                expression(atop(paste(loci," = ", 40,),  paste( theta, " = 0.01"))),
                expression(atop(paste(loci," = ", 160,), paste( theta, " = 0.01")))
       ))

results_interact <- results_interact %>%
  mutate(analysis_topo= interaction(analysis, topology, sep = "_")) 
# Need to fix this
results_interact$analysis_topo <- factor(results_interact$analysis_topo,
                                      labels=c(expression(atop("ASTRAL",   "balanced")),
                                               expression(atop("bpp", "balanced")),
                                               expression(atop("ASTRAL",   "unbalanced")),
                                               expression(atop("bpp", "unbalanced"))
                                      ))



# check how you got it to work with coverage pltos
p1 <- ggplot(results_interact, aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + 
  facet_grid(loci_theta~analysis_topo,  labeller = label_parsed) + 
  geom_bar(position = "fill") +  scale_fill_viridis_d(option = "viridis") + 
  labs(fill = "RF distance", x = "", y = "proportion of trees") +theme_bw() + 
  scale_x_discrete(
    labels = c(
      "Ne_i.s1" = "constant",
      "Ne_d.s2" = "exponential\nsmaller",
      "Ne_i.s2" = "exponential\nlarger",
      "Ne_d.s3" = "piecewise\nsmaller", 
      "Ne_i.s3" = "piecewise\nlarger"
      
    )
  ) + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1,  size = 7.5),
            #strip.text.x = element_blank(),       # Removes the text inside the top facet bars
           # strip.background.x = element_blank(),   # Optional: Removes the gray background boxes
            legend.position = "none", plot.tag = element_text(face = "bold")
  ) +   #labs(tag = "a") + 
  geom_errorbar(aes(x = interaction(Ne, demography), ymax = pp_mean, ymin = pp_mean))


pLegend <- ggplot(results_interact[which(results_interact$topology == "unbalanced"), ], aes(x = interaction(Ne, demography), fill = fct_rev(dist))) +
  facet_grid(analysis~loci_theta,  labeller = label_parsed)+
  geom_bar(position = "fill") +  scale_fill_viridis_d(option = "viridis") + labs(fill = "RF distance") + theme(legend.position = "bottom")
legend1 <- cowplot::get_legend(pLegend)


scale <- 1
pdf("~/Ne_MSC_write/manuscript/figs/topology_8.pdf", width = 9 * scale, height = 4.75 * scale)
ggpubr::ggarrange(p1 & theme(plot.margin = margin(0, 0, -10, 0, "pt")), legend1, labels = c(),
                  
          nrow =2, ncol = 1, heights = c(2,  .1))
dev.off()


# SNP plots
results_SNP <- results_SNP %>%
  mutate(loci_theta= interaction(loci, theta, sep = "_")) 

results_SNP$loci_theta <- factor(results_SNP$loci_theta,
                                      labels=c(expression(atop(paste(loci," = ", 5000,),  paste( theta, " = 0.0025"))),
                                               expression(atop(paste(loci," = ", 20000,), paste( theta, " = 0.0025"))),
                                               expression(atop(paste(loci," = ", 5000,),  paste( theta, " = 0.01"))),
                                               expression(atop(paste(loci," = ", 20000,), paste( theta, " = 0.01")))
                                      ))

results_SNP <- results_SNP %>%
  mutate(samples_topo= interaction(samples, topology, sep = "_")) 
results_SNP$samples_topo <- factor(results_SNP$samples_topo,
                                   labels=c(expression(atop("balanced",   "1 sample")),
                                            expression(atop("balanced", "8 samples")),
                                            expression(atop("unbalanced",   "1 sample")),
                                            expression(atop("unbalanced", "8 samples"))
                                   ))

results_SNP$dist <- as.factor(results_SNP$dist)
p_picl <- ggplot(results_SNP, aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + 
  facet_grid(loci_theta~samples_topo,  labeller = label_parsed) + 
  geom_bar(position = "fill") +  scale_fill_viridis_d(option = "viridis") + 
  labs(fill = "RF distance", x = "", y = "proportion of trees") +theme_bw() + 
  scale_x_discrete(
    labels = c(
      "Ne_i.s1" = "constant",
      "Ne_d.s2" = "exponential\nsmaller",
      "Ne_i.s2" = "exponential\nlarger",
      "Ne_d.s3" = "piecewise\nsmaller", 
      "Ne_i.s3" = "piecewise\nlarger"
      
    )
  ) + theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1,  size = 7.5),
            #strip.text.x = element_blank(),       # Removes the text inside the top facet bars
            # strip.background.x = element_blank(),   # Optional: Removes the gray background boxes
            legend.position = "none", plot.tag = element_text(face = "bold")
  ) 

scale <- 1
pdf("~/Ne_MSC_write/manuscript/figs/picl_topology.pdf", width = 9 * scale, height = 4.75 * scale)
ggpubr::ggarrange(p_picl & theme(plot.margin = margin(0, 0, -10, 0, "pt")), legend1, labels = c(),
                  
                  nrow =2, ncol = 1, heights = c(2,  .1))
dev.off()
