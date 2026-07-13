library(ggplot2)
library(forcats)
library(viridis)
setwd("~/Ne_MSC")
gtree_u <- read.csv("u_gtree_dist.csv")
gtree_b <- read.csv("b_gtree_dist.csv")
gtree <- rbind(gtree_u, gtree_b)

gtree$dist <- as.factor(gtree$dist)

extra_const <- intersect(which(gtree$demography == "s1"), which(gtree$Ne == "Ne_d"))
gtree_sub <- gtree[-extra_const, ]
topology <- which(gtree_sub$experiment == "topology")
g_dist_topology <- ggplot(gtree_sub[topology, ], aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + facet_wrap(topology~theta) +
  geom_bar(position = "fill", color = "white") +  scale_fill_viridis_d(option = "viridis") + 
  labs(fill = "RF\ndistance", x = "demography", y = "proportion of gene trees") +theme_bw() + 
  scale_x_discrete(
    labels = c(
      "Ne_i.s1" = "constant",
      "Ne_d.s2" = "exponential\nsmaller",
      "Ne_i.s2" = "exponential\nlarger",
      "Ne_d.s3" = "piecewise\nsmaller", 
      "Ne_i.s3" = "piecewise\nlarger"
      
    )
  )

pdf("~/Ne_MSC_write/manuscript/figs/gtree_dist_topology.pdf", width = 9, height = 10)
g_dist_topology
dev.off()

g_dist_time <- ggplot(gtree_sub[-topology, ], aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + facet_wrap(topology~theta) +
  geom_bar(position = "fill", color = "white") +  scale_fill_viridis_d(option = "viridis") + 
  labs(fill = "RF\ndistance", x = "demography", y = "proportion of gene trees") +theme_bw() + 
  scale_x_discrete(
    labels = c(
      "Ne_i.s1" = "constant",
      "Ne_d.s2" = "exponential\nsmaller",
      "Ne_i.s2" = "exponential\nlarger",
      "Ne_d.s3" = "piecewise\nsmaller", 
      "Ne_i.s3" = "piecewise\nlarger"
      
    )
  )

pdf("~/Ne_MSC_write/manuscript/figs/gtree_dist_time.pdf", width = 9, height = 10)
g_dist_time
dev.off()
