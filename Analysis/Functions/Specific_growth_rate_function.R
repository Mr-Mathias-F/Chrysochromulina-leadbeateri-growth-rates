########################################################################
##### Function for computing specific growth rate mu for each well #####
########################################################################

Mu_growth <- function(growth_data_frame, filter_day_start = 4, filter_day_end = 11, experiment = 1){
  library(tidyverse)
  Unique_ID <- unique(growth_data_frame$ID_unique)
  Length_ID <- length(Unique_ID)
  Growth_data <- growth_data_frame %>% filter(Day >= filter_day_start, Day <= filter_day_end, Experiment.y == experiment) %>%
  select(Chl, Temperature, Salinity, Light_intensity, Strain, ID_unique, Day)
  Mu_data <- tibble(Mu = numeric(),
                    Mu_SD = numeric(),
                    Rsq = numeric(),
                    Temperature = double(),
                    Salinity = numeric(),
                    Light_intensity = numeric(),
                    Strain = character(),
                    ID_unique = character())
  for (i in 1:Length_ID) {
    Growth_data_ID <- Growth_data %>% filter(ID_unique == Unique_ID[i])
    Mod <- lm(log(Chl) ~ Day, data = Growth_data_ID)
    Mod_df <- tibble(Mu = coef(Mod)[2], Mu_SD = summary(Mod)$coefficients[2,2], Rsq = summary(Mod)$r.squared, Growth_data_ID[1,2], 
                     Growth_data_ID[1,3], Growth_data_ID[1,4], Growth_data_ID[1,5], Growth_data_ID[1,6])
    Mu_data %>% add_row(Mod_df) -> Mu_data
  }
  return(Mu_data)
}

# The function above (Mu_growth()) compute and extracts the specific growth
# rate for each well after filtering the data from start day to end day. The
# growth rates are then compiled into a tibbles / data.frame for further analysis