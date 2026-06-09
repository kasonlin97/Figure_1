library(ggplot2)

# Load data
df <- read.csv("/Users/admin/MSc_Project/Figure_1/Figure1c.csv", check.names = FALSE)

# Clean column names
colnames(df) <- c("project", "count")
df$project <- trimws(df$project)

# Plot
p <- ggplot(
  df,
  aes(
    x = reorder(project, -count),
    y = count
  )
) +
  geom_col(width = 0.8, fill = "#8b0000") +
  geom_text(
    aes(label = count),
    vjust = -0.4,
    size = 4
  ) +
  labs(
    x = "Cancer type",
    y = "Number of ecDNA amplicons"
  ) +
  expand_limits(y = max(df$count) * 1.1) +
  theme_classic(base_size = 14) +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1),
    plot.title = element_text(face = "bold")
  )

print(p)

ggsave("/Users/admin/MSc_Project/Figure_1/Figure1c.png", plot = p, width = 8, height = 6, dpi = 300)
