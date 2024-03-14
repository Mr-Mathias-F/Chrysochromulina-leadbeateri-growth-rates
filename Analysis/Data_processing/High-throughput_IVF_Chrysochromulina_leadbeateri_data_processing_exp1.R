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

###############################
##### Creat list of files #####
###############################

data_path <- "../Experiment_nr1_plates"   # path to the data
files <- dir(data_path, pattern = "*.csv") # get file 

#####################
##### Load data #####
#####################

data <- tibble(filename = files) %>% # create a data frame
  mutate(file_contents = map(filename,          # read files into
                             ~ read_csv2(file.path(data_path, .)) %>% 
                               rename(Row = 1) %>% 
                               select(Row:`12`) %>% 
                               pivot_longer(cols = `1`:`12`, names_to = "Col", values_to = "Chl") %>%
                               unite("ID", Row:Col, sep="", remove = FALSE)))  %>% 
  unnest(cols = c(filename, file_contents)) %>% 
  separate(filename, c("Date","Time", "Experiment", "Plate"), sep = "_") %>% 
  separate(Plate, c("Plate","leftover2"), sep = -4) %>% 
  separate(Plate, c("leftover3", "Plate"), sep = 5) %>% 
  unite("ID_unique", c("ID","Plate"), sep = "_", remove = FALSE) %>% 
  select(-starts_with("lefto")) %>% 
  unite("Date_Time", c("Date","Time"), sep = "", remove = FALSE) %>% 
  mutate(Date = ymd(Date)) -> data

#########################
##### Load metadata #####
#########################

setwd("../Metadata")
expdata <- read_csv2("ToxANoWa_Cleadbeateri_Plate_Variable_values_exp1.csv")

###########################################
##### Merge metadata with loaded data #####
###########################################

data %>% 
  left_join(expdata, by=("ID_unique") ) %>% 
  mutate(Date_Time = ymd_hm(Date_Time)) %>% 
  mutate(Timepassed = int_length(interval(ymd_hms("2022-06-10 21:28:00"), Date_Time))) %>% #Change date (yyyy-mm-dd) and time of first measurement
  mutate(Timepassed = Timepassed/ (60*60*24)) %>% 
  unite("Strain_Experiment_Replicate", c("Strain","Experiment.y", "Replicate"), sep = "_", remove = FALSE) %>% 
  unite("Strain_Experiment", c("Strain","Experiment.y"), sep = "_", remove = FALSE) -> df_final_exp1
df_final_exp1 %>%
  mutate(Day = round(Timepassed)) -> df_final_exp1

##########################################
##### Back to Data processing folder #####
##########################################

setwd("../Data_processing/")
