import pandas as pd

# Input files
df = "/Users/admin/MSc_Project/R_figures/TCGA_ecDNA_Analysis_result_table_with_project.csv"
df = pd.read_csv(df)

print(df)

cancer_counts = (
    df.groupby("project")["Sample name"]
      .nunique()
      .sort_values(ascending=False)
)

print(cancer_counts)
