dims <- 6

const <- function( dims) {
  wd <- 8
  text_size <- 2.75
  pdf("~/Ne_MSC_write/manuscript/figs/constant.pdf", height = dims, width = dims)

  par(mar = c(.1, .1, .1, .1))
  
  plot.new()
  xlim <- 1 * 1.4
  plot.window(xlim = c(-xlim, xlim), ylim = c(1, 4))
  
  lines(x = c(-1, -1), c(1, 4), lwd =wd)
  lines(x = c(1, 1), c(1, 4), lwd =wd)
  
 
    text(-1.4, 4 , "a", cex = text_size *1.4, font=2)
    text(-1.2,2.5, "N", cex = text_size)
  
  dev.off()
}
const(dims)

piecewise <- function(n_piecewise, dims) {
  wd <- 8
  text_size <- 2.75
  if (n_piecewise == 10)
    pdf("~/Ne_MSC_write/manuscript/figs/piecewise_larger.pdf", height = dims, width = dims)
  else 
    pdf("~/Ne_MSC_write/manuscript/figs/piecewise_smaller.pdf", height = dims, width = dims) 
  par(mar = c(.1, .1, .1, .1))
  
  plot.new()
  xlim <- max(1, n_piecewise ) * 1.4
  plot.window(xlim = c(-xlim, xlim), ylim = c(1, 4))
  
  lines(x = c(-1, -1), c(1, 2), lwd =wd)
  lines(x = c(1, 1), c(1, 2), lwd =wd)
  yshift <- 1
  lines(x = c(-1 *n_piecewise, -1*n_piecewise), c(1 + yshift, 2+ yshift), lwd =wd)
  lines(x = c(1 *n_piecewise, 1*n_piecewise), c(1 + yshift, 2+ yshift), lwd =wd)
  lines(x = c(-1, -1 *n_piecewise), y = c(1,1)+ yshift, lwd =wd)
  lines(x = c(-1, -1 *n_piecewise) * -1, y = c(1,1)+ yshift, lwd =wd)
  yshift <- yshift + 1
  lines(x = c(-1, -1), c(1, 2) + yshift, lwd =wd)
  lines(x = c(1, 1), c(1, 2) + yshift, lwd =wd)
  
  lines(x = c(-1, -1 *n_piecewise), y = c(1,1)+ yshift, lwd =wd)
  lines(x = c(-1, -1 *n_piecewise) * -1, y = c(1,1)+ yshift, lwd =wd)
  
  if (n_piecewise == 10) {
    text(-12.5, 4 , "e", cex = text_size *1.4, font=2)
    text(-2.5, 1.5, "N", cex = text_size)
    text(-12.5, 2.5, "10N", cex = text_size)
    text(-2.5, 3.5, "N", cex = text_size)
    
  } else {
    text(-1.4, 4 , "d", cex = text_size *1.4, font=2)
    text(-1.2,1.5, "N", cex = text_size)
    text(-0.4, 2.5, "0.1N", cex = text_size)
    text(-1.2, 3.5, "N", cex = text_size)
  }
  dev.off()
}

piecewise(.10, dims)
piecewise(10, dims)

exponential <- function(smaller, dims) {
  wd <- 8
  text_size <- 2.75
  if (smaller == 1)
    pdf("~/Ne_MSC_write/manuscript/figs/exp_smaller.pdf", height = dims, width = dims)
  else 
    pdf("~/Ne_MSC_write/manuscript/figs/exp_larger.pdf", height = dims, width = dims)
  par(mar = c(.1, .1, .1, .1))
  
  curve(.01 * exp(log(100) *x), from = 0, to = 1, 
        xlab = "", ylab = "", axes = FALSE, xlim = c(0, 2), ylim = c(-0.45, 1.05), lwd =wd)
  lines(x = c(0, 2), y = c(0,0), lwd =wd)
  lines(x= c(1, 2), y = c(1, 1), lwd =wd)
  lines(x= c(1, 1), y = c(0, 1), lty = 2, lwd =wd)
  
  if (smaller == 1) {
    text(0, -.45 , "b", cex = text_size *1.4, font=2, srt = 90)
    text(-0, -.19, "0.01N", srt = 90, cex = text_size)
    text(1.5, -.08, "N", srt = 90, cex = text_size) 
  } else {
    text(0, -.25 , "c", cex = text_size *1.4, font=2, srt = 90)
    text(-0, -.08, "N", srt = 90, cex = text_size)
    text(1.5, -.19, "100N", srt = 90, cex = text_size)
  }

  #g <- grab_grob()
  #grid.newpage()
  #pushViewport(viewport(width=0.7,angle=270))
  #grid.draw(g)
  dev.off()
}
exponential(1, dims)
exponential(0, dims)

