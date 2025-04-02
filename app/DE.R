## BF591 Final Project RShiny APP
## Wenshou He 2024 Fall
## Differential Expression Tab

library(tidyverse)

options(scipen=0)

# Generate volcano plot
de_volcano_plot <- function(dataf, x_name, y_name, slider, color1, color2) {
  # This function generates a volcano plot with points colored based on a threshold
  # Input:
  #   dataf: Dataframe containing the data
  #   x_name: Name of the column to use for x-axis
  #   y_name: Name of the column to use for y-axis (e.g., p-value)
  #   slider: Log10 threshold for determining significance
  #   color1, color2: Colors for "TRUE" and "FALSE" statuses
  # Output:
  #   A ggplot object representing the volcano plot
  dataf %>%
    select(c(x_name, y_name)) %>%
    mutate(volc_status = ifelse(.[, y_name] < 10^slider, "TRUE", "FALSE")) %>%
    ggplot() +
    geom_point(aes(x = !!sym(x_name),
                   y = -log10(!!sym(y_name)),
                   color = factor(volc_status, levels = c("TRUE", "FALSE")))) +
    scale_color_manual(values = c(color2, color1)) +
    theme_classic() +
    theme(legend.position = "bottom") +
    labs(x = x_name,
         y = paste0("-log10(", y_name, ")"),
         color = paste0(y_name, " < 10^", slider)) %>%
    return()
}

# Generate summary table
de_summary_table <- function(dataf, slider) {
  # This function generates a summary table of significant genes
  # Input:
  #   dataf: Dataframe containing the data
  #   slider: Log10 threshold for determining significance
  # Output:
  #   A dataframe filtered and formatted for significant genes
  dataf %>%
    rename(Symbol = symbol) %>%
    arrange(pvalue) %>%
    filter(padj < 10^slider) %>%
    mutate(pvalue = formatC(.$pvalue, digits = 2, format = "e"),
           padj = formatC(.$padj, digits = 2, format = "e")) %>%
    return()
}