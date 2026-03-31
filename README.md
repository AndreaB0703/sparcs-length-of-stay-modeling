Hospital Length of Stay in Heart Failure Admissions in New York State — A Multilevel Analysis (SPARCS 2024)
Project overview
Heart failure is one of the leading causes of hospitalization in the United States and a key indicator of primary care quality. Prevention Quality Indicator 08 (PQI-08), developed by the Agency for Healthcare Research and Quality (AHRQ), classifies heart failure as an ambulatory care-sensitive condition (ACSC) — meaning that a substantial proportion of these hospitalizations could be avoided with timely and adequate primary care.
This project examines whether patients hospitalized for heart failure in New York State present differences in length of stay (LOS) according to sociodemographic and clinical characteristics, using a multilevel modeling approach that accounts for hospital-level variation.

Why this project matters
Heart failure hospitalizations represent a significant burden on the healthcare system and are largely preventable. When patients lack access to quality primary care, conditions like heart failure are more likely to progress to acute episodes requiring emergency hospitalization — often resulting in longer and more costly inpatient stays.
Understanding the patterns of heart failure admissions and the factors associated with longer LOS is essential for identifying inequities in care, informing hospital quality improvement initiatives, and supporting policies that strengthen primary care access — particularly for vulnerable populations.
Objectives

Describe heart failure emergency admissions in New York State in 2024 according to sociodemographic and clinical characteristics
Examine the distribution of admissions by disease group (APR MDC), mean LOS, and mean cost per admission
Assess hospital-level variation in LOS using the Intraclass Correlation Coefficient (ICC)
Fit a Generalized Linear Mixed Model (GLMM) with negative binomial distribution to identify predictors of LOS while accounting for clustering of patients within hospitals
Data source
Data were obtained from the Statewide Planning and Research Cooperative System (SPARCS), New York State Department of Health, for the year 2024.
SPARCS is a comprehensive all-payer hospital discharge database that captures nearly all inpatient admissions occurring in New York State hospitals.
Records were filtered using the following criteria:

Diagnosis: Heart failure (APR-DRG code 194)
Admission type: Emergency Department admissions only (ED Indicator = Y)
Variables selected: Hospital ID, age group, sex, race, length of stay, APR-DRG code and description, APR severity of illness, and primary payer
Methods
The analysis included:

Data cleaning, variable selection, and recoding in R
Exclusion of records with LOS above the 99th percentile (> 28 days, n = 235) as influential outliers, confirmed by DHARMa residual diagnostics
Descriptive analysis of admissions by sociodemographic characteristics, disease groups, mean LOS, and mean costs
A multilevel Generalized Linear Mixed Model (GLMM) with negative binomial distribution (nbinom2), with patients nested within hospitals as a random effect, fitted using the glmmTMB package
Model diagnostics using simulation-based residual analysis (DHARMa package)
Results reported as Incidence Rate Ratios (IRR) with 95% confidence intervals
Main findings

A total of 25,320 emergency admissions for heart failure were analyzed across 166 hospitals in New York State
The ICC of 0.08 indicated that 8% of the total variation in LOS was attributable to hospital-level differences, justifying the multilevel approach
APR severity of illness was the strongest predictor of LOS — patients with extreme severity stayed 219% longer than those with minor severity (IRR 3.19, 95% CI 3.04–3.34)
Patients aged 70 years or older had a 17% longer LOS compared to younger adults (IRR 1.17, 95% CI 1.13–1.22)
Medicaid and Medicare beneficiaries had significantly longer LOS compared to privately insured patients (IRR 1.07 and 1.05, respectively), suggesting inequities in care that may reflect delayed access to primary care
The marginal R² of 0.177 indicated that fixed effects explained 17.7% of LOS variation, while the conditional R² of 0.242 showed that the full model — including hospital-level effects — explained 24.2%
Selected visualizations
Distribution of admissions by age group
(figure/admissions_age_group.png)
Distribution of admissions by race
(figure/admissions_race.png)
Emergency vs elective admissions
(figure/emergency_admissions.png)
Top 15 disease groups by number of admissions
(figure/admissions_disease.png)
Top 15 disease groups by mean cost per admission
(figure/mean_cost_disease.png)
Top 15 disease groups by mean length of stay
(figure/mean_los_disease.png)
Distribution of length of stay
(figure/los_distribution.png)
Repository structure

scripts/ — R scripts for data cleaning, descriptive analysis, and GLMM
figure/ — visualizations
data/ — raw and processed data
output/ — summary tables and model results
Reproducibility
The full workflow was developed in R. Key packages: tidyverse, glmmTMB, DHARMa, performance, emmeans, sjPlot, and here.

Key takeaway
Hospital-level variation in length of stay for heart failure admissions in New York State is real and statistically significant — even after adjusting for patient severity, age, sex, race, and insurance type. The association between public insurance (Medicaid and Medicare) and longer LOS points to structural inequities that extend beyond clinical factors, highlighting the need for stronger primary care infrastructure to reduce preventable hospitalizations and improve outcomes for vulnerable populations.
Multilevel analysis of heart failure emergency admissions and length of stay in New York State hospitals (SPARCS 2024)
