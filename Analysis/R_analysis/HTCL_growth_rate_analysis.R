######################################
##### Set correct work directory #####
######################################

# This step is important to set correct
# work directory to run this script

#####################
# For RStudio users #
#####################

library(rstudioapi)
work_dir <- getActiveDocumentContext()$path
setwd(dirname(work_dir))

# The RStudio method for setting work
# directory is enabled by default

#######################
# For vanilla R users #
#######################

# library(utils)
# work_dir <- getSrcDirectory()[1]
# setwd(dirname(work_dir))

# The vanilla R method for setting work
# directory is disabled by default in
# this script. Remove the hash signs (#)
# from the beginning of each line to 
# enable.

#######################################
##### Load packages and functions #####
#######################################

#################
# Load packages #
#################

library(readr)  # for read_csv()
library(dplyr)  # for mutate()
library(tidyr)  # for unnest()
library(purrr)  # for map(), reduce()
library(lubridate)
library(ggplot2)
library(growthrates)
library(ggh4x)
library(viridis)

#############################
# Load themes and functions #
#############################

source("../Functions/Custom_ggplot2_themes.R")

#############################
#     1. THEME              #
#     2. THEME2             #
#     3. Strips_color       #
#############################

source("../Functions/Specific_growth_rate_function.R")

#############################
#        Mu_growth()        #
#############################

source("../Functions/Strip_labels.R")

#################################
#        getStripLabels()       #
#################################

source("../Functions/Python_csv_export.R")

####################################
#        GAM_python_export()       #
####################################

source("../Functions/Timecurve_plot.R")

##################################
#        timecurveGrowth()       #
#       timecurveGrowthLog()     #
##################################

#####################################
##### Process data from scratch #####
#####################################

# setwd("../Data_processing")
# for (dat_processing in dir(pattern = "*exp")) {
#   source(dat_processing)
# }
# source("High-throughput_IVF_Chrysochromulina_leadbeateri_compile.R")
# setwd("../R_analysis")

# The final processed dataset object is called df_htcl

# str(df_htcl) # Structure of the final dataset
# dim(df_htcl) # The number of rows (51456) and columns (29) of the dataset

# The data processing from the growth experiments are disabled
# by default in the script. Remove the hash sign (#) in front of 
# the lines to enable raw data processing.

######################################
##### Read stored data from file #####
######################################

df_htcl <- read_csv2("../Dataset/HTCL_dataset_metadata.csv")
df_htcl$Strain <- as.factor(df_htcl$Strain)
levels(df_htcl$Strain) <- c("UIO035", "UIO393", "UIO394")

str(df_htcl) # Structure of the final dataset
dim(df_htcl) # The number of rows (51456) and columns (29) of the dataset

############################################################
##### Selection of relevant variables for the analysis ##### 
##### / estimation of maximum specific growth rate     #####
############################################################

##########################################
# Select relevant variables for analysis #
##########################################

df_htcl %>%
  select(Chl, Strain, Salinity, Temperature, Light_intensity, Day, Experiment.y, ID_unique, Timepassed) -> df_htcl_analysis 

# Selects relevant variables for analysis into a tibbles

#######################################################################################
# List of selected variables (stored in df_htcl_analysis):                            #
#                                                                                     #    
#  1. Chl: Measured chlorophyll a fluorescence in relative fluorescence untis (RFUs)  #
#  2. Strain: Strain of Chrysochromulina leadbeateri                                  #
#  3. Salinity: The salinity given in practical salinity units (PSUs)                 #
#  4. Temperature: The temperature given in Celsius (C)                               #
#  5. Light_intensity: The light intenstiy given in μmol photons m^-2 s^-1            #
#  6. Day: The number of days since starting the experiment (rounded to closest day)  #
#  7. Experiment.y: The experiment number / ID                                        #
#  8. ID_unique: A ID variable for each well on each plate                            #
#  9. Timepassed: The number of days since starting the experiment (exact time)       #
#                                                                                     #
#######################################################################################

