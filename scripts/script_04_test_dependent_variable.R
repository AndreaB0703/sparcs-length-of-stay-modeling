library(performance)
library (sjPlot)
library (car)
library(influence.ME)
library(ggeffects)
library(fitdistrplus)
library(here)


# Load sparcs_hf
sparcs_hf <- readRDS("data/processed_data/sparcs_hf.rds")
#check
glimpse(sparcs_hf)

#check assimetry los = high assimetry = indicates glmm gamma link log  
hist(sparcs_hf$los)

##check assimetry with qqPlot (two outliers lines 11989 and 26490)
car::qqPlot(sparcs_hf$los)
#save as figure
png(filename = here("output", "qqPlot_los.png"),
    res=600, width = 6, height=4.5, units = "in")
car::qqPlot(sparcs_hf$los)
dev.off()

#check Cullen and Frey graph 
fitdistrplus::descdist((sparcs_hf$los))
#save as figure
png(filename = here("output", "Cullen_Frey_los.png"),
    res=600, width = 6, height=4.5, units = "in")
fitdistrplus::descdist(sparcs_hf$los)
dev.off()