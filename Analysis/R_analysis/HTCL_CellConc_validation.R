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

#################
# Load function #
#################

source("../Functions/Custom_ggplot2_themes.R")

######################################
##### Read stored data from file #####
######################################

CellConc_IVF_control <- read_csv2("../Dataset/HTCL_dataset_validation.csv")

str(CellConc_IVF_control)
summary(CellConc_IVF_control)
options(scipen = 100000)

#####################################################
##### Linear regression Cell_conc (y) ~ IVF (x) #####
#####################################################

Validate_CellConc_IVF <- lm(Cell_conc ~ IVF_mean, data = CellConc_IVF_control)

CellConc_IVF_control %>%
  ggplot(aes(x = IVF_mean, y = Cell_conc)) + geom_point(size = 6)  + theme_bw() +
  geom_abline(intercept = coef(Validate_CellConc_IVF)[1], slope = coef(Validate_CellConc_IVF)[2], linewidth = 2, linetype = 2, col = "grey") +
  THEME + 
  labs(x = "Chlorophyll-a (fluorescence intensity units)", y = expression(Cell~concentration~(cells~mL^{-1}))) +
  scale_x_continuous(breaks = seq(0,5000, 500)) + scale_y_continuous(breaks = seq(0, 500000, 50000)) +
  theme(axis.text.x = element_text(size = rel(2.6)),
        axis.text.y = element_text(size = rel(2.6)),
        axis.title.x = element_text(size = rel(2.6)),
        axis.title.y = element_text(size = rel(2.6)))

###############################
##### CellConc ~ Time (d) #####
###############################

CellConc_IVF_control %>%
  group_by(Day) %>%
  summarise(CellConc_mean_day = mean(Cell_conc),
            CellConc_sd_day = sd(Cell_conc)) %>%
  ggplot(aes(x = Day, y = CellConc_mean_day) ) + theme_bw() +
  THEME + geom_line(linewidth = 2, linetype = 2, col = "grey") + geom_point(size = 6)  + 
  labs(x = "Time (d)", y = expression(Cell~concentration~(cells~mL^{-1}))) + 
  geom_errorbar(aes(ymin = CellConc_mean_day - CellConc_sd_day, 
                    ymax = CellConc_mean_day + CellConc_sd_day),
                    width = 0.5) +
  scale_x_continuous(breaks = seq(0,15, 1)) + scale_y_continuous(breaks = seq(0, 400000, 50000)) +
  theme(axis.text.x = element_text(size = rel(2.6)),
        axis.text.y = element_text(size = rel(2.6)),
        axis.title.x = element_text(size = rel(2.6)),
        axis.title.y = element_text(size = rel(2.6)))

#######################################
##### IVF fluorescence ~ Time (d) #####
#######################################

CellConc_IVF_control %>%
  group_by(Day) %>%
  summarise(IVF_mean_day = mean(IVF_mean),
            IVF_sd_day = sd(IVF_mean)) %>%
  ggplot(aes(x = Day, y = IVF_mean_day) ) + 
  theme_bw() +
  THEME + geom_line(linewidth = 2, linetype = 2, col = "grey") + 
  geom_point(size = 6)  + 
  labs(x = "Time (d)", y = "Chlorophyll-a (fluorescence intensity units)") + 
  geom_errorbar(aes(ymin = IVF_mean_day - IVF_sd_day, 
                    ymax = IVF_mean_day + IVF_sd_day),
                    width = 0.5) +
  scale_x_continuous(breaks = seq(0,15, 1)) + 
  scale_y_continuous(breaks = seq(0, 5000, 500)) +
  theme(axis.text.x = element_text(size = rel(2.6)),
        axis.text.y = element_text(size = rel(2.6)),
        axis.title.x = element_text(size = rel(2.6)),
        axis.title.y = element_text(size = rel(2.6)))

#################################################
# Maximum growth rate (CellConc vs IVF method) ##
#################################################

# Using the growthrates library to estimate maximum specific growth rates with splines

IVF_mu_max <- all_splines(IVF_mean ~ Day | Replicate, data = CellConc_IVF_control, spar = 0.5) 
Cell_conc_mu_max <- all_splines(Cell_conc ~ Day | Replicate, data = CellConc_IVF_control, spar = 0.5) 

# Extract results and unite into a single data.frame

IVF_mu_max_results <- tibble(results(IVF_mu_max)) 
Cell_conc_mu_max_results <- tibble(results(Cell_conc_mu_max)) 

# Preparing dataframe for analysis

IVF_mu_max_results %>%
  add_row(Cell_conc_mu_max_results) %>%
  add_column(Method = c(rep("Cell counting", 3), rep("IVF", 3))) -> IVF_CellConc_mumax

# t-test

t.test(mumax ~ Method, data = IVF_CellConc_mumax, var.equal = T)

# No significant (p-value = 0.3487)

IVF_CellConc_mumax %>%
  group_by(Method) %>%
  summarise(method_mumax = mean(mumax),
            method_mumax_sd = sd(mumax)) %>%
  ggplot(aes(x = Method, y = method_mumax) ) +
  theme_bw() +
  THEME + 
  geom_bar(stat = "identity", width = 0.4)  + 
  labs(x = "Method", y = expression("Observed maximum specific growth rate"~"("*d^{-1}*")")) + 
  geom_errorbar(aes(ymin = method_mumax - method_mumax_sd, 
                    ymax = method_mumax + method_mumax_sd),
                    width = 0.2) +
  scale_y_continuous(breaks = seq(0, 0.6, 0.05)) +
  theme(axis.text.x = element_text(size = rel(2.6)),
        axis.text.y = element_text(size = rel(2.6)),
        axis.title.x = element_text(size = rel(2.6)),
        axis.title.y = element_text(size = rel(2.6)))