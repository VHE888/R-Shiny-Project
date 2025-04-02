## BF591 Final Project RShiny APP
## Wenshou He 2024 Fall
## GSEA Tab

library(tidyverse)
# library(fgsea)

options(scipen=0)

# Function to generate FGSEA normalized enrichment score (NES) bar plot
fgsea_NES_barplot <- function(fgsea_results, pathway_name, num_paths) {
  # Sort the FGSEA results by NES in descending order
  fgsea_NES <- arrange(fgsea_results, desc(NES))
  
  # Select top and bottom pathways
  topgene_pathways <- head(fgsea_NES, num_paths) %>% .$pathway
  botgene_pathways <- tail(fgsea_NES, num_paths) %>% .$pathway
  
  # Subset the FGSEA results for selected pathways
  fgsea_subset <- fgsea_NES %>%
    filter(pathway %in% c(topgene_pathways, botgene_pathways)) %>%
    mutate(pathway = factor(pathway),
           path_labs = str_replace_all(pathway, "_", " "),
           path_labs = fct_reorder(factor(path_labs), NES))
  
  # Create bar plot
  ggplot(fgsea_subset, aes(x = path_labs,
                           y = NES,
                           fill = NES < 0)) +
    geom_bar(stat = "identity",
             show.legend = FALSE) +
    scale_fill_manual(values = c("TRUE" = "red", "FALSE" = "darkblue")) +
    labs(x = "",
         y = "Normalized Enrichment Score (NES)",
         title = paste0("FGSEA Results for ", pathway_name, " Genesets from MSigDB")) +
    theme_classic() +
    theme(text = element_text(size = 6)) +
    scale_x_discrete(labels = function(x) str_wrap(x, width = 70)) +
    coord_flip() %>%
    return()
}

# Function to create a summary table for FGSEA results
fgsea_summary_table <- function(fgsea_results, pathway_direction = c("positive", "negative", "all"), padj_filter) {
  # Prepare the summary table
  fgsea_summary <- fgsea_results %>%
    rename(Pathway = pathway) %>%
    arrange(padj) %>%
    filter(padj < 10^padj_filter) %>%
    mutate(pval = formatC(.$pval, digits = 2, format = "e"),
           padj = formatC(.$padj, digits = 2, format = "e")) %>%
    select(-leadingEdge)
  
  # Filter by pathway direction if specified
  if (pathway_direction == "positive") {
    fgsea_summary %>%
      filter(NES > 0) %>%
      return()
  } else if (pathway_direction == "negative") {
    fgsea_summary %>%
      filter(NES < 0) %>%
      return()
  } else if (pathway_direction == "all") {
    fgsea_summary %>%
      return()
  }
}

# Function to generate FGSEA NES scatter plot
fgsea_NES_scatterplot <- function(fgsea_results, padj_filter) {
  # Add a column indicating whether pathways pass the padj threshold
  fgsea_res_padj <- fgsea_results %>%
    mutate(pass_filt = padj < 10^padj_filter)
  
  # Create scatter plot
  ggplot(fgsea_res_padj) +
    geom_point(aes(x = NES,
                   y = -log10(padj),
                   color = factor(pass_filt, levels = c(TRUE, FALSE)))) +
    scale_color_manual(values = c("#1827C3", "#CCCCCC")) +
    theme_classic() +
    theme(text = element_text(size = 9)) +
    labs(x = "Normalized Enrichment Score (NES)",
         y = "-log10(Adjusted P-Value)",
         color = paste0("Adjusted P-Value < 10^", padj_filter))
}