##############################################################
# Adding +1 to all measured Chl A RFUs to avoid any log of 0 #
##############################################################

df_htcl_analysis$Chl <- if_else(df_htcl_analysis$Chl != 0, df_htcl_analysis$Chl, df_htcl_analysis$Chl + 1)

df_htcl_analysis$Strain <- as.factor(df_htcl_analysis$Strain)
levels(df_htcl_analysis$Strain) <- c("UIO035", "UIO393", "UIO394")


#######################################
##### Time curves for each strain #####
#######################################

########################
# Graphical parameters #
########################
{
df_htcl_analysis <- getStripLabels(data = df_htcl_analysis)
Temp_lab <- expression('Temperature ('*degree*C*')')
df_htcl_analysis$Temperature_lab <- gl(n = 1, k = dim(df_htcl_analysis)[1], labels = Temp_lab)
df_htcl_analysis$Salinity_lab <- rep("Salinity", times = dim(df_htcl_analysis)[1])
}
# Adds strip labels suitable for 
# plotting in ggplot2

################################
# Time curve (experiment nr.1) #
################################

# Log growth curves


timecurveGrowthLog(df_htcl_analysis, strain = NULL, experiment = 4) + 
  guides(color = guide_legend(override.aes = list(size = 4))) + 
  theme(axis.text.x = element_text(size = rel(2.7)), axis.text.y = element_text(size=rel(2.7)))

###############################
# Time curve (experiment nr.2) #
###############################

# Log growth curves

for (i in levels(df_htcl_analysis$Strain)){
growthPlot <- timecurveGrowthLog(df_htcl_analysis, strain = i, experiment = 1) + 
  theme(axis.text.y = element_text(size=rel(1.6)), axis.title = element_text(size = rel(0.65))) +
  guides(color = guide_legend(override.aes = list(size = 4)))

print(growthPlot)
}

#################################
# Time curve (experiment nr. 3) #
#################################

# Log growth curves

for (i in levels(df_htcl_analysis$Strain)){
timecurveGrowthLog(df_htcl_analysis, strain = i, experiment = 2) + 
  theme(axis.text.y = element_text(size=rel(1.6)), axis.title = element_text(size = rel(0.65))) +
  guides(color = guide_legend(override.aes = list(size = 4)))
  
  print(growthPlot)
}

######################################################
##### Estimation of maximum specific growth rate #####
######################################################

#######################
# Maximum growth rate #
#######################

df_htcl_analysis %>%
  filter(Day >=4) -> df_htcl_analysis_mu_max # Filters the data.frame by day >= 5

# Filters away the first 4 days of fluoresence measurements
# due to lag phase

df_htcl_analysis_mu_max_fit <- all_splines(Chl ~ Day | Strain + Salinity + Temperature +  Light_intensity + Experiment.y + ID_unique, 
                                           data = df_htcl_analysis_mu_max, spar = 0.5) 

# Smoothing spline-based method for estimation of
# maximum specific growth rate. The method is inspired
# by Kahm et al. (2010). Spline fitting is always done
# with log-transformed data, assuming exponential growth at the time
# point of the maximum of its first derivative. The smoothing
# parameter is equal to 0.5 for this experiment. The model above
# finds one parameter per well of the experiments, resulting
# in a total of 768 maximum growth parameters estimated
# from the experimental data (assuming 8 plates per experiment)

##############################
# Extract results from model #
##############################

df_htcl_mu_max_results <- tibble(results(df_htcl_analysis_mu_max_fit)) 

# Extracting the results from the smooth spline analysis and
# store it in a tibbles data structure

##########################################
# Filtering results before visualization #
##########################################

df_htcl_mu_max_results %>%
  group_by(Strain, Salinity, Temperature,  Light_intensity, Experiment.y) %>%
  filter(r2 >= 0.5) %>%
  summarise(MuMax_mean = mean(mumax), MuMax_sd = sd(mumax)) -> df_htcl_mu_max_results

