import pandas as pd
import re
import numpy as np
from scipy import stats

df = pd.read_csv("/Users/admin/MSc_Project/Figure_1/TCGA_ecDNA_Analysis_result_table_with_project.csv")

# Strip whitespace from relevant columns
df["Feature ID"] = df["Feature ID"].str.strip()
df["Classification"] = df["Classification"].str.strip()
df["Sample name"] = df["Sample name"].str.strip()

# Extract amplicon ID by removing the trailing numeric suffix (e.g. _1, _2)
df["Amplicon ID"] = df["Feature ID"].str.replace(r"_\d+$", "", regex=True)

# Count unique amplicons per sample per classification
result = (
    df.groupby(["Sample name", "Classification"])["Amplicon ID"]
    .nunique()
    .reset_index()
    .rename(columns={"Amplicon ID": "Unique Amplicon Count"})
)

# Pivot for a cleaner view
pivot = result.pivot_table(
    index="Sample name",
    columns="Classification",
    values="Unique Amplicon Count",
    fill_value=0
)
pivot.columns.name = None
pivot = pivot.reset_index()

print("=== Long format (first 20 rows) ===")
print(result.head(20).to_string(index=False))

print("\n=== Pivoted (sample × classification) — first 10 rows ===")
print(pivot.head(10).to_string(index=False))




# --- Violin plot statistics per classification ---
records = []
kde_records = []

for cls, grp in result.groupby("Classification"):
    vals = grp["Unique Amplicon Count"].values.astype(float)
    n = len(vals)

    q1, median, q3 = np.percentile(vals, [25, 50, 75])
    iqr = q3 - q1
    whisker_lo = max(vals.min(), q1 - 1.5 * iqr)
    whisker_hi = min(vals.max(), q3 + 1.5 * iqr)
    outliers = vals[(vals < whisker_lo) | (vals > whisker_hi)].tolist()

    records.append({
        "Classification": cls,
        "N (samples)": n,
        "Mean": round(vals.mean(), 4),
        "Std": round(vals.std(ddof=1), 4),
        "Min": vals.min(),
        "Q1 (25%)": q1,
        "Median (50%)": median,
        "Q3 (75%)": q3,
        "Max": vals.max(),
        "IQR": round(iqr, 4),
        "Whisker Low": whisker_lo,
        "Whisker High": whisker_hi,
        "N Outliers": len(outliers),
        "Outlier Values": outliers,
    })

    # KDE over a fine grid spanning [min, max] — the violin shape
    if n > 1:
        kde = stats.gaussian_kde(vals)
        x_grid = np.linspace(vals.min(), vals.max(), 200)
        density = kde(x_grid)
        for x, d in zip(x_grid, density):
            kde_records.append({"Classification": cls, "x": round(x, 6), "density": round(d, 8)})

summary_df = pd.DataFrame(records)
kde_df = pd.DataFrame(kde_records)

# --- Print summary ---
print("=== Violin plot statistics per classification ===\n")
for _, row in summary_df.iterrows():
    print(f"[{row['Classification']}]")
    print(f"  N={row['N (samples)']}, Mean={row['Mean']}, Std={row['Std']}")
    print(f"  Min={row['Min']}, Q1={row['Q1 (25%)']}, Median={row['Median (50%)']}, Q3={row['Q3 (75%)']}, Max={row['Max']}")
    print(f"  IQR={row['IQR']},  Whiskers=[{row['Whisker Low']}, {row['Whisker High']}]")
    print(f"  Outliers (n={row['N Outliers']}): {row['Outlier Values'][:10]}{'...' if len(row['Outlier Values']) > 10 else ''}")
    print()

