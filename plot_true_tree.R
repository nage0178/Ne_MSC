library(ape)
setwd("~/Ne_MSC")

topo_balanced  <- read.tree("trees/true_balanced_topo.tre")
topo_unbalanced    <- read.tree("trees/true_unbalanced_topo.tre")

time_balanced  <- read.tree("trees/true_balanced_time.tre")
time_unbalanced    <- read.tree("trees/true_unbalanced_time.tre")
b_width <- 3
width_balance <- c(1, b_width, 1, 1, b_width, 1, 1, 1, 1, 1)
width_unbalance <- c(1, 1, 1, b_width, 1, 1, b_width, 1, 1, 1)

scale <- 0.8
label_size <- .7
adj_label <- -.2
line_label <- .5

# title text
adj_title <- .5
cex_title <- label_size * .7
line_title <- 0
pdf("~/Ne_MSC_write/manuscript/figs/simulation_trees.pdf", width = 6.25 * scale, height = 1.55 * scale )
par(mfrow = c(1, 4))
par(mar = c(.5, 3.7, 2, 0.05)) 
par(mgp = c(3, 0.7, 0)) 


plot.phylo(topo_balanced, direction = "downwards", srt = 90, adj = 0.5, label.offset = .2, edge.width = width_unbalance)
mtext(substitute(paste(bold('a'))), adj = adj_label, line = line_label, cex = label_size)
mtext("topology,\nbalanced", adj = adj_title, line = line_title, cex = cex_title)

axis(side = 2, at = c(0, 2.5, 5, 7.5), line = 1.5, labels = c(0,  expression(paste("2.5", theta)), expression(paste("5", theta)), expression(paste("7.5", theta))), las = 1, cex.axis = .75)
#axisPhylo(las = 1, cex.axis = .75, line = 1.5)

plot.phylo(topo_unbalanced,   direction = "downwards", srt = 90, adj = 0.5, label.offset = .2, edge.width = width_balance)
mtext(substitute(paste(bold('b'))), adj = adj_label, line = line_label, cex = label_size)
mtext("topology,\nunbalanced", adj = adj_title, line = line_title, cex = cex_title)


plot.phylo(time_balanced, direction = "downwards", srt = 90, adj = 0.5, label.offset = .2, edge.width = width_unbalance)
mtext(substitute(paste(bold('c'))), adj = adj_label, line = line_label, cex = label_size)
mtext("divergence time,\nbalanced", adj = adj_title, line = line_title, cex = cex_title)


plot.phylo(time_unbalanced,   direction = "downwards", srt = 90, adj = 0.5, label.offset = .2, edge.width = width_balance)
mtext(substitute(paste(bold('d'))), adj = adj_label, line = line_label, cex = label_size)
mtext("divergence time,\nunbalanced", adj = adj_title, line = line_title, cex = cex_title)


dev.off()

time_balanced_1  <- read.tree("trees/true_balanced_time_1.tre")
time_balanced_8  <- read.tree("trees/true_balanced_time_8.tre")

time_unbalanced_1    <- read.tree("trees/true_unbalanced_time_1.tre")
time_unbalanced_8    <- read.tree("trees/true_unbalanced_time_8.tre")


pdf("~/Ne_MSC_write/manuscript/figs/simulation_trees_piecewise.pdf", width = 6 * scale, height = 6 * scale )
par(mfrow = c(2, 2))
par(mar = c(.5, 3.5, .5, 0.05)) 
par(mgp = c(3, 0.7, 0)) 


plot.phylo(time_unbalanced_1, direction = "downwards", srt = 180, adj = 0.5, label.offset = .2, underscore = TRUE)
mtext(substitute(paste(bold('a'))), adj = adj_label, line = line_label, cex = label_size)
axis(side = 2, at = c(0, 2.5, 5, 7.5), line = 1.5, labels = c(0,  expression(paste("2.5", theta)), expression(paste("5", theta)), expression(paste("7.5", theta))), las = 1, cex.axis = .75)
#axisPhylo(las = 1, cex.axis = .75, line = 1.5)

plot.phylo(time_unbalanced_8,   direction = "downwards", srt = 180, adj = 0.5, label.offset = .2, underscore = TRUE)
mtext(substitute(paste(bold('b'))), adj = adj_label, line = line_label, cex = label_size)

plot.phylo(time_balanced_1, direction = "downwards", srt = 180, adj = 0.5, label.offset = .2, underscore = TRUE)
mtext(substitute(paste(bold('c'))), adj = adj_label, line = line_label, cex = label_size)
axis(side = 2, at = c(0, 2.5, 5, 7.5), line = 1.5, labels = c(0,  expression(paste("2.5", theta)), expression(paste("5", theta)), expression(paste("7.5", theta))), las = 1, cex.axis = .75)

plot.phylo(time_balanced_8,   direction = "downwards", srt = 180, adj = 0.5, label.offset = .2, underscore = TRUE)
mtext(substitute(paste(bold('d'))), adj = adj_label, line = line_label, cex = label_size)

dev.off()
