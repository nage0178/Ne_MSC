dims <- 6

arrow <- function( dims) {
  wd <- 8
  text_size <- 2.75
  pdf("~/Ne_MSC_write/manuscript/figs/arrow.pdf", height = dims, width = dims *.2)
  
  par(mar = c(.1, .1, .1, .1))
  
  plot.new()
  xlim <- 1.05
  shift <- .1
  plot.window(xlim = c(-xlim +shift, xlim *.1 +shift), ylim = c(1, 4 *1.1))
  
  lines(x = c(0,0), c(1, 4), lwd =wd)
  lines(x = c(-.05 *2.5,0), c(1.05 *1.2, 1), lwd =wd)
  lines(x = c(.05 *2.5,0), c(1.05 *1.2, 1), lwd =wd)
  
  text(-.4, 2.5 , "time", cex=text_size, srt =90)
  
  #text(-.6, 1.25 , "time\npresent", cex=text_size)
  

  dev.off()

}

arrow(dims)

const <- function( dims) {
  wd <- 8
  text_size <- 2.75
  pdf("~/Ne_MSC_write/manuscript/figs/constant.pdf", height = dims, width = dims)

  par(mar = c(.1, .1, .1, .1))
  
  plot.new()
  xlim <- 1 * 1.4
  plot.window(xlim = c(-xlim, xlim), ylim = c(1, 4 *1.1))
  
  lines(x = c(-1, -1), c(1, 4), lwd =wd)
  lines(x = c(1, 1), c(1, 4), lwd =wd)
  
 
    text(-1.4, 4.4 , "a", cex = text_size *1.4, font=2)
    text(0, 4.3 , "constant", cex=text_size)
    
    text(-1.2,2.5, "N", cex = text_size)
    
    x_shade <- c(-1, -1, 1, 1)
    y_shade <- c(1, 4, 4,1)
    polygon(
      x = x_shade,
      y = y_shade,
      col = rgb(0.0, 0.0, 0.0, alpha = 0.1),
      border = NA
    )
  
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
  plot.window(xlim = c(-xlim, xlim), ylim = c(1, 4 *1.1))
  
  lines(x = c(-1, -1), c(1, 2), lwd =wd)
  lines(x = c(1, 1), c(1, 2), lwd =wd)
  
  x_shade <- c(-1, -1, 1, 1)
  y_shade <- c(1, 2, 2,1)
  polygon(
    x = x_shade,
    y = y_shade,
    col = rgb(0.0, 0.0, 0.0, alpha = 0.1),
    border = NA
  )
  
  yshift <- 1
  lines(x = c(-1 *n_piecewise, -1*n_piecewise), c(1 + yshift, 2+ yshift), lwd =wd)
  lines(x = c(1 *n_piecewise, 1*n_piecewise), c(1 + yshift, 2+ yshift), lwd =wd)
  lines(x = c(-1, -1 *n_piecewise), y = c(1,1)+ yshift, lwd =wd)
  lines(x = c(-1, -1 *n_piecewise) * -1, y = c(1,1)+ yshift, lwd =wd)
  
  x_shade <- c(-1, -1, 1, 1) * n_piecewise
  y_shade <- c(1, 2, 2,1) + yshift
  polygon(
    x = x_shade,
    y = y_shade,
    col = rgb(0.0, 0.0, 0.0, alpha = 0.1),
    border = NA
  )
  
  yshift <- yshift + 1
  lines(x = c(-1, -1), c(1, 2) + yshift, lwd =wd)
  lines(x = c(1, 1), c(1, 2) + yshift, lwd =wd)
  
  lines(x = c(-1, -1 *n_piecewise), y = c(1,1)+ yshift, lwd =wd)
  lines(x = c(-1, -1 *n_piecewise) * -1, y = c(1,1)+ yshift, lwd =wd)
  
  x_shade <- c(-1, -1, 1, 1)
  y_shade <- c(1, 2, 2,1) + yshift
  polygon(
    x = x_shade,
    y = y_shade,
    col = rgb(0.0, 0.0, 0.0, alpha = 0.1),
    border = NA
  )
  
  if (n_piecewise == 10) {
    text(-12.5, 4.4 , "e", cex = text_size *1.4, font=2)
    text(0, 4.3 , "piecewise larger", cex = text_size )
    text(-2.5, 1.5, "N", cex = text_size)
    text(-12.5, 2.5, "10N", cex = text_size)
    text(-2.5, 3.5, "N", cex = text_size)
    
  } else {
    text(-1.4, 4.4 , "d", cex = text_size *1.4, font=2)
    text(0, 4.3 , "piecewise smaller", cex = text_size )
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
  
  xlim1 <- -.2
  curve(.01 * exp(log(100) *x), from = 0, to = 1, 
        xlab = "", ylab = "", axes = FALSE, xlim = c(xlim1, 2), ylim = c(-0.45, 1.05), lwd =wd)
  lines(x = c(0, 2), y = c(0,0), lwd =wd)
  lines(x= c(1, 2), y = c(1, 1), lwd =wd)
  lines(x= c(1, 1), y = c(0, 1), lty = 2, lwd =wd)
  
  if (smaller == 1) {
    text(xlim1, -.45 , "b", cex = text_size *1.4, font=2, srt = 90)
   text(-.1, .5 , "exponential\nsmaller", cex = text_size, srt = 90)
  #mtext("exponential smaller", 0, -.45 ,  cex = text_size, srt = 0)
    
    text(-0, -.19, "0.01N", srt = 90, cex = text_size)
    text(1.5, -.08, "N", srt = 90, cex = text_size) 
  } else {
    text(xlim1, -.25 , "c", cex = text_size *1.4, font=2, srt = 90)
    text(-.1, .5 , "exponential\nlarger", cex = text_size, srt = 90)
    
    text(-0, -.08, "N", srt = 90, cex = text_size)
    text(1.5, -.19, "100N", srt = 90, cex = text_size)
  }
  
  x_shade <- seq(0, 1, length.out = 200)
  y_shade <- .01 * exp(log(100) *x_shade)
  
  polygon(
    x = c(0, x_shade, 1),
    y = c(0, y_shade, 0),
    col = rgb(0.0, 0.0, 0.0, alpha = 0.1),
    border = NA
  )
  
  x_shade <- c(1, 1, 2, 2)
  y_shade <- c(0, 1, 1,0)
  polygon(
    x = x_shade,
    y = y_shade,
    col = rgb(0.0, 0.0, 0.0, alpha = 0.1),
    border = NA
  )

  #g <- grab_grob()
  #grid.newpage()
  #pushViewport(viewport(width=0.7,angle=270))
  #grid.draw(g)
  dev.off()
}
exponential(1, dims)
exponential(0, dims)

