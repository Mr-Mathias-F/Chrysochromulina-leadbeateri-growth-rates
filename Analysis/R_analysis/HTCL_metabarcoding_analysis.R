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

library(tidyverse)
library(viridis)
library(ggh4x)
library(rnaturalearth)
library(rnaturalearthdata)
library(rnaturalearthhires)
library(ggrepel)
library(ggspatial)
library(patchwork)

#############################
# Load themes and functions #
#############################

source("../Functions/Custom_ggplot2_themes.R")
`%!in%` = Negate(`%in%`)

#############################
#     1. THEME              #
#     2. THEME2             #
#     3. THEME3             #
#     3. Strips_color       #
#############################

######################################
##### Read stored data from file #####
######################################

metaPR2_data_analysis <- read_csv2("../Dataset/metaPR2_Chrysochromulina_leadbeateri.csv")

str(metaPR2_data_analysis) # Structure of the final dataset
dim(metaPR2_data_analysis) # The number of rows (375) and columns (47) of the dataset

#######################################################################################
#  Variables (stored in df_htcl_analysis):                                            #
#                                                                                     #    
#  1. depth: The depth (m) where the sample was taken                                 #  
#  2. salinity: The measured salinity of the sampling location                        #
#  3. temperature: The measured temperature of the sampling location                  #
#  4. asv_code: The amplicon sequence variant code for Chrysochromulina leadbeateri   #
#  5. n_reads_pct: The percentage of total reads in sample                            #
#  6. longitude: The longitude coordinates of sampling location                       #
#  7. latitude: The latitude coordinates of sampling location                         #
#                                                                                     #
#######################################################################################

####################################################
# Summary table of the dataset grouped by asv code #
####################################################

metaPR2_data_analysis %>%
  group_by(asv_code) %>%
  summarise(Temperature_mean = mean(temperature, na.rm=TRUE), Salinity_mean = mean(salinity, na.rm=TRUE), 
            Temperature_sd = sd(temperature, na.rm=TRUE), Salinity_sd = sd(salinity, na.rm=TRUE), n = length(salinity),
            Temperature_median = median(temperature, na.rm=TRUE), Salinity_median = median(salinity, na.rm=TRUE),
            Temperature_min = min(temperature), Temperature_max = max(temperature),
            Salinity_min = min(salinity), Salinity_max = max(salinity)) %>%
  filter(asv_code %!in% c("28264279ed", "78aa74d2d0"))

# Give a table of:
#   Average temperature with standard deviation
#   Average salinity with standard deviation
#   Number of samples per ASV

#################################
# Salinity and temperature plot #
#################################

metaPR2_data_analysis %>%
  filter(!is.na(depth_range)) %>%
  ggplot(aes(x = salinity, y = temperature, color = asv_code)) + 
  scale_color_viridis_d(name = "Amplicon sequence \nvariant code") + 
  geom_point(size = 4, alpha = 0.75, size = 10) + theme_bw() + THEME2 +
  labs(x = "Salinity", y = "Temperature (\u00B0C)") + 
  guides(color = guide_legend(override.aes = list(size = 4))) + scale_y_continuous(breaks = seq(-5,30,5)) 

world <- ne_countries(scale = "large", returnclass = "sf")
ggplot(data = world) + 
  geom_sf() +
  theme_minimal() + 
  geom_point(data = metaPR2_data_analysis, aes(x = longitude, y = latitude, col = asv_code, size = n_reads_pct), alpha = 0.75) +
  scale_color_viridis_d(name = "Amplicon sequence \nvariant code")  +
  scale_size(breaks = c(0.01, 0.1, as.integer(c(1, 5, 10))), range= c(2,10),
             name = "Read %", guide = guide_legend(override.aes = list(fill = "transparent"))) + 
  THEME2 + 
  guides(color = guide_legend(override.aes = list(size = 6))) +
  labs(y = "Latitude", x = "Longitude")

#####################################################################
# Seasonal number of samples positive for C.leadbeateri and density #
#####################################################################

# Number of samples (per month)

