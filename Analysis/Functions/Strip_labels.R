getStripLabels <- function(data) {
  
  Final_light <- expression(Irradiance~(mu*mol~m^{-2}~s^{-1}))
  Final_strain <- expression('Strain ('*italic(Chrysochromulina~leadbeateri)*")")
  
  data$Light_lab <- gl(n = 1, k = dim(data)[1], labels = Final_light)
  
  data$Strain_lab <- gl(n = 1, k = dim(data)[1], labels = Final_strain)
  
  return(data)
}