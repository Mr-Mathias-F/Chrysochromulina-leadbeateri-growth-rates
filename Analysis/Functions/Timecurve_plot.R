

timecurveGrowth <- function(data, strain, experiment) {
  
if (length(strain) == 1) {  

data %>%
  filter(Strain == strain, Experiment.y %in% experiment) %>%
  group_by(Temperature, Light_intensity, Salinity, Day) %>%
  ggplot(aes(Day, Chl)) + geom_point(aes(col = as.factor(Salinity)), size = 2.2)  +
  scale_x_continuous(breaks = seq(0,25,5))  + theme_bw() + THEME2 + 
  labs(x = "Time (d)", y = "Chlorophyll-a (fluorescence intensity units)")  + 
  scale_color_manual(values = c("#39568CFF", "#55C667FF", "#FDE725FF", "#D1495BFF"), name = "Salinity", guide = guide_legend(title.position = "right", keywidth = unit(1.5, "cm"),
  keyheight = unit(1.5, "cm"))) + facet_grid2(rows = vars(Temperature_lab, Temperature), cols = vars(Light_lab, Light_intensity), 
  strip = strip_nested(background_x = Strips_color,  by_layer_x = TRUE, 
  background_y = Strips_color, by_layer_y = TRUE), 
  labeller = "label_parsed")
}
else {
  
data %>%
  filter(Experiment.y %in% c(4)) %>%
  group_by(Temperature, Light_intensity, Salinity, Day) %>%
  ggplot(aes(Day, Chl)) + geom_point(aes(col = as.factor(Salinity)), size = 2.2)  +
  scale_x_continuous(breaks = seq(0,14,1))  + theme_bw() + THEME2 + 
  labs(x = "Time (d)", y = "Chlorophyll-a (fluorescence intensity units)")  + 
  scale_color_manual(values = c("#39568CFF", "#55C667FF", "#FDE725FF", "#D1495BFF"), name = "Salinity", guide = guide_legend(title.position = "right", keywidth = unit(1.5, "cm"),
  keyheight = unit(1.5, "cm"))) + facet_grid2(rows = vars(Temperature_lab, Temperature), cols = vars(Strain_lab, Strain), 
  strip = strip_nested(background_x = Strips_color,  by_layer_x = TRUE, 
  background_y = Strips_color, by_layer_y = TRUE), 
  labeller = "label_parsed")
}
  
}

timecurveGrowthLog <- function(data, strain, experiment) {
  
if (length(strain) == 1) {  
    
data %>%
  filter(Strain == strain, Experiment.y %in% experiment) %>%
  group_by(Temperature, Light_intensity, Salinity, Day) %>%
  ggplot(aes(Day, Chl)) + geom_point(aes(col = as.factor(Salinity)), size = 3)  +
  scale_x_continuous(breaks = seq(0,25,5))  + theme_bw() + THEME2 + 
  labs(x = "Time (d)", y = "Chlorophyll-a (fluorescence intensity units)")  + scale_y_log10() +
  scale_color_manual(values = c("#39568CFF", "#55C667FF", "#FDE725FF", "#D1495BFF"), name = "Salinity", guide = guide_legend(title.position = "right", keywidth = unit(1.5, "cm"),
  keyheight = unit(1.5, "cm"))) + facet_grid2(rows = vars(Temperature_lab, Temperature), cols = vars(Light_lab, Light_intensity), 
  strip = strip_nested(background_x = Strips_color,  by_layer_x = TRUE, 
  background_y = Strips_color, by_layer_y = TRUE), 
  labeller = "label_parsed")
  }
else {
    
    
data %>%
  filter(Experiment.y %in% c(4)) %>%
  group_by(Temperature, Light_intensity, Salinity, Day) %>%
  ggplot(aes(Day, Chl)) + geom_point(aes(col = as.factor(Strain)), size = 3)  +
  scale_x_continuous(breaks = seq(0,14,2))  + theme_bw() + THEME2 + 
  labs(x = "Time (d)", y = "Chlorophyll-a (fluorescence intensity units)")  + scale_y_log10() +
  scale_color_manual(values = c("#39568CFF", "#55C667FF", "#FDE725FF", "#D1495BFF"),
                        name = "Strain", guide = guide_legend(title.position = "right", keywidth = unit(1.5, "cm"),
  keyheight = unit(1.5, "cm"))) + facet_grid2(rows = vars(Temperature_lab, Temperature), cols = vars(Salinity_lab, Salinity), 
  strip = strip_nested(background_x = Strips_color,  by_layer_x = TRUE, 
  background_y = Strips_color, by_layer_y = TRUE), 
  labeller = "label_parsed")
}
  
}
