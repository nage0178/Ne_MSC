library(tidyr)
library(ggplot2)
library(patchwork)

setwd("~/Ne_MSC")
results_bpp <- read.csv("bpp_divergence_sum.csv")

results_bpp$true <- results_bpp$theta
row_b <- which(results_bpp$topology == "t_B")
rows <- intersect(which(results_bpp$parameter == "tau:6"), row_b) # root
results_bpp$true[rows] <- results_bpp$true[rows] * 5
rows <- intersect(which(results_bpp$parameter == "tau:7"), row_b) # ABC
results_bpp$true[rows] <- results_bpp$true[rows] * 4
rows <- intersect(which(results_bpp$parameter == "tau:8"), row_b) # AB
results_bpp$true[rows] <- results_bpp$true[rows] * 3
rows <- intersect(which(results_bpp$parameter == "tau:9"), row_b) # DE
results_bpp$true[rows] <- results_bpp$true[rows] * 4.5


row_u <- which(results_bpp$topology == "t_U")
rows <- intersect(which(results_bpp$parameter == "tau:6"), row_u) # root
results_bpp$true[rows] <- results_bpp$true[rows] * 5
rows <- intersect(which(results_bpp$parameter == "tau:7"), row_u) # ABCD
results_bpp$true[rows] <- results_bpp$true[rows] * 4
rows <- intersect(which(results_bpp$parameter == "tau:8"), row_u) # ABC
results_bpp$true[rows] <- results_bpp$true[rows] * 3
rows <- intersect(which(results_bpp$parameter == "tau:9"), row_u) # AB
results_bpp$true[rows] <- results_bpp$true[rows] * 2.5

results_bpp$coverage <- (results_bpp$true < results_bpp$X97.5HPD) * (results_bpp$true > results_bpp$X2.5HPD)

results_bpp <- results_bpp %>%
  mutate(loci_theta= interaction(loci, theta, sep = "_")) 

results_bpp$loci_theta <- factor(results_bpp$loci_theta,
                                  labels=c(expression(atop(paste(loci," = ", 40,),  paste( theta, " = 0.0025"))),
                                           expression(atop(paste(loci," = ", 160,), paste( theta, " = 0.0025"))),
                                           expression(atop(paste(loci," = ", 40,),  paste( theta, " = 0.01"))),
                                           expression(atop(paste(loci," = ", 160,), paste( theta, " = 0.01")))
                                  ))

results_bpp <- results_bpp %>%
  mutate(loci_samples= interaction(loci, samples, sep = "_")) 

results_bpp$loci_samples <- factor(results_bpp$loci_samples,
                                 labels=c("loci = 40, samples = 1",
                                          "loci = 160, samples = 1",
                                          "loci = 40, samples = 8",
                                          "loci = 160, samples = 8")
                                 )

results_bpp$samples <- factor(results_bpp$samples,
                                 labels=c(expression(paste("samples = 1")),
                                          expression(paste("samples = 8"))
                                 ))

tau_row <- grep("tau", results_bpp$parameter)
tree_row_B <- grep("B", results_bpp$topology)
tree_row_U <- grep("U", results_bpp$topology)

times_B <- results_bpp[intersect(tau_row, tree_row_B), ]
times_U <- results_bpp[intersect(tau_row, tree_row_U), ]

demo_labels <- c(
  "Ne_i.s1" = "constant",
  "Ne_d.s2" = "exponential\nsmaller",
  "Ne_i.s2" = "exponential\nlarger",
  "Ne_d.s3" = "piecewise\nsmaller", 
  "Ne_i.s3" = "piecewise\nlarger"
  
)

### Coverage 
cov_b <- ggplot(times_B, aes(x = interaction(Ne, demography), y = coverage, fill = parameter)) + 
  geom_bar(stat = "summary", fun = "mean", position = position_dodge()) + #, alpha = .6
  facet_grid(samples~loci_theta, scales = "free", labeller = label_parsed) +
  geom_hline(yintercept = .95,  linetype = "dashed", ) +
  scale_x_discrete(
    labels = demo_labels
  ) +  theme_bw() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), 
        plot.tag = element_text(face = "bold")) + 
  labs(fill = "balanced\ntree node", x = "", y = "divergence time coverage") + 
  scale_fill_discrete(
    labels =  c("ABCDE", "ABC", "AB", "DE")
  ) +
  labs(tag = "a")  

