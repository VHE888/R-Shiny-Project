## BF591 Final Project RShiny APP
## Wenshou He 2024 Fall

# Load the required libraries
library(shiny)
library(bslib)
library(colourpicker)
# library(BiocManager)

# Set maximum upload size to 30 MB
options(shiny.maxRequestSize=30*1024^2)
# options(repos = BiocManager::repositories())

source("Samples.R")
source("Counts.R")
source("DE.R")
source("GSEA.R")

# UI setting
ui <- fluidPage(
  theme = bs_theme(version = 5, bootswatch = "minty"),
  titlePanel("BF591 Final Project RShiny APP"),
  h4("Wenshou He 2024 Fall"),
  tabsetPanel(
    tabPanel( # Sample Information Tab
      title = "Sample",
      sidebarLayout(
        sidebarPanel( # Inputs for sample data
          fileInput(inputId = "sample_info_upload",
                    label = "Sample Information (CSV):",
                    accept = ".csv",
                    placeholder = "metadata.csv"), # File upload for metadata
          width = 3 # Set sidebar width
        ),
        mainPanel( # Outputs for sample data
          tabsetPanel(
            tabPanel( # Summary table for sample information
              title = "Summary",
              tableOutput("sample_info_summary_table")
            ),
            tabPanel( # Full sample information table
              title = "Table",
              dataTableOutput("sample_info_table")
            ),
            tabPanel( # Violin plot for sample summary
              title = "Plot",
              sidebarLayout(
                sidebarPanel( # Plot options
                  radioButtons(inputId = "sample_info_summary_variable",
                               label = "Select a variable for summary plot:",
                               choices = c("Age_of_Death","mRNA_Seq_reads","Age_of_Onset","Duration",
                                           "CAG","Vonsattel_Grade","H_V_Striatal_Score","H_V_Cortical_Score"),
                               selected = "Age_of_Death"), # Default variable
                  submitButton(text = "Submit", width = "100%") # Submit button
                ),
                mainPanel(
                  plotOutput("sample_info_plot") # Output for the plot
                )
              )
            )
          )
        )
      )
    ),
    tabPanel( # Counts Exploration Tab
      title = "Counts",
      sidebarLayout(
        sidebarPanel( # Inputs for counts data
          fileInput(inputId = "counts_upload",
                    label = "Counts Matrix (CSV):",
                    accept = ".csv",
                    placeholder = "HD_norm_counts.csv"), # Upload counts data
          sliderInput(inputId = "counts_percent_var",
                      label = "Filter genes above the following percentile variance:",
                      min = 0,
                      max = 100,
                      value = 50,
                      step = 1), # Slider for variance filtering
          sliderInput(inputId = "counts_nonzero",
                      label = "Filter genes with the following number of non-zero samples:",
                      min = 0,
                      max = 69,
                      value = 35,
                      step = 1), # Slider for non-zero sample filtering
          submitButton(text = "Submit", width = "100%"), # Submit button
          width = 3
        ),
        mainPanel( # Outputs for counts data
          tabsetPanel(
            tabPanel( # Filtered counts summary table
              title = "Table",
              tableOutput("filtered_counts_summary_table")
            ),
            tabPanel( # Diagnostic scatter plots
              title = "Diagnostic Plots",
              tabsetPanel(
                tabPanel(
                  title = "Median vs. Variance",
                  plotOutput("median_var_plot") # Scatter plot for median vs variance
                ),
                tabPanel(
                  title = "Median vs. Non-Zero Samples",
                  plotOutput("median_nonzero_plot") # Scatter plot for median vs non-zero
                )
              )
            ),
            tabPanel( # Clustered heatmap
              title = "Heatmap",
              plotOutput("counts_heatmap") # Heatmap output
            ),
            tabPanel( # PCA
              title = "PCA",
              sidebarLayout(
                sidebarPanel( # PCA settings
                  fileInput(inputId = "counts_metadata",
                            label = "Sample Metadata (CSV):",
                            accept = ".csv",
                            placeholder = "metadata.csv"), # Upload metadata
                  sliderInput(inputId = "first_PC",
                              label = "Select the first principal component (x-axis):",
                              min = 1,
                              max = 69,
                              value = 1,
                              step = 1), # First PC slider
                  sliderInput(inputId = "second_PC",
                              label = "Select the second principal component (y-axis):",
                              min = 1,
                              max = 69,
                              value = 2,
                              step = 1), # Second PC slider
                  submitButton(text = "Submit", width = "100%")
                ),
                mainPanel(
                  plotOutput("counts_pca_biplot") # PCA biplot output
                )
              )
            )
          )
        )
      )
    ),
    tabPanel( # Differential Expression Tab
      title = "DE",
      sidebarLayout(
        sidebarPanel( # Inputs for DE analysis
          fileInput(inputId = "de_res_upload",
                    label = "Differential Expression Results (CSV):",
                    accept = ".csv",
                    placeholder = "HD_DESEq2_DE_res.csv"), # Upload DE results
          radioButtons(inputId = "volc_plot_x",
                       label = "Choose the x-axis column:",
                       choices = c("baseMean","HD.mean","Control.mean","log2FoldChange",
                                   "lfcSE","stat","pvalue","padj"),
                       selected = "log2FoldChange"), # X-axis column for volcano plot
          radioButtons(inputId = "volc_plot_y",
                       label = "Choose the y-axis column:",
                       choices = c("baseMean","HD.mean","Control.mean","log2FoldChange",
                                   "lfcSE","stat","pvalue","padj"),
                       selected = "padj"), # Y-axis column for volcano plot
          colourInput(inputId = "volc_plot_base_col",
                      label = "Base point color:",
                      value = "#22577A"),
          colourInput(inputId = "volc_plot_high_col",
                      label = "Highlight point color:",
                      value = "#FFCF56"),
          sliderInput(inputId = "volc_plot_padj_slider",
                      label = "Select the magnitude of the adjust p-value coloring threshold:",
                      min = -35,
                      max = 0,
                      value = -15,
                      step = 1), # Slider for p-value threshold
          submitButton(text = "Submit", width = "100%"),
          width = 3
        ),
        mainPanel( # Outputs for DE analysis
          tabsetPanel(
            tabPanel( # Volcano plot
              title = "Plot",
              plotOutput("volcano_plot") 
            ),
            tabPanel( # DE results table
              title = "Table",
              dataTableOutput("de_summary") 
            )
          )
        )
      )
    ),
    tabPanel( # GSEA Tab
      title = "GSEA",
      sidebarLayout(
        sidebarPanel( # Inputs for GSEA
          fileInput(inputId = "fgsea_res_upload",
                    label = "FGSEA Results (CSV):",
                    accept = ".csv",
                    placeholder = "fgsea_c2path_res.csv"), # Upload GSEA results
          width = 3
        ),
        mainPanel( # Outputs for GSEA
          tabsetPanel(
            tabPanel( # Barplot of top pathways
              title = "Top Results",
              sidebarLayout(
                sidebarPanel(
                  sliderInput(inputId = "fgsea_top_path_slider",
                              label = "Select number of top pathways:",
                              min = 0,
                              max = 25,
                              value = 10,
                              step = 1), # Slider for top pathways
                  submitButton(text = "Submit", width = "100%")
                ),
                mainPanel(
                  plotOutput("fgsea_NES_barplot") # Barplot output
                )
              )
            ),
            tabPanel( # GSEA pathways table
              title = "Table",
              sidebarLayout(
                sidebarPanel(
                  sliderInput(inputId = "fgsea_table_padj_slider",
                              label = "Select adjusted p-value filtering threshold:",
                              min = -35,
                              max = 0,
                              value = -4,
                              step = 1), # Slider for adjusted p-value threshold
                  radioButtons(inputId = "fgsea_NES_direction",
                               label = "Select NES direction (all, positive, negative):",
                               choices = c("all","positive","negative"),
                               selected = "all"), # NES direction
                  submitButton(text = "Submit", width = "100%")
                ),
                mainPanel(
                  downloadButton(outputId = "fgsea_table_download",
                                 label = "Download Table"), # Table download button
                  dataTableOutput("fgsea_sum_table") # Summary table output
                )
              )
            ),
            tabPanel( # Scatterplot for NES vs adjusted p-value
              title = "Plot",
              sidebarLayout(
                sidebarPanel(
                  sliderInput(inputId = "NES_padj_slider",
                              label = "Select adjusted p-value filtering threshold:",
                              min = -35,
                              max = 0,
                              value = -5,
                              step = 1), # Slider for p-value threshold
                  submitButton(text = "Submit", width = "100%")
                ),
                mainPanel(
                  plotOutput("fgsea_NES_scatter") # Scatterplot output
                )
              )
            )
          )
        )
      )
    )
  )
)


