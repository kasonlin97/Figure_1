library(ggplot2)
library(dplyr)
library(scales)
library(ggpubr)

# ── Load data ──────────────────────────────────────────────────────────────────
data <- read.csv("/Users/admin/MSc_Project/Figure_1/Figure1b.csv", 
                 stringsAsFactors = FALSE)
data$Classification <- trimws(data$Classification)

# ── Recode labels ──────────────────────────────────────────────────────────────
data$Classification <- recode(data$Classification,
                              "Complex non-cyclic"   = "CNC",
                              "Linear amplification" = "LA"
)

# ── Colour palette ─────────────────────────────────────────────────────────────
class_colours <- c(
  "ecDNA" = "#E64B35",
  "BFB"   = "#4DBBD5",
  "CNC"   = "#00A087",
  "LA"    = "#F39B7F"
)

# ── Summary stats ──────────────────────────────────────────────────────────────
stats_df <- data %>%
  group_by(Classification) %>%
  summarise(
    median_val = median(Unique.Amplicon.Count),
    q1         = quantile(Unique.Amplicon.Count, 0.25),
    q3         = quantile(Unique.Amplicon.Count, 0.75),
    .groups    = "drop"
  )

# ── Comparisons ────────────────────────────────────────────────────────────────
comparisons_list <- list(
  c("ecDNA", "BFB"),
  c("BFB",   "CNC"),
  c("CNC",   "LA"),
  c("ecDNA", "LA")
)

# ── Plot ───────────────────────────────────────────────────────────────────────
p <- ggplot(data, aes(x = Classification, y = Unique.Amplicon.Count, fill = Classification)) +
  
  geom_violin(trim = FALSE, scale = "width", alpha = 0.75,
              colour = "black", linewidth = 0.4) +
  geom_jitter(aes(colour = Classification), width = 0.06, size = 0.8,
              alpha = 0.35, show.legend = FALSE) +
  geom_crossbar(data = stats_df, aes(y = median_val, ymin = q1, ymax = q3),
                width = 0.15, fill = "white", colour = "black",
                linewidth = 0.5, fatten = 2) +
  
  stat_compare_means(
    comparisons   = comparisons_list,
    method        = "wilcox.test",
    label         = "p.signif",
    tip.length    = 0.01,
    bracket.size  = 0.4,
    size          = 3.5,
    step.increase = 0.08
  ) +
  
  scale_fill_manual(values = class_colours) +
  scale_colour_manual(values = class_colours) +
  scale_x_discrete(expand = expansion(add = 0.5)) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 8),
                     expand = expansion(mult = c(0.02, 0.15))) +
  labs(x = NULL, y = "Amplicon Count (per sample)") +
  theme_classic(base_size = 13) +
  theme(
    axis.text.x        = element_text(size = 11, face = "bold", colour = "grey20"),
    axis.text.y        = element_text(size = 10),
    axis.title.y       = element_text(size = 11, margin = margin(r = 8)),
    axis.line          = element_line(colour = "black"),
    axis.ticks         = element_line(colour = "black"),
    legend.position    = "none",
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank(),
    panel.background   = element_rect(fill = "transparent", color = NA),
    plot.background    = element_rect(fill = "transparent", color = NA),
    panel.border       = element_blank(),
    plot.margin        = margin(0, 0, 0, 0)
  )

# ── Save PNG ───────────────────────────────────────────────────────────────────
ggsave("/Users/admin/MSc_Project/Figure_1/Figure1b.png",
       plot = p, width = 5.5, height = 6, dpi = 200, bg = "transparent")
message("Saved.")

print(p)