# Filtering values with Rsquared less that 0.5
# Finding the mean value of the maximum specific growth rate with standard deviation

########################
# Graphical parameters #
########################
{
df_htcl_mu_max_results <- getStripLabels(df_htcl_mu_max_results)
}
# Adds strip labels suitable for 
# plotting in ggplot2

#####################################
# Mu max heatmaps, experiment nr. 1 #
#####################################

df_htcl_mu_max_results %>%
  filter(Experiment.y == 4) %>%
  ggplot(aes(as.factor(Temperature), as.factor(Salinity), fill= MuMax_mean)) + 
  geom_tile() +  
  scale_fill_viridis(breaks = seq(-0.1,0.55, by = 0.1),
                     name = expression("Observed maximum \nspecific growth rate"~"("*d^{-1}*")"), 
                     guide = guide_colourbar(title.position = "right", legend.key.width = unit(5, "cm"))) + 
  facet_grid2(cols = vars(Strain_lab, Strain), 
              strip = strip_nested(background_x = Strips_color,  by_layer_x = TRUE, 
                                   background_y = Strips_color, by_layer_y = TRUE), 
              labeller = "label_parsed", space="free", scales="free_x") + 
  theme_bw() + 
  THEME + 
  labs(x = "Temperature (\u00B0C)", y = "Salinity")

## Anova between-strain growth (experiment nr. 1)

df_htcl_mu_max_results %>%
  filter(Experiment.y == 4) -> aov_df_exp1

aov_exp1 <- lm(MuMax_mean ~ as.factor(Temperature) + as.factor(Salinity) + Strain, data = aov_df_exp1)

anova(aov_exp1)

#####################################
# Mu max heatmaps, experiment nr. 2 #
#####################################

df_htcl_mu_max_results %>%
  filter(Experiment.y == 1) %>%
  ggplot(aes(as.factor(Temperature), as.factor(Salinity), fill= MuMax_mean)) + 
  geom_tile() +  
  scale_fill_viridis(breaks = seq(-0.1,0.6, by = 0.1),
                     name = expression("Observed maximum \nspecific growth rate"~"("*d^{-1}*")"), 
                     guide = guide_colourbar(title.position = "right", legend.key.width = unit(5, "cm"))) + 
  facet_grid2(rows = vars(Strain_lab, Strain), cols = vars(Light_lab, Light_intensity), 
              strip = strip_nested(background_x = Strips_color,  by_layer_x = TRUE, 
                                   background_y = Strips_color, by_layer_y = TRUE), 
              labeller = "label_parsed", space="free", scales="free_x") + 
  theme_bw() + 
  THEME +
  labs(x = "Temperature (\u00B0C)", y = "Salinity") 

#####################################
# Mu max heatmaps, experiment nr. 3 #
#####################################

df_htcl_mu_max_results %>%
  filter(Experiment.y == 2, Temperature != 19) %>%
  ggplot(aes(as.factor(Temperature), as.factor(Salinity), fill= MuMax_mean)) + 
  geom_tile() +  
  scale_fill_viridis(breaks = seq(-0.1,0.6, by = 0.1),
                     name = expression("Observed maximum \nspecific growth rate"~"("*d^{-1}*")"), 
                     guide = guide_colourbar(title.position = "right", legend.key.width = unit(5, "cm"))) + 
  facet_grid2(rows = vars(Strain_lab, Strain), cols = vars(Light_lab, Light_intensity), 
              strip = strip_nested(background_x = Strips_color,  by_layer_x = TRUE, 
                                   background_y = Strips_color, by_layer_y = TRUE), 
              labeller = "label_parsed", space="free", scales="free_x") + 
  theme_bw() + 
  THEME + 
  labs(x = "Temperature (\u00B0C)", y = "Salinity") 

# Growth rates for temperature 19 C filtered out due to no growth
