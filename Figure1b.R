library(dplyr)
library(ggplot2)
library(ggVennDiagram)

# Read data
df <- read.csv(
  "/Users/admin/MSc_Project/Figure_1/TCGA_ecDNA_Analysis_result_table_with_project.csv",
  stringsAsFactors = FALSE
)

# Create Venn sets
venn_list <- list(
  LA    = unique(df$Sample.name[df$Classification == "Linear amplification"]),
  ecDNA = unique(df$Sample.name[df$Classification == "ecDNA"]),
  CNC   = unique(df$Sample.name[df$Classification == "Complex non-cyclic"]),
  BFB   = unique(df$Sample.name[df$Classification == "BFB"])
)

# Plot
p <- ggVennDiagram(
  venn_list,
  label_alpha = 0,
  set_color = c(
    "black",
    "#8B0000",   # ecDNA outline
    "black",
    "black"
  )
) +
  scale_fill_gradient(
    low = "white",
    high = "#4477AA"
  ) +
  theme_void() +
  theme(
    panel.background =
      element_rect(fill = "transparent", colour = NA),
    plot.background =
      element_rect(fill = "transparent", colour = NA),
    legend.background =
      element_rect(fill = "transparent", colour = NA),
    legend.key =
      element_rect(fill = "transparent", colour = NA)
  )

print(p)

ggsave(
  "/Users/admin/MSc_Project/Figure_1/Figure1b.png",
  plot = p,
  width = 8,
  height = 8,
  bg = "transparent"
)
