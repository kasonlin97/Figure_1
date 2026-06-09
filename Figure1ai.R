library(ggplot2)

df <- read.csv("/Users/admin/MSc_Project/Figure_1/Figure1ai.csv")   

df$project <- factor(df$project, levels = df$project[order(df$samples, decreasing = TRUE)])

p <- ggplot(df, aes(x = project, y = samples)) +
  geom_col(fill = "#8b0000", color = NA, width = 0.5, alpha = 0.85) +
  geom_text(
    aes(label = samples),
    vjust = -0.4,
    size  = 3
  ) +
  scale_x_discrete(expand = expansion(add = 0.8)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  theme_classic(base_size = 10) +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 55, hjust = 1, vjust = 1, size = 7.5),
    axis.text.y = element_text(size = 8),
    axis.line   = element_line(color = "black"),
    panel.background  = element_rect(fill = "transparent", color = NA),
    plot.background   = element_rect(fill = "transparent", color = NA),
    panel.border      = element_blank(),
    plot.margin       = margin(t = 0, r = 0, b = 0, l = 0)
  ) +
  labs(
    x = "Cancer type",
    y = "Number of samples"
  )

ggsave(
  "/Users/admin/MSc_Project/Figure_1/Figure1ai.png",
  p,
  width  = 27.7,
  height = 8.1,
  units  = "cm",
  dpi    = 300,
  bg     = "transparent"
)
