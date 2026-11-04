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
results$analysis[which(results$analysis == "picl_bestLike.tre")] <- "PICL"
#results$analysis[which(results$analysis == "PICL_est")] <- "PICL_theta"
results$analysis[which(results$analysis == "MAP.txt")] <- "bpp"
results_SNP <- results[which(results$analysis == "PICL"), ]
#results <- results[-which(results$analysis == "PICL"), ]
results$loci[intersect(which(results$analysis == "PICL"), which(results$loci == 20000))] <- 40
results$loci[intersect(which(results$analysis == "PICL"), which(results$loci == 80000))] <- 160
results$loci[intersect(which(results$analysis == "PICL_est"), which(results$loci == 20000))] <- 40
results$loci[intersect(which(results$analysis == "PICL_est"), which(results$loci == 80000))] <- 160
results$loci <- factor(results$loci)


# Rename the topologies
results$topology[which(results$topology == "t_U")] <- "unbalanced"
results$topology[which(results$topology == "t_B")] <- "balanced"

# Treat distance as a factor
results$dist <- as.factor(results$dist)


# Reorder analyses
results$analysis <- factor(results$analysis)
results <- results %>%mutate(analysis = fct_relevel(analysis, c("bpp", "ASTRAL", "MP-EST", "PICL")))

# Remove extra analyses you ran
extra_const <- intersect(which(results$demography == "s1"), which(results$Ne == "Ne_d"))
results_sub <- results[-extra_const, ]

# Set up interaction names
samples1 <- which(results_sub$samples == 1)
samples8 <- which(results_sub$samples == 8)

results_interact_1 <- results_sub[samples1, ] %>%
  mutate(loci_theta= interaction(loci, theta, sep = "_")) 


results_interact_1$loci_theta <- factor(
  results_interact_1$loci_theta,
  labels = c(
    "loci = 40<br>sites = 20000<br>&theta; = 0.0025",
    "loci = 160<br>sites = 80000<br>&theta; = 0.0025",
    "loci = 40<br>sites = 20000<br>&theta; = 0.01",
    "loci = 160<br>sites = 80000<br>&theta; = 0.01"
  )
)


unbalanced <- which(results_interact_1$topology == "unbalanced")
balanced <- which(results_interact_1$topology == "balanced")

p1 <- ggplot(results_interact_1[balanced, ], aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + 
  facet_grid(loci_theta~analysis ) +
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
            legend.position = "none", plot.tag = element_text(face = "bold"), 
            strip.text.y = ggtext::element_markdown(
              # size = 10,
              angle = 270,
              lineheight = 1.1
            )) + 
  labs(tag = "a") + geom_errorbar(aes(x = interaction(Ne, demography), ymax = pp_mean, ymin = pp_mean))


p2 <- ggplot(results_interact_1[unbalanced, ], aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + 
  facet_grid(loci_theta~analysis ) +
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
          legend.position = "none", plot.tag = element_text(face = "bold"), 
          strip.text.y = ggtext::element_markdown(
            # size = 10,
            angle = 270,
            lineheight = 1.1
          )
) +   labs(tag = "b") + 
  geom_errorbar(aes(x = interaction(Ne, demography), ymax = pp_mean, ymin = pp_mean))


pLegend <- ggplot(results_interact_1[unbalanced, ], aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + 
  facet_grid(analysis~loci_theta) +
  geom_bar(position = "fill") +  scale_fill_viridis_d(option = "viridis") + 
  labs(fill = "RF distance")+ theme(legend.position = "bottom")
legend1 <- cowplot::get_legend(pLegend)

scale <- 1
 p_both <- ggpubr::ggarrange(p1/p2 & theme(plot.margin = margin(0, 0, -20, 0, "pt")), legend1, labels = c(),
                         nrow =2, ncol = 1, heights = c(2,  .1))
ggsave(
  "~/Ne_MSC_write/manuscript/figs/topology_1.pdf",
  plot = p_both,
  device = cairo_pdf,
  width = 8,
  height = 9
)

# Eight samples
results_interact_8 <- results_sub[samples8, ] %>%
  mutate(loci_theta= interaction(loci, theta, sep = "_")) 


results_interact_8$loci_theta <- factor(
  results_interact_8$loci_theta,
  labels = c(
    "loci = 40<br>sites = 20000<br>&theta; = 0.0025",
    "loci = 160<br>sites = 80000<br>&theta; = 0.0025",
    "loci = 40<br>sites = 20000<br>&theta; = 0.01",
    "loci = 160<br>sites = 80000<br>&theta; = 0.01"
  )
)

results_interact_8$analysis <- factor(
  results_interact_8$analysis,
  labels = c(
    "bpp",
    "ASTRAL",
    #"MP-EST",
    "PICL", 
    "PICL est. &theta;"
  )
)

unbalanced <- which(results_interact_8$topology == "unbalanced")
balanced <- which(results_interact_8$topology == "balanced")

p1 <- ggplot(results_interact_8[balanced, ], aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + 
  facet_grid(loci_theta~analysis ) +
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
            legend.position = "none", plot.tag = element_text(face = "bold"), 
            strip.text.y = ggtext::element_markdown(
              # size = 10,
              angle = 270,
              lineheight = 1.1
            ),
            strip.text.x = ggtext::element_markdown(
              # size = 10,
              #angle = 270,
              lineheight = 1.1
            )) + 
  labs(tag = "a") + geom_errorbar(aes(x = interaction(Ne, demography), ymax = pp_mean, ymin = pp_mean))


p2 <- ggplot(results_interact_8[unbalanced, ], aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + 
  facet_grid(loci_theta~analysis ) +
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
              legend.position = "none", plot.tag = element_text(face = "bold"), 
              strip.text.y = ggtext::element_markdown(
                # size = 10,
                angle = 270,
                lineheight = 1.1
              )
  ) +   labs(tag = "b") + 
  geom_errorbar(aes(x = interaction(Ne, demography), ymax = pp_mean, ymin = pp_mean))


pLegend <- ggplot(results_interact_8[unbalanced, ], aes(x = interaction(Ne, demography), fill = fct_rev(dist))) + 
  facet_grid(analysis~loci_theta) +
  geom_bar(position = "fill") +  scale_fill_viridis_d(option = "viridis") + 
  labs(fill = "RF distance")+ theme(legend.position = "bottom")
legend1 <- cowplot::get_legend(pLegend)

scale <- 1
p_both <- ggpubr::ggarrange(p1/p2 & theme(plot.margin = margin(0, 0, -20, 0, "pt")), legend1, labels = c(),
                            nrow =2, ncol = 1, heights = c(2,  .1))
ggsave(
  "~/Ne_MSC_write/manuscript/figs/topology_8.pdf",
  plot = p_both,
  device = cairo_pdf,
  width = 8,
  height = 9
)
