library(lme4)
library(performance)
library (sjPlot)
library (DHARMa)
library (car)
library(influence.ME)
library(glmmTMB)
library(here)

# Load sparcs_hf
sparcs_hf <- readRDS("data/processed_data/sparcs_hf.rds")
#check
glimpse(sparcs_hf)


#create a GLMM gamma link log model - (wait 2 minutes) 
model_gamma_los <- glmer(los ~ age_group + sex +
                        race_group + payer_group + apr_severity +
                        proc_group + ed_admission + (1 | hospital_id),
                        data = sparcs_hf, family = Gamma(link = "log"))

#create a log normal model - (wait 2 minutes) 
model_lognormal_los <- glmmTMB(los ~ 
                                 age_group + sex + race_group + payer_group +
                                 apr_severity + proc_group + ed_admission +
                                 (1 | hospital_id), data = sparcs_hf,
                               family = lognormal())


#compare model_gamma_los and model_lognormal_los. delta=1235. model_gamma_los is massive better
AIC(model_gamma_los, model_lognormal_los)

#check model_gamma_los fit assessment
DHARMa::simulateResiduals(model_gamma_los) |> plot()
#save as figure
png(here("output","DHARMa_gamma_los.png"),
    res=600, width=6, height=4.5, units="in")
plot(DHARMa::simulateResiduals(model_gamma_los))
dev.off()

#check random residuals model_gamma_los
#warning:Non-normality for random effects 'hospital_id: (Intercept)' detected (p < .001).
#similar Shapiro_wilk/Kolmogov = high sensibility statistic test 
performance::check_normality(model_gamma_los, effects = "random") |>plot()
#save as figure
png(filename = here("output", "random_effects_gamma_los.png"),
    res=600, width = 6, height=4.5, units = "in")
performance::check_normality(model_gamma_los, effects = "random")
dev.off()

#check again with visual inspection model_gamma_los OK
qqnorm(ranef(model_gamma_los)$hospital_id[,1])
qqline(ranef(model_gamma_los)$hospital_id[,1])
#save as figure
png(filename = here("output", "random_effects_qqPlot_gamma_los.png"),
    res=600, width = 6, height=4.5, units = "in")
qqnorm(ranef(model_gamma_los)$hospital_id[,1])
qqline(ranef(model_gamma_los)$hospital_id[,1])
dev.off()

#check collinearity model_gamma_los = low correlation VIF ok
performance::check_collinearity(model_gamma_los)

#create model gamma with interaction between apr_severity and procedure (wait several minutes)
model_gamma_interaction <- glmer(
  los ~ age_group + sex + race_group + payer_group +
    apr_severity * proc_group +
    ed_admission + (1 | hospital_id),
  family = Gamma(link="log"),
  data = sparcs_hf)

#compare model_gamma_los and model_gamma_interaction Delta AIC = 116 → interaction model preferred
AIC(model_gamma_los, model_gamma_interaction)

#-----------------------------------------------------------
#BEST MODEL = model_gamma_interaction (SEVERITY AND PROCEDURE)
#-----------------------------------------------------------