# RShiny Application for RNA-seq Analysis

**Wenshou He**\
**12/28/2024**

## Description

This application is an RShiny app designed to analyze RNA-Seq data from Huntington's Disease and healthy brain tissue. The app includes four main components:

1.  **Sample Information Exploration**: Summary tables and distribution plots of sample information.
2.  **Counts Matrix Exploration**: Count filtering, scatterplots, clustered heatmap, and PCA.
3.  **Differential Expression Analysis**: Volcano plot and DEG table with significant adjusted p-values.
4.  **Gene Set Enrichment Analysis**: Barplot of top pathways, downloadable table of significantly enriched pathways, and scatterplot of NES vs. p-value.

You can use the testing data provided in the 'data' folder and access the app through the code in the 'app' folder.

## GEO Dataset

-   **Dataset**: mRNA-Seq Expression profiling of human post-mortem BA9 brain tissue for Huntington's Disease and neurologically normal individuals.\
-   **Link**: [GSE64810 on GEO](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE64810)

## References

1.  Labadorf, A., Hoss, A. G., Lagomarsino, V., Latourelle, J. C., Hadzi, T. C., Bregu, J., ... & Myers, R. H. (2015). RNA sequence analysis of human Huntington disease brain reveals an extensive increase in inflammatory and developmental gene expression. PloS one, 10(12), e0143563.\
2.  Labadorf, A., Choi, S. H., & Myers, R. H. (2018). Evidence for a pan-neurodegenerative disease response in Huntington's and Parkinson's disease expression profiles. Frontiers in molecular neuroscience, 10, 430.\
3.  Agus, F., Crespo, D., Myers, R. H., & Labadorf, A. (2019). The caudate nucleus undergoes dramatic and unique transcriptional changes in human prodromal Huntington’s disease brain. BMC medical genomics, 12, 1-17.
