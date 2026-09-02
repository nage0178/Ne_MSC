setwd("~/Ne_MSC")
astral <- read.csv("astral_bl.csv")
results_bl <- astral %>% pivot_longer( cols = 10:18,
                                              names_to = "node",
                                              values_to = "branch_length")


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
results_interact <- results_bl %>%
  mutate(loci_theta= interaction(loci, theta, sep = "_")) 

results_interact$loci_theta = factor(results_interact$loci_theta,
                                       labels=c(expression(atop(paste(loci," = ", 40,),  paste( theta, " = 0.0025"))),
                                                expression(atop(paste(loci," = ", 160,), paste( theta, " = 0.0025"))),
                                                expression(atop(paste(loci," = ", 40,),  paste( theta, " = 0.01"))),
                                                expression(atop(paste(loci," = ", 160,), paste( theta, " = 0.01")))
                                       ))

results_interact <- results_interact %>%
  mutate(samples_topo= interaction(samples, topology, sep = "_")) 


results_interact$samples_topo <- factor(results_interact$samples_topo,
                                labels=c(expression(atop("balanced",   "1 sample")),
                                         expression(atop("balanced", "8 samples")),
                                         expression(atop("unbalanced",   "1 sample")),
                                         expression(atop("unbalanced", "8 samples"))
                                ))

demo_labels <- c(
  "Ne_i.s1" = "constant",
  "Ne_d.s2" = "exponential\nsmaller",
  "Ne_i.s2" = "exponential\nlarger",
  "Ne_d.s3" = "piecewise\nsmaller", 
  "Ne_i.s3" = "piecewise\nlarger"
  
)

tmp <- which(results_interact$node == "ABCDE")

p_list <- list()
for (node in names(table(results_interact$node))) {  
  rows  <- which(results_interact$node == node)
  ylab <- paste("length of branch ancestral to", node)
  if (node == "ABCD_DE") {
    ylab <-"branch length ancestral to\nDE (balanced) or ABCD (unbalanced)"
    
  }
p1 <- ggplot(results_interact[rows, ], aes(x = interaction(Ne, demography), y = branch_length)) + 
  geom_hline(data = results_interact[rows, ], aes(yintercept = true), linetype = "dashed", ) +
  geom_violin() + #, alpha = .6
  facet_grid(loci_theta~samples_topo, scales = "free", labeller = label_parsed, space = "free_x") + 
  scale_x_discrete(labels = demo_labels ) +  
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) +
  labs( x = "", y = ylab) #+ 
  #theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), 
        #  plot.margin = margin(b = 3, t = 5, l = 5, r = 5), 
  #      plot.tag = element_text(face = "bold")) + 
  #labs(tag = "a")  
  p_list[[length(p_list) + 1]] <- p1
  
  pdf(paste("~/Ne_MSC_write/manuscript/figs/astral_bl_", node, ".pdf", sep = ""), width = 9, height = 4.75 *1.5)
  print(p1)
  dev.off()
}
