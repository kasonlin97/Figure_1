library(dplyr)
library(ggplot2)
library(wesanderson)

df <- read.csv("/Users/admin/MSc_Project/Figure_1/Figure1e.csv", check.names = FALSE)

# Order projects by DESCENDING total (sum) of ecDNA amplicons
df$project <- reorder(
  df$project,
  df$n_ecDNA_amplicons,
  FUN = sum,
  na.rm = TRUE
)
# reorder() always sorts ascending, so reverse the levels
df$project <- factor(df$project, levels = rev(levels(df$project)))


# Replicate ggplot2's violin density computation exactly
violin_tops <- df %>%
  group_by(project) %>%
  summarise(
    violin_top = {
      vals <- n_ecDNA_amplicons[!is.na(n_ecDNA_amplicons)]
      if (length(vals) < 2) {
        max(vals)
      } else {
        d <- density(vals, bw = "nrd0", n = 512)
        # ggplot2 uses the density x range as the violin extent
        # with trim=FALSE this is max(d$x), not max(vals)
        max(d$x)
      }
    },
    total_amplicons = sum(n_ecDNA_amplicons, na.rm = TRUE),
    .groups = "drop"
  )

n_proj <- nlevels(df$project)
pal <- colorRampPalette(wes_palette("FantasticFox1"))(n_proj)

p <- ggplot(df, aes(x = project, y = n_ecDNA_amplicons, fill = project)) +
  geom_violin(
    trim  = FALSE,
    color = "black",
    alpha = 0.85
  ) +
  geom_boxplot(
    width         = 0.12,
    fill          = "white",
    color         = "black",
    outlier.shape = NA
  ) +
  geom_text(
    data = violin_tops,
    aes(
      x     = project,
      y     = violin_top,
      label = total_amplicons
    ),
    inherit.aes = FALSE,
    vjust  = -0.3,
    size   = 3.5
  ) +
  scale_fill_manual(values = pal) +
  scale_y_continuous(
    expand = expansion(mult = c(0.02, 0.18))  # increased top margin
  ) +
  theme_classic(base_size = 12) +
  theme(
    legend.position = "none",
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
    axis.line   = element_line(color = "black")
  ) +
  labs(
    x = "Cancer type",
    y = "Number of ecDNA amplicons"
  )


ggsave("/Users/admin/MSc_Project/Figure_1/Figure1e.png",
       plot = p, width = 5.5, height = 6, dpi = 200, bg = "transparent")
message("Saved.")

print(p)



