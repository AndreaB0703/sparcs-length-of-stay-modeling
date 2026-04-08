library(here)
library(ggplot2)
library(dplyr)

# Load sparcs_hf dataset
sparcs_hf <- readRDS("data/processed_data/sparcs_hf.rds")

#admission by type (emergency and no-emergency)
graph_admission_type <- sparcs_hf |>
  count(ed_admission) |>
  mutate(percent = n / sum(n) * 100) |>
  ggplot(aes(x = ed_admission, y = percent, fill = ed_admission)) +
  geom_col(width = 0.6) +
  geom_text(aes(label = paste0(round(percent,1), "%")),
            vjust = -0.3,size = 5) +
  scale_fill_brewer(palette = "Set2") +
  labs(title = "Hospital admissions for heart failure by admission type",
       subtitle = "New York State SPARCS inpatient data, 2024",
       x = "Admission type",
       y = "Percentage of hospitalizations",
       fill = "Admission type",
       caption = "Source: New York State SPARCS database") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold", size = 18))

graph_admission_type
#save
ggsave(filename = here("figure", "admissions_type.png"),
       plot = graph_admission_type, dpi=600, width = 6, height=4.5)

#mean los and discharge
graph_los_discharge <- sparcs_hf |>
  group_by(discharge_group) |>
  summarise(mean_los = mean(los, na.rm = TRUE)) |>
  ggplot(aes(x = reorder(discharge_group, mean_los),
             y = mean_los)) +
  geom_col(fill = "#378ADD", width = 0.7) +
  geom_text(aes(label = round(mean_los,1)),
            hjust = -0.2,size = 4) +
  coord_flip() +expand_limits(y = 11) +
  labs(title = "Average length of stay by discharge destination",
       subtitle = "Heart failure hospitalizations – New York SPARCS 2024",
       x = "Discharge destination",
       y = "Mean length of stay (days)",
       caption = "Source: New York State SPARCS database") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(face = "bold", size = 18))

graph_los_discharge
#save
ggsave(filename = here("figure", "los_discharge.png"),
       plot = graph_los_discharge, dpi=600, width = 6, height=4.5)

#admissions by age and sex
graph_admission_age_sex <- sparcs_hf |>
  count(age_group, sex) |>
  ggplot(aes(x = age_group, y = n, fill = sex)) +
  geom_col(position = position_dodge(width = 0.8), width = 0.7) +
  geom_text(aes(label = scales::comma(n)),
            position = position_dodge(width = 0.8),
            vjust = -0.3,size = 4) +
  scale_fill_brewer(palette = "Set1") +
  labs(title = "Heart failure hospitalizations by age group and sex",
       subtitle = "New York State SPARCS inpatient data, 2024",
       x = "Age group",
       y = "Number of hospitalizations",
       fill = "Sex",caption = "Source: New York State SPARCS database") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(face = "bold", size = 18),
        plot.subtitle = element_text(size = 12))

graph_admission_age_sex
#save
ggsave(filename = here("figure", "admissions_age_sex.png"),
       plot = graph_admission_age_sex, dpi=600, width = 6, height=4.5)

#emergency admissions by age and severity
graph_admission_age_severity <- sparcs_hf |>
  filter(ed_admission == "Emergency") |>
  count(age_group, apr_severity) |>
  ggplot(aes(x = age_group, y = n, fill = apr_severity)) +
  geom_col(position = "fill") +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_brewer(palette = "Reds") +
  labs(title = "Severity of illness among emergency admissions for heart failure",
       subtitle = "New York State SPARCS inpatient data, 2024",
       x = "Age group",
       y = "Percentage of admissions",
       fill = "APR severity",
       caption = "Source: New York State SPARCS database") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(face = "bold", size = 18))

graph_admission_age_severity
#save
ggsave(filename = here("figure", "admissions_age_severity.png"),
       plot = graph_admission_age_severity, dpi=600, width = 6, height=4.5)

#admissions by payer and severity
graph_admission_payer_severity <- sparcs_hf |>
  count(payer_group, apr_severity) |>
  ggplot(aes(x = payer_group, y = n, fill = apr_severity)) +
  geom_col(position = "fill", width=0.7) +
  scale_y_continuous(labels = scales::percent) +
  scale_fill_brewer(palette = "YlOrRd") +
  labs(title = "Severity of illness among heart failure hospitalizations by payer",
       subtitle = "New York State SPARCS inpatient data, 2024",
       x = "Primary payer",
       y = "Percentage of hospitalizations",
       fill = "Severity",
       caption = "Source: New York State SPARCS database") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(face = "bold", size = 18))

graph_admission_payer_severity
#save
ggsave(filename = here("figure", "admissions_payer_severity.png"),
       plot = graph_admission_payer_severity, dpi=600, width = 6, height=4.5)

#distributions of los 
graph_los_distribution <- ggplot(sparcs_hf, aes(x = los)) +
  geom_histogram( binwidth = 1,fill = "#378ADD",
                  color = "white") +
  coord_cartesian(xlim = c(0,30)) +
  labs(title = "Distribution of length of stay among heart failure hospitalizations",
       subtitle = "New York State SPARCS inpatient data, 2024",
       x = "Length of stay (days)",
       y = "Number of hospitalizations",
       caption = "Source: New York State SPARCS database") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(face = "bold", size = 18))
graph_los_distribution
#save
ggsave(filename = here("figure", "los_distribution.png"),
       plot = graph_los_distribution, dpi=600, width = 6, height=4.5)

#los by severity
# Limit LOS visualization to 30 days for readability
sparcs_hf$apr_severity <- factor(
  sparcs_hf$apr_severity,
  levels = c("Minor","Moderate","Major","Extreme"))
#graph los severity
graph_los_severity <- ggplot(
  sparcs_hf,
  aes(x = apr_severity, y = los, fill = apr_severity)) +
  geom_boxplot(outlier.shape = NA) +
  coord_cartesian(ylim = c(0,30)) +
  labs(title = "Length of stay by severity of illness",
       subtitle = "Heart failure hospitalizations, New York State SPARCS 2024",
       x = "APR severity",
       y = "Length of stay (days)",
       caption = "Source: New York State SPARCS database") +
  theme_minimal(base_size = 14) +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold", size = 18))

graph_los_severity
#save
ggsave(filename = here("figure", "los_severity.png"),
       plot = graph_los_severity, dpi=600, width = 6, height=4.5)

#mean los by hospital
hospital_los <- sparcs_hf |>
  group_by(hospital_id) |>
  summarise(
    mean_los = mean(los, na.rm = TRUE), n = n()) |>
  arrange(mean_los)
#graph mean los by hospital 
graph_mean_los_hospital <- ggplot(hospital_los,
                                  aes(x = mean_los,
                                      y = reorder(hospital_id, mean_los))) +
  geom_point(color = "#378ADD", size = 2) +
  labs( title = "Variation in mean length of stay across hospitals",
        subtitle = "Heart failure hospitalizations, New York State SPARCS 2024",
        x = "Mean length of stay (days)",
        y = "Hospital",
        caption = "Source: New York State SPARCS database") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(face = "bold", size = 18),
        axis.text.y = element_blank(),
        axis.ticks.y = element_blank())

graph_mean_los_hospital
#save
ggsave(filename = here("figure", "mean_los_hospital.png"),
       plot = graph_mean_los_hospital, dpi=600, width = 6, height=4.5)