cov_u <- ggplot(times_U, aes(x = interaction(Ne, demography), y = coverage, fill = parameter)) + 
  geom_bar(stat = "summary", fun = "mean", position = position_dodge()) + #, alpha = .6
  facet_grid(samples~loci_theta, scales = "free", labeller = label_parsed) +
  geom_hline(yintercept = .95,  linetype = "dashed", ) +
  scale_x_discrete(
    labels = demo_labels
  ) +  theme_bw() +
  labs(fill = "unbalanced\ntree node", x = "", y = "divergence time coverage") + 
  scale_fill_discrete(
    labels =  c("ABCDE", "ABCD", "ABC", "AB")
  ) +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 7.5),
        strip.text.x = element_blank(),       # Removes the text inside the top facet bars
        strip.background.x = element_blank(),   # Optional: Removes the gray background boxes
        plot.tag = element_text(face = "bold"), 
  ) +   labs(tag = "b") 

pdf("~/Ne_MSC_write/manuscript/figs/bpp_cov_both.pdf", width = 9, height = 8)
cov_b/cov_u & theme(plot.margin = margin(0, 0, -20, 0, "pt"))
dev.off()

theta_row <- grep("theta", results_bpp$parameter)
theta_B <- results_bpp[intersect(theta_row, tree_row_B), ]
theta_U <- results_bpp[intersect(theta_row, tree_row_U), ]
tips_B <- which((theta_B$parameter == "theta:1") + (theta_B$parameter == "theta:2") + (theta_B$parameter == "theta:3") + 
          (theta_B$parameter == "theta:4") +  (theta_B$parameter == "theta:5") == 1)
internal_B <- which((theta_B$parameter == "theta:6") + (theta_B$parameter == "theta:7") + 
              (theta_B$parameter == "theta:8") + (theta_B$parameter == "theta:9") == 1)
tips_U <- which((theta_U$parameter == "theta:1") + (theta_U$parameter == "theta:2") + (theta_U$parameter == "theta:3") + 
                  (theta_U$parameter == "theta:4") +  (theta_U$parameter == "theta:5") == 1)
internal_U <- which((theta_U$parameter == "theta:6") + (theta_U$parameter == "theta:7") + 
                      (theta_U$parameter == "theta:8") + (theta_U$parameter == "theta:9") == 1)


theta_tip_b <- ggplot(theta_B[tips_B, ], aes(x = interaction(Ne, demography), y = mean, fill = parameter)) + 
  geom_violin() +
  facet_grid(theta~loci_samples, scales = "free", labeller = label_bquote( theta == .(theta))) +
  geom_hline(data = theta_B[tips_B, ], aes(yintercept = true), linetype = "dashed", ) +
  scale_x_discrete(
    labels = demo_labels
  ) +  theme_bw() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), 
        plot.tag = element_text(face = "bold"), legend.position = "none") + 
  labs(fill = "node", x = "", y = expression(theta~"for balanced trees")) + 
  scale_fill_discrete(
    labels = c("A", "B", "C", "D", "E")
  ) +   labs(tag = "a") 

theta_tip_u <- ggplot(theta_U[tips_U, ], aes(x = interaction(Ne, demography), y = mean, fill = parameter)) + 
  geom_violin() + 
  facet_grid(theta~loci_samples, scales = "free", labeller = label_bquote( theta == .(theta))) +
  geom_hline(data = theta_U[tips_U, ], aes(yintercept = true), linetype = "dashed", ) +
  scale_x_discrete(
    labels = demo_labels
  ) +  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 7.5),
        strip.text.x = element_blank(),       # Removes the text inside the top facet bars
        strip.background.x = element_blank(),   # Optional: Removes the gray background boxes
        plot.tag = element_text(face = "bold"),
        legend.position = "none"
  ) +
  labs(fill = "node", x = "", y = expression(theta~"for unbalanced trees")) + 
  scale_fill_discrete(
    labels = c("A", "B", "C", "D", "E")
  ) + labs(tag = "b") 

pLegend <-  ggplot(theta_U[tips_U, ], aes(x = interaction(Ne, demography), y = mean, fill = parameter)) + 
  geom_violin() + 
  facet_grid(theta~loci_samples, scales = "free", labeller = label_bquote( theta == .(theta))) +
  geom_hline(data = theta_U[tips_U, ], aes(yintercept = true), linetype = "dashed", ) +
  theme_bw() +
  labs(fill = "node", x = "", y = expression(theta)) + 
  scale_fill_discrete(
    labels = c("A", "B", "C", "D", "E")
  ) + theme(legend.position = "bottom")
legend1 <- cowplot::get_legend(pLegend)

