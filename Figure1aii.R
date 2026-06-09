library(ggplot2)
library(dplyr)

# Data
df <- data.frame(
  Classification = c("Linear amplification", "ecDNA", "Complex non-cyclic", "BFB"),
  Count = c(1859, 677, 557, 485)
)

# Compute fractions and label positions
df <- df %>%
  mutate(
    Percentage = Count / sum(Count) * 100,
    ymax = cumsum(Percentage),
    ymin = c(0, head(ymax, -1)),
    label_pos = (ymax + ymin) / 2,
    label = paste0(Classification, "\n", round(Percentage, 1), "%")
  )

# Colour palette (publication-friendly)
colours <- c(
  "Linear amplification" = "#4E79A7",
  "ecDNA"                = "#F28E2B",
  "Complex non-cyclic"   = "#59A14F",
  "BFB"                  = "#E15759"
)

p <- ggplot(df, aes(ymax = ymax, ymin = ymin, xmax = 4, xmin = 2.2,
                    fill = Classification)) +
  geom_rect(colour = "white", linewidth = 0.6) +
  geom_text(
    aes(x = 4.7, y = label_pos, label = label),
    size = 3.5, lineheight = 1.2
  ) +
  coord_polar(theta = "y") +
  xlim(c(0, 5.2)) +
  scale_fill_manual(values = colours) +
  theme_void(base_size = 13) +
  theme(
    legend.position  = "none",
    plot.title       = element_text(face = "bold", hjust = 0.5, size = 15,
                                    margin = margin(b = 4)),
    plot.subtitle    = element_text(hjust = 0.5, colour = "grey40", size = 11,
                                    margin = margin(b = 10)),
    plot.margin      = margin(10, 10, 10, 10)
  ) 


# Save
ggsave("/Users/admin/MSc_Project/Figure_1/Figure1aii.png", plot = p,
       width = 7, height = 6, dpi = 300, bg = "white")

print(p)