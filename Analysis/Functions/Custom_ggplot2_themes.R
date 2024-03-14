#########################################
##### Custom ggplot2 theme settings #####
#########################################

##############
# Theme nr.1 #
##############

{THEME <- theme(axis.text.x=element_text(size=rel(2.2)), 
                axis.text.y = element_text(size=rel(2.2)),
                strip.text.x = element_text(size = rel(2)),
                strip.text.y = element_text(size = rel(2)),
                legend.text = element_text(size=rel(1.2)),
                legend.title = element_text(size=rel(1.7), face = "italic"),
                axis.title.x = element_text(size = rel(2)),
                axis.title.y =element_text(size = rel(2)),
                legend.key.width = unit(1, "cm"), 
                legend.key.size = unit(1.7, "cm"), 
                legend.title.align = 0.5,
                strip.background = element_rect(size = rel(0.5)))}

# Theme nr.1 (THEME) is used in some of the plots to adjust size and position
# of text and keys in plots

##############
# Theme nr.2 #
##############

{THEME2 <- theme(axis.text.x=element_text(size=rel(2.0)), 
                 axis.text.y = element_text(size=rel(2.5)),
                 strip.text.x = element_text(size = rel(2.7)),
                 strip.text.y = element_text(size = rel(2.7)),
                 legend.text = element_text(size=rel(2.2)),
                 legend.title = element_text(size=rel(2.7)),
                 axis.title.x = element_text(size = rel(2.7)),
                 axis.title.y =element_text(size = rel(2.7)),
                 legend.key.width = unit(1, "cm"), 
                 legend.key.size = unit(1.7, "cm"), 
                 legend.title.align = 0.5,
                 strip.background = element_rect(size = rel(0.5)),
                 plot.title = element_text(hjust = 0.5, size = rel(2.2)))}

# Theme nr.2 (THEME2) is used in some of the plots to adjust size and position
# of text and keys in plots. This theme is slightly bigger than theme nr. 1

######################
# Custom strip color #
######################

{
  Strips_color <- elem_list_rect(fill = c("#B9B9B9", '#d9d9d9'))
}

# Custom strip color (Strips_color) is for the strips used in some of the 
# plots below (e.g. heatmaps) to give them appropriate and uniform color