scale <- .95
pdf("~/Ne_MSC_write/manuscript/figs/bpp_theta_tip.pdf", width = 9 *scale, height = 10 *scale)
ggpubr::ggarrange(theta_tip_b/theta_tip_u & theme(plot.margin = margin(0, 0, -20, 0, "pt")), legend1, labels = c(),
                  nrow =2, ncol = 1, heights = c(2,  .1))
dev.off()


theta_int_b <- 
  ggplot(theta_B[internal_B, ], aes(x = interaction(Ne, demography), y = mean, fill = parameter)) + 
  geom_violin() + 
  facet_grid(theta~loci_samples, scales = "free", labeller = label_bquote( theta == .(theta))) +
  geom_hline(data = theta_B[internal_B, ], aes(yintercept = true), linetype = "dashed", ) +
  scale_x_discrete(
    labels = demo_labels
  ) +  theme_bw() +
  theme(axis.text.x = element_blank(), axis.ticks.x = element_blank(), 
        plot.tag = element_text(face = "bold"), legend.position = "bottom") + 
  labs(fill = "node", x = "",y = expression(theta~"for balanced trees")) + 
  scale_fill_discrete(
    labels =  c("ABCDE", "ABC", "AB", "DE")
  ) + labs(tag = "a") 


theta_int_u <- ggplot(theta_U[internal_U, ], aes(x = interaction(Ne, demography), y = mean, fill = parameter)) + 
  geom_violin() + 
  facet_grid(theta~loci_samples, scales = "free", labeller = label_bquote( theta == .(theta))) +
  geom_hline(data = theta_U[internal_U, ], aes(yintercept = true), linetype = "dashed", ) +
  scale_x_discrete(
    labels = demo_labels
  ) +  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1, size = 7.5),
        strip.text.x = element_blank(),       # Removes the text inside the top facet bars
        strip.background.x = element_blank(),   # Optional: Removes the gray background boxes
        plot.tag = element_text(face = "bold"),
        legend.position = "bottom") + 
  labs(fill = "node", x = "", y = expression(theta~"for unbalanced trees")) + 
  scale_fill_discrete(
    labels =  c("ABCDE", "ABCD", "ABC", "AB")
  ) + labs(tag = "b") 

pdf("~/Ne_MSC_write/manuscript/figs/bpp_theta_int.pdf", width = 9, height = 10)
theta_int_b/theta_int_u & theme(plot.margin = margin(0, 0, -5, 0, "pt"))
dev.off()


# tau_b <- ggplot(times_B, aes(x = interaction(Ne, demography), y = mean, fill = parameter)) + 
#   geom_violin(position=position_dodge(width = 0.0)) + #, alpha = .6
#   facet_grid(theta~interaction(loci,samples), scales = "free", labeller = label_bquote( theta == .(theta))) +
#   geom_hline(data = times_B, aes(yintercept = true, color = parameter), linetype = "dashed", ) +
#   scale_x_discrete(
#     labels = demo_labels
#   ) +  theme_bw() +
#   theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) + 
#   labs(fill = "node", x = "", y = "divergence time", color = "node") + 
#   scale_fill_discrete(
#     labels = c("ABCDE", "ABC", "AB", "DE")
#   ) +scale_color_discrete(
#     labels = c("ABCDE", "ABC", "AB", "DE")
#   )
# 
# 
# pdf("~/Ne_MSC_write/manuscript/figs/bpp_tau_bal.pdf", width = 9, height = 6)
# tau_b
# dev.off()
# 
# 
# tau_u <- ggplot(times_U, aes(x = interaction(Ne, demography), y = mean, fill = parameter)) + 
#   geom_violin(position=position_dodge(width = 0.0)) + #, alpha = .6
#   facet_grid(theta~interaction(loci,samples), scales = "free", labeller = label_bquote( theta == .(theta))) +
#   geom_hline(data = times_U, aes(yintercept = true, color = parameter), linetype = "dashed", ) +
#   scale_x_discrete(
#     labels = demo_labels
#   ) +  theme_bw() +
#   theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1)) + 
#   labs(fill = "node", x = "", y = "divergence time", color = "node") + 
#   scale_fill_discrete(
#     labels =  c("ABCDE", "ABCD", "ABC", "AB")
#   ) +
#   scale_color_discrete(
#     labels =  c("ABCDE", "ABCD", "ABC", "AB")
#   )
# 
# pdf("~/Ne_MSC_write/manuscript/figs/bpp_tau_unbal.pdf", width = 9, height = 6)
# tau_u
# dev.off()
