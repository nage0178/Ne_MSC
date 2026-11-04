library(ggplot2)
library(forcats)
library(viridis)
setwd("~/Ne_MSC")
gtree_u <- read.csv("u_gtree_dist.csv")
gtree_b <- read.csv("b_gtree_dist.csv")
gtree <- rbind(gtree_u, gtree_b)

gtree$dist <- as.factor(gtree$dist)
gtree$topology[which(gtree$topology == "t_B")] <- "balanced"
gtree$topology[which(gtree$topology == "t_U")] <- "unbalanced"
gtree$experiment[which(gtree$experiment == "time")] <- "divergence time"

gtree <- gtree %>%mutate(experiment = fct_relevel(experiment, c("topology", "divergence time")))


# Removing extra simulations for constant population size (you ran twice as many as you needed)
extra_const <- intersect(which(gtree$demography == "s1"), which(gtree$Ne == "Ne_d"))
gtree_sub <- gtree[-extra_const, ]
topology <- which(gtree_sub$experiment == "topology")

g_dist_topology_comb <- ggplot(gtree_sub, aes(x = interaction(Ne, demography), fill = fct_rev(dist))) +
  facet_grid(~experiment) +
  geom_bar(position = "fill") +  scale_fill_viridis_d(option = "viridis") + 
  labs(fill = "RF distance", x = "", y = "proportion of gene trees") +theme_bw() + 
  scale_x_discrete(
    labels = c(
      "Ne_i.s1" = "constant",
      "Ne_d.s2" = "exponential\nsmaller",
      "Ne_i.s2" = "exponential\nlarger",
      "Ne_d.s3" = "piecewise\nsmaller", 
      "Ne_i.s3" = "piecewise\nlarger"
      
    )
  ) + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +  theme(legend.position = "bottom") +theme(
    legend.margin = margin(t = 0, r = 0, b = 0, l = 0) # Strips individual side padding
  ) + theme(
    legend.box.spacing = unit(0, "pt") # Try negative values like unit(-10, "pt") if needed
  )

scale <- .67
pdf("~/Ne_MSC_write/manuscript/figs/gtree_dist_topology_comb.pdf", width = 6 * scale, height = 5 *scale)
g_dist_topology_comb
dev.off()
  

g_dist_topology <- ggplot(gtree_sub[topology, ], aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + 
  facet_grid(theta~topology, labeller = label_bquote( theta == .(theta))) +
  geom_bar(position = "fill") +  scale_fill_viridis_d(option = "viridis") + 
  labs(fill = "RF\ndistance", x = "demography", y = "proportion of gene trees") +theme_bw() + 
  scale_x_discrete(
    labels = c(
      "Ne_i.s1" = "constant",
      "Ne_d.s2" = "exponential\nsmaller",
      "Ne_i.s2" = "exponential\nlarger",
      "Ne_d.s3" = "piecewise\nsmaller", 
      "Ne_i.s3" = "piecewise\nlarger"
      
    )
  ) + 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))


scale <- .8
pdf("~/Ne_MSC_write/manuscript/figs/gtree_dist_topology.pdf", width = 9 * scale, height = 10 *scale)
g_dist_topology
dev.off()

g_dist_time <- ggplot(gtree_sub[-topology, ], aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + 
  facet_grid(theta~topology, labeller = label_bquote( theta == .(theta))) +
  geom_bar(position = "fill") +  scale_fill_viridis_d(option = "viridis") + 
  labs(fill = "RF\ndistance", x = "demography", y = "proportion of gene trees") +theme_bw() + 
  scale_x_discrete(
    labels = c(
      "Ne_i.s1" = "constant",
      "Ne_d.s2" = "exponential\nsmaller",
      "Ne_i.s2" = "exponential\nlarger",
      "Ne_d.s3" = "piecewise\nsmaller", 
      "Ne_i.s3" = "piecewise\nlarger"
      
    )
  )+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1))

pdf("~/Ne_MSC_write/manuscript/figs/gtree_dist_time.pdf", width = 9 *scale, height = 10 *scale)
g_dist_time
dev.off()
