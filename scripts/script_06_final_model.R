library(lme4)
library(performance)
library (sjPlot)
library (DHARMa)
library (car)
library(influence.ME)
library(ggeffects)
library(fitdistrplus)
library(glmmTMB)
library(broom.mixed)
library(here)

# Load sparcs_hf
sparcs_hf <- readRDS("data/processed_data/sparcs_hf.rds")
#check
glimpse(sparcs_hf)

#model gamma interaction 
model_gamma_interaction <- glmer(
  los ~ age_group + sex + race_group + payer_group +
    apr_severity * proc_group +
    ed_admission + (1 | hospital_id),
  family = Gamma(link="log"),
  data = sparcs_hf)


#summary model_gamma_interaction
summary(model_gamma_interaction)

#sjPlot modelo_gamma_interaction
sjPlot::tab_model((model_gamma_interaction))
#save
sjPlot::tab_model(
  model_gamma_interaction,
  file = "output/model_table.html")

#comparison interaction between apr_severity and procedures (proc_group)
emm_interaction <- emmeans(model_gamma_interaction,
                           ~ apr_severity * proc_group,
                           type = "response")

#graph_interaction severity and procedure
emm_interaction <- as.data.frame(emm_interaction)

graph_interaction <- ggplot(
  emm_interaction,aes(x = apr_severity,
             y = response,color = proc_group, group = proc_group)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 3) +
  geom_text(aes(label = round(response,2)),
            vjust = -1,
            size = 3) +
  geom_errorbar(aes(ymin = asymp.LCL,
                    ymax = asymp.UCL),
                width = 0.15,
                alpha = 0.5) +
  facet_wrap(~proc_group) +
  scale_color_brewer(palette = "Dark2") +
  labs(x = "APR Severity",
       y = "Adjusted Length of Stay (days)",
       color = "Procedure Group",
       title = "Interaction Between Clinical Severity and Procedure Type on Length of Stay") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold"),
        panel.grid.minor = element_blank())
graph_interaction
#save
ggsave(filename = here("output", "interaction_procedure.png"),
       plot = graph_interaction, dpi=600, width = 6, height=4.5)