setwd("~/Ne_MSC")
source("bpp_bl.R")
source("picl_bl.R")

astral <- read.csv("astral_bl.csv")

results_bl <- astral %>% pivot_longer( cols = 10:18,
                                              names_to = "node",
                                              values_to = "branch_length")

results_bl$analysis <- "ASTRAL"
long_bl$analysis <- "bpp"
results_picl$analysis <- "PICL"

results_bl <- rbind(results_bl, long_bl)
results_bl <- rbind(results_bl, results_picl)


names <- c("A", "B", "C", "D", "E", "AB", "ABC", "ABCD_DE", "ABCDE")
true_b <- c(  3,   3, 4, 4.5, 4.5,   1, 1, .5, 2.5)
true_u <- c(2.5, 2.5, 3,   4, 5, 0.5, 1,  1, 2.5)


results_bl$true <- results_bl$theta

topo_row <- which(results_bl$topology == "t_B")
for (i in 1:length(names)) {
  node_row <- which(results_bl$node == names[i])
  index <- intersect(topo_row, node_row)
  
  results_bl$true[index] <- results_bl$true[index] * true_b[i]
}

topo_row <- which(results_bl$topology == "t_U")
for (i in 1:length(names)) {
  node_row <- which(results_bl$node == names[i])
  index <- intersect(topo_row, node_row)
  
  results_bl$true[index] <- results_bl$true[index] * true_u[i]
}

results_bl$bias <- results_bl$branch_length - results_bl$true

df_summary <- results_bl %>%
  group_by(analysis, topology, demography, theta, Ne, loci, samples, node) %>%
  summarize(mean_bias = mean(bias))
#####
results_interact <- results_bl %>%
  mutate(loci_theta= interaction(loci, theta, sep = "_")) 

results_interact$loci_theta <- factor(
  results_interact$loci_theta,
  labels = c(
    "loci = 40<br>sites = 20000<br>&theta; = 0.0025",
    "loci = 160<br>sites = 80000<br>&theta; = 0.0025",
    "loci = 40<br>sites = 20000<br>&theta; = 0.01",
    "loci = 160<br>sites = 80000<br>&theta; = 0.01"
  )
)

results_interact <- results_interact %>%
  mutate(samples_topo= interaction(samples, topology, sep = "_")) 


results_interact$samples_topo <- factor(results_interact$samples_topo,
                                labels=c(expression(atop("balanced",   "1 sample")),
                                         expression(atop("balanced", "8 samples")),
                                         expression(atop("unbalanced",   "1 sample")),
                                         expression(atop("unbalanced", "8 samples"))
                                ))

# Reorder analyses
results_interact$analysis <- factor(results_interact$analysis)
results_interact <- results_interact %>%mutate(analysis = fct_relevel(analysis, c("bpp", "ASTRAL", "PICL")))

demo_labels <- c(
  "Ne_i.s1" = "constant",
  "Ne_d.s2" = "exponential\nsmaller",
  "Ne_i.s2" = "exponential\nlarger",
  "Ne_d.s3" = "piecewise\nsmaller", 
  "Ne_i.s3" = "piecewise\nlarger"
  
)

p_list <- list()
for (node in names(table(results_interact$node))) {  
  rows  <- which(results_interact$node == node)
  ylab <- paste("length of branch ancestral to", node)
  if (node == "ABCD_DE") {
    ylab <-"branch length ancestral to\nDE (balanced) or ABCD (unbalanced)"
    
  }
  
  stripes <- data.frame(
    xmin = seq(0.5, 4.5, by = 2), # Start points for shaded regions
    xmax = seq(1.5, 5.5, by = 2), # End points for shaded regions
    ymin = -Inf,
    ymax = Inf
  )
  
p1 <- ggplot(results_interact[rows, ], aes(x = interaction(Ne, demography), y = branch_length, fill = analysis)) + 
  geom_rect(
    data = stripes,
    aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
    fill = "grey80", 
    alpha = 0.5,
    inherit.aes = FALSE
  ) +
  geom_hline(data = results_interact[rows, ], aes(yintercept = true), linetype = "dashed", ) +
  geom_violin() + #, alpha = .6
  facet_grid(loci_theta~samples_topo, scales = "free",  labeller = labeller(
    loci_theta = label_value,
    samples_topo = label_parsed
  ), space = "free_x") + 
  #facet_grid(loci_theta~samples_topo, scales = "free", space = "free_x") + 
  
  scale_x_discrete(labels = demo_labels ) +  
  theme_bw() +
  theme( legend.box.margin = margin(t = -25, r = 0, b = -10, l = 0) , 
         legend.position = "bottom", axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),
        strip.text.y = ggtext::element_markdown(
          # size = 10,
          angle = 270,
          lineheight = 1.1
        )
        ) +
  labs( x = "", y = ylab) #+ 
  p_list[[length(p_list) + 1]] <- p1
  
  
  ggsave(
    paste("~/Ne_MSC_write/manuscript/figs/astral_bl_", node, ".pdf", sep = ""),
    plot = p1,
    device = cairo_pdf,
    width = 9,
    height = 4.75 *1.5
  )

}


p_list <- list()
for (node in names(table(results_interact$node))) {  
  rows  <- which(results_interact$node == node)
  ylab <- paste("bias of length of branch ancestral to", node)
  if (node == "ABCD_DE") {
    ylab <-"branch length ancestral to\nDE (balanced) or ABCD (unbalanced)"
    
  }
  
  stripes <- data.frame(
    xmin = seq(0.5, 4.5, by = 2), # Start points for shaded regions
    xmax = seq(1.5, 5.5, by = 2), # End points for shaded regions
    ymin = -Inf,
    ymax = Inf
  )
  
  p1 <- ggplot(results_interact[rows, ], aes(x = interaction(Ne, demography), y = bias, fill = analysis, color =analysis, shape = analysis)) + 
    geom_rect(
      data = stripes,
      aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
      fill = "grey80", 
      alpha = 0.5,
      inherit.aes = FALSE
    ) +
    geom_hline(data = results_interact[rows, ], aes(yintercept = 0), linetype = "dashed", ) +
    stat_summary(fun = mean, geom = "point") +
    facet_grid(loci_theta~samples_topo,   labeller = labeller(
      loci_theta = label_value,
      samples_topo = label_parsed
    ), space = "free_x") + 

    scale_x_discrete(labels = demo_labels ) +  
    theme_bw() +
    theme( legend.box.margin = margin(t = -25, r = 0, b = -10, l = 0) , 
           legend.position = "bottom", axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1),
           strip.text.y = ggtext::element_markdown(
             # size = 10,
             angle = 270,
             lineheight = 1.1
           )
    ) +
    labs( x = "", y = ylab) #+ 
  p_list[[length(p_list) + 1]] <- p1
  
  
  ggsave(
    paste("~/Ne_MSC_write/manuscript/figs/astral_bl_bias", node, ".pdf", sep = ""),
    plot = p1,
    device = cairo_pdf,
    width = 9,
    height = 4.75 *1.5
  )
  
}