# Define the server logic
server <- function(input, output) {
  ## Sample Information Tab
  
  # Reactive expression to process and clean sample information data
  sample_data <- reactive({
    read.csv(file = input$sample_info_upload$datapath, row.names = 1) %>%
      setnames(old = colnames(.), new = gsub("\\.", "_", colnames(.))) %>% # Replace dots in column names with underscores
      mutate(PMI = as.integer(PMI), # Convert PMI to integer
             mRNA_Seq_reads = gsub(",", "", mRNA_Seq_reads), # Remove commas from mRNA_Seq_reads
             mRNA_Seq_reads = as.integer(mRNA_Seq_reads), # Convert mRNA_Seq_reads to integer
             Condition = ifelse(str_detect(Sample_ID, "C"), # Create a Condition column
                                "Control",
                                "HD")) %>%
      relocate(Condition, .after = "Sample_ID") %>% # Relocate Condition column after Sample_ID
      arrange(Sample_ID) %>% # Arrange rows by Sample_ID
      return()
  })
  
  # Render summary table of sample information
  output$sample_info_summary_table <- renderTable({
    req(input$sample_info_upload$datapath) # Ensure file upload
    
    sample_summary_cols <- colnames(sample_data())[-c(1, 3, 5)] # Exclude specific columns
    sample_summary_table(data = sample_data(), # Generate summary table
                         cols = sample_summary_cols)
  })
  
  # Render detailed sample information as a DataTable
  output$sample_info_table <- renderDataTable({
    req(input$sample_info_upload$datapath) # Ensure file upload
    
    label_sample_data(data = sample_data()) # Add labels and render
  })
  
  # Render violin plot summarizing sample information
  output$sample_info_plot <- renderPlot({
    req(input$sample_info_upload$datapath) # Ensure file upload
    req(input$sample_info_summary_variable) # Ensure input variable selection
    
    control_data <- subset_data(data = sample_data(), cond = "Control") # Subset Control data
    HD_data <- subset_data(data = sample_data(), cond = "HD") # Subset HD data
    
    sample_summary_plot(data = sample_data(), # Create violin plot
                        ctrl_data = control_data,
                        hd_data = HD_data,
                        sum_var = input$sample_info_summary_variable)
  })
  
  ## Counts Exploration Tab
  
  # Reactive expression to process counts data
  counts_data <- reactive({
    read.csv(input$counts_upload$datapath, row.names = 1) %>% # Load counts data
      return()
  })
  
  # Reactive expression to process counts metadata
  counts_metadata <- reactive({
    read.csv(file = input$counts_metadata$datapath, row.names = 1) %>% # Load metadata
      setnames(old = colnames(.), new = gsub("\\.", "_", colnames(.))) %>% # Replace dots in column names
      mutate(PMI = as.integer(PMI), # Convert PMI to integer
             mRNA_Seq_reads = gsub(",", "", mRNA_Seq_reads), # Remove commas
             mRNA_Seq_reads = as.integer(mRNA_Seq_reads), # Convert to integer
             Condition = ifelse(str_detect(Sample_ID, "C"), # Create Condition column
                                "Control",
                                "HD")) %>%
      relocate(Condition, .after = "Sample_ID") %>% # Relocate Condition column
      arrange(Sample_ID) %>% # Arrange rows by Sample_ID
      return()
  })
  
  # Render filtered counts summary table
  output$filtered_counts_summary_table <- renderTable({
    req(input$counts_upload$datapath) # Ensure file upload
    
    counts_summary_table(counts = counts_data(), # Generate summary table
                         perc_var = input$counts_percent_var,
                         num_nonzero = input$counts_nonzero)
  })
  
  # Render diagnostic variance scatter plot
  output$median_var_plot <- renderPlot({
    req(input$counts_upload$datapath) # Ensure file upload
    
    diagnostic_plot(counts = counts_data(), # Create variance scatter plot
                    plot_type = "variance",
                    perc_var = input$counts_percent_var,
                    log_scale = TRUE)
  })
  
  # Render diagnostic non-zero values scatter plot
  output$median_nonzero_plot <- renderPlot({
    req(input$counts_upload$datapath) # Ensure file upload
    
    diagnostic_plot(counts = counts_data(), # Create non-zero scatter plot
                    plot_type = "non_zeros",
                    num_nonzero = input$counts_nonzero)
  })
  
  # Render clustered heatmap of filtered counts
  output$counts_heatmap <- renderPlot({
    req(input$counts_upload$datapath) # Ensure file upload
    
    filtered_counts <- filter_counts(counts = counts_data(), # Filter counts data
                                     perc_var = input$counts_percent_var,
                                     num_nonzero = input$counts_nonzero)
    filt_counts_heatmap(filt_counts = filtered_counts) # Render heatmap
  })
  
  # Render PCA biplot
  output$counts_pca_biplot <- renderPlot({
    req(input$counts_upload$datapath) # Ensure file upload
    req(input$counts_metadata$datapath) # Ensure metadata upload
    
    filtered_counts <- filter_counts(counts = counts_data(), # Filter counts data
                                     perc_var = input$counts_percent_var,
                                     num_nonzero = input$counts_nonzero)
    pca_biplot(filt_counts = filtered_counts, # Render PCA biplot
               metadata = counts_metadata(),
               first_PC = paste0("PC", input$first_PC),
               second_PC = paste0("PC", input$second_PC)) 
  })
  
  ## Differential Expression Tab
  
  # Reactive expression to process differential expression results
  de_data <- reactive({
    read.csv(file = input$de_res_upload$datapath, row.names = 1) %>%
      rownames_to_column("ENSGID") %>% # Add row names as a column
      return()
  })
  
  # Render volcano plot for differential expression
  output$volcano_plot <- renderPlot({
    req(input$de_res_upload$datapath) # Ensure file upload
    
    de_volcano_plot(dataf = de_data(), # Create volcano plot
                    x_name = input$volc_plot_x,
                    y_name = input$volc_plot_y,
                    slider = input$volc_plot_padj_slider,
                    color1 = input$volc_plot_base_col,
                    color2 = input$volc_plot_high_col)
  })
  
  # Render summary table of differential expression
  output$de_summary <- renderDataTable({
    req(input$de_res_upload$datapath) # Ensure file upload
    
    de_summary_table(dataf = de_data(), # Generate summary table
                     slider = input$volc_plot_padj_slider)
  })
  
  ## GSEA Tab
  
  # Reactive expression to process GSEA results
  fgsea_data <- reactive({
    read.csv(input$fgsea_res_upload$datapath) %>% # Load GSEA results
      return()
  })
  
  # Render NES barplot for top pathways
  output$fgsea_NES_barplot <- renderPlot({
    req(input$fgsea_res_upload$datapath) # Ensure file upload
    
    fgsea_NES_barplot(fgsea_results = fgsea_data(), # Create barplot
                      pathway_name = "C2: Canonical Pathway",
                      num_paths = input$fgsea_top_path_slider)
  })
  
  # Render summary table of GSEA results
  output$fgsea_sum_table <- renderDataTable({
    req(input$fgsea_res_upload$datapath) # Ensure file upload
    
    fgsea_summary_table(fgsea_results = fgsea_data(), # Generate summary table
                        pathway_direction = input$fgsea_NES_direction,
                        padj_filter = input$fgsea_table_padj_slider)
  })
  
  # Enable download of GSEA summary table
  output$fgsea_table_download <- downloadHandler(
    filename = function() {"fgsea_c2pathway_res.csv"}, # Set download filename
    content = function(file){
      write_csv(fgsea_summary_table(fgsea_results = fgsea_data(), # Write filtered results to file
                                    pathway_direction = input$fgsea_NES_direction,
                                    padj_filter = input$fgsea_table_padj_slider), 
                file)
    }
  )
  
  # Render NES scatter plot for GSEA results
  output$fgsea_NES_scatter <- renderPlot({
    req(input$fgsea_res_upload$datapath) # Ensure file upload
    
    fgsea_NES_scatterplot(fgsea_results = fgsea_data(), # Create scatterplot
                          padj_filter = input$NES_padj_slider)
  })
}


# Combine the UI and server
shinyApp(ui, server)