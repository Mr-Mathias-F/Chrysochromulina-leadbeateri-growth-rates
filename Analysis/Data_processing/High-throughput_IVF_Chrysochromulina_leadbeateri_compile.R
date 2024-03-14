######################################
##### Set correct work directory #####
######################################

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

require(readr)  # for read_csv()
require(dplyr)  # for mutate()
require(tidyr)  # for unnest()
require(purrr)  # for map(), reduce()
library(lubridate) # formatting dates
library(ggplot2) # for graphical plotting
library(broom)
library(modelr)
library(writexl)

#####################
##### Load data #####
#####################

# The lines below (disabled by default) load all the raw data
# using another script with source() to run it inside
# this script

# source("High-throughput_IVF_Chrysochromulina_leadbeateri_data_processing_exp1.R") 

#########################################
# Process raw data from experiment nr.1 #
#########################################

# source("High-throughput_IVF_Chrysochromulina_leadbeateri_data_processing_exp2.R") 

#########################################
# Process raw data from experiment nr.2 #
#########################################

# source("High-throughput_IVF_Chrysochromulina_leadbeateri_data_processing_exp4.R") 

#########################################
# Process raw data from experiment nr.4 #
#########################################

#########################################################
##### Merge all data together into a new data.frame #####
#########################################################

df_final_exp1 %>%
  add_row(df_final_exp2) %>%
  add_row(df_final_exp4)-> df_htcl 

########################################################
##### Save full data.frame as csv2 or RData object #####
########################################################

# setwd("../Dataset/")
# write_csv2(df_htcl, file = "HTCL_final_dataset_metadata.csv")

# The files aboves saves the data.frame as a csv2 file and
# stores it in the Dataset directory. This is disabled
# by default in this script
