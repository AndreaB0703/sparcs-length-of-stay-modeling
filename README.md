# Modeling Hospital Length of Stay Using SPARCS Data

This project analyzes hospital length of stay (LOS) using SPARCS data (~28,000 admissions across 178 hospitals).

The objective is to illustrate a principled workflow for statistical model selection in health services research, integrating causal reasoning, data structure, and empirical model diagnostics.

---

## Research Question

Which patient and hospital factors are associated with hospital length of stay?

---

## Analytical Workflow

The analysis followed four steps:

### 1. Causal structure (DAG)

A Directed Acyclic Graph (DAG) was used to define relationships between patient characteristics, clinical severity, procedures, admission type, and hospital factors.

### 2. Data structure

Patients are clustered within hospitals, therefore a mixed-effects model with a random intercept for hospital was used.

### 3. Candidate models

Because LOS is strictly positive and right-skewed, the following models were evaluated:

* Gamma mixed model
* Log-normal model

### 4. Model comparison and diagnostics

Candidate models were compared using Akaike Information Criterion (AIC) and residual diagnostics.

---

## Final Model

The **Gamma mixed-effects model with a log link** provided the best fit for the LOS distribution.

An interaction term between **clinical severity and procedure type** was included in the final model.

---

## Key Findings

* Sociodemographic variables showed limited association with length of stay.

* Clinical severity (APR severity) was the strongest predictor of LOS.

* Mean LOS increased substantially with clinical severity:

  * Minor: **3.15 days**
  * Moderate: **4.31 days**
  * Major: **6.13 days**
  * Extreme: **10.32 days**

* Procedure type was also associated with LOS:

  * No procedures: **4.50 days**
  * Diagnostic procedures: **6.38 days**
  * Cardiac procedures: **5.59 days**
  * Respiratory/organ support procedures: **5.33 days**

* Among patients with **extreme clinical severity**, those undergoing diagnostic procedures stayed on average **5.79 additional days** in the hospital.

* Approximately **10% of the variation in LOS** was attributable to differences between hospitals.

---
##Reproducible analysis of hospital length of stay using SPARCS data and mixed-effects modeling.
## Example: Interaction Between Severity and Procedures

![Interaction Plot](figures/interaction_plot.png)

---

## Reproducibility

All analyses were conducted in **R** using the following packages:

* `lme4`
* `emmeans`
* `DHARMa`
* `ggplot2`

---

## Repository Structure

```plaintext
data/
scripts/
figures/
results/
README.md
```

---

## Next Steps

Future updates will include:

* DAG visualization
* Detailed model diagnostics
* Code for full reproducibility
