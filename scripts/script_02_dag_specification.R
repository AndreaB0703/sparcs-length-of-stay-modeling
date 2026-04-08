#---------------------------------
# DAG - directed acyclic graph
#-------------------------------
Age ─┐
Sex ─┤
Race ─┤
Payer ┘
│
▼
Severity ─────► LOS
│            ▲
│            │
▼            │
Procedures ──────┘
│
▼
Admission ───────► LOS

Hospital ──────────► Procedures
Hospital ──────────► LOS

Severity → LOS
Severity → Procedures → LOS
Severity → Admission → LOS
Hospital → LOS
Hospital → Procedures → LOS

library(dagitty)

dag <- dagitty("
dag {
Age -> Severity
Sex -> Severity
Race -> Severity
Payer -> Severity

Severity -> Procedures
Severity -> Admission
Severity -> LOS

Procedures -> LOS
Admission -> LOS

Hospital -> Procedures
Hospital -> LOS}")

plot(dag)

#save
png(filename = here("figure","dag_structure.png"),
    width = 800, height = 600)
plot(dag)
dev.off()