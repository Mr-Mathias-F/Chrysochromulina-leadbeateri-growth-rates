GAM_python_export <- function(Model, Temperature_range, Salinity_range, file_name) {
  Gam_meshgrid <- meshgrid(seq(Temperature_range[1], Temperature_range[2], length = 100), seq(Salinity_range[1],Salinity_range[2], length = 100))
  names(Gam_meshgrid) <- c("Temperature", "Salinity")
  df_python <- data.frame(Temperature = c(Gam_meshgrid$Temperature), Salinity = c(Gam_meshgrid$Salinity), 
                          Mu = predict(Model, newdata = data.frame(Salinity = c(Gam_meshgrid$Salinity), Temperature = c(Gam_meshgrid$Temperature))))
  write_csv2(df_python, paste0("../Python_analysis/", file_name))
}

# This function takes a GAM model object with Temperature ranges, Salinity ranges
# and file name and produce a csv2 file for visualization in Python