metaPR2_data %>%
  mutate(month = factor(month.abb[month(date)], levels = month.abb)) %>%
  group_by(asv_code) %>%
  filter(length(asv_code) > 1) %>%
  ggplot(aes(x = month, group = asv_code, col = asv_code)) + geom_point(stat = "count", size = 3) + geom_line(stat = "count", size = 1.25) +
  scale_color_viridis_d(name = "Amplicon sequence \nvariant code") + theme_bw() + THEME2 +
  labs(x = "Month", y = "Number of samples") + 
  guides(color = guide_legend(override.aes = list(size = 3))) + scale_y_continuous(breaks = seq(0, 150, 5))

# Number of samples (per year)

metaPR2_data %>%
  mutate(year = year(date)) %>%
  group_by(asv_code) %>%
  filter(length(asv_code) > 1) %>%
  ggplot(aes(x = as.factor(year), fill = asv_code)) +  geom_bar(stat = "count", position = "dodge") +
  scale_fill_viridis_d(name = "Amplicon sequence \nvariant code") +  theme_bw() + THEME2 +
  labs(x = "Year", y = "Number of samples") + 
  guides(color = guide_legend(override.aes = list(size = 3))) + scale_y_continuous(breaks = seq(0, 150, 5))

##################################
# Map of the affected bloom area #
##################################

# Load map from the R package

world_norway <- ne_countries(scale = "large", returnclass = "sf")

# Map for Norway with affected bloom area outlined

Norway_map <- ggplot(data = world_norway ) + geom_sf() + coord_sf(xlim = c(4, 32), ylim = c(57.7, 73), expand = F) + theme_minimal() +
  annotate(geom = "rect", 
           xmin = 12.5, xmax = 28, ymin = 67.5, ymax = 71, 
           fill = "red", alpha = 0.3) +
  theme(
    #give white background and black border
    panel.background = element_rect(fill = "white", colour = "black"), 
    plot.margin = margin(), #remove margins
    axis.text.x=element_blank(),
    axis.ticks.x=element_blank(),
    axis.text.y=element_blank(),
    axis.ticks.y=element_blank() 
  ) 

# Labels for strain with longitude and latitude

Strain_NN <- c("UIO035", "UIO393", "UIO394")
Strain_Lat_NN <- c(68.4, 69.64, 69.40)
Strain_Long_NN <- c(15.85, 18.86, 19.03)

NN_labels <- data.frame(Label_NN, Lat_NN, Long_NN)
Strain_labels <- data.frame(Strain = Strain_NN, Strain_Lat_NN, Strain_Long_NN)

# Plotting the affected area with label information

Affected_area <- ggplot(data = world_norway ) + geom_sf() + coord_sf(ylim = c(67.5, 71), xlim = c(12.5, 28)) + theme_bw() +
  labs(x = "Longitude", y = "Latitude") + THEME2 + 
  geom_point(data = Strain_labels, aes(x = Strain_Long_NN, y = Strain_Lat_NN, col = Strain), size = 7) +
  guides(color = guide_legend(override.aes = list(size = 7))) + annotation_scale(location = "tr") + 
  scale_color_manual(values = c("#f15922", "#cbdb2a", "#524fa2"))

Affected_area <- ggplot(data = world_norway ) + geom_sf() + coord_sf(ylim = c(67.5, 72.5), xlim = c(12.5, 31.2)) + theme_minimal() +
  geom_text_repel(data = NN_labels, aes(x = Long_NN, y = Lat_NN, label = Label_NN), box.padding = 0.5) + 
  labs(x = "Longitude", y = "Latitude") + THEME2 + 
  geom_point(data = Strain_labels, aes(x = Strain_Long_NN, y = Strain_Lat_NN, col = Strain), size = 3) +
  guides(color = guide_legend(override.aes = list(size = 6))) + annotation_scale(location = "tr") + 
  scale_color_manual(values = c("#00aeef", "#00ab5c", "#e12e28"))

# Combining both maps

Combined <- Affected_area +   inset_element(Norway_map, 
                                            left = 0, 
                                            right = 0.35, 
                                            top = 0.99, 
                                            bottom = 0.65)
Combined