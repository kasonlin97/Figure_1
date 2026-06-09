import pandas as pd

# Input files
df = "/Users/admin/MSc_Project/Figure_1/[ecDNA_ONLY]TCGA_ecDNA_Analysis_result_table_with_project.csv"
df = pd.read_csv(df)

print(df)

df["Amplicon_ID"] = df["Feature ID"].str.replace(
    r"_\d+$",
    "",
    regex=True
)

ecDNA_project_counts = (
    df.groupby("project")["Amplicon_ID"]
            .nunique()
            .reset_index(name="n_ecDNA_amplicons")
            .sort_values("n_ecDNA_amplicons", ascending=False)
)



sample_amplicon_counts = (
    df.groupby(["project", "Sample name"])["Amplicon_ID"]
            .nunique()
            .reset_index(name="n_ecDNA_amplicons")
            .sort_values(
                ["project", "n_ecDNA_amplicons"],
                ascending=[True, False]
            )
)

print(sample_amplicon_counts)
sample_amplicon_counts.to_csv("/Users/admin/MSc_Project/Figure_1/Figure1d.csv", index=False)


print(ecDNA_project_counts)


# Save result
#output_file = "/Users/admin/TCGA_ecDNA_Analysis_result_table_with_project.csv"
#df_ecDNA.to_csv(output_file, index=False)

