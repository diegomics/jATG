# SET WORKING DIR
mywd <- commandArgs(trailingOnly = TRUE)[1]
setwd(mywd)

# SET ASM NAME 
asm_name <- commandArgs(trailingOnly = TRUE)[2]

# LOAD LIBRARIES
library(ggplot2)
library(readr)
library(rcartocolor)
library(svglite)

# Function to process data
processData <- function(file_name) {
  # Read the data from the TSV file
  data <- read_tsv(file_name, col_types = cols())
  
  # Convert Sample to a factor with levels in the same order as in the file
  data$Sample <- factor(data$Sample, levels = data$Sample)
  
  return(data)
}

# Function to plot scatter plot
plotScatter <- function(data, value_column, palette, title, y_axis, out_name) {
    plot <- ggplot(data, aes(x = Sample, y = !!sym(value_column), color = Sample)) +
        geom_point(size = 6) +
        scale_color_carto_d(palette = palette) +
        theme_minimal() +
        labs(title = title, x = "Sample", y = y_axis) +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        guides(color = guide_legend(title = "Sample"))

    # Save the plot using svglite
    svglite(file = paste0(out_name, ".svg"), width = 8, height = 4)
    print(plot)
    dev.off()
}

# Process and plot for each file type
genomewide_he_data <- processData(paste0(asm_name, "_samples_Genomewide_He.tsv"))
plotScatter(genomewide_he_data, "Genomewide_He", "RedOr", "Genomewide Heterozygosity", "He Value", "Genomewide_He_Plot")

genomewide_propROH_data <- processData(paste0(asm_name, "_samples_Genomewide_propROH.tsv"))
plotScatter(genomewide_propROH_data, "Genomewide_propROH", "TealGrn", "Genomewide Proportion of RoH", "Proportion", "Genomewide_propROH_Plot")

totalROHsMb_data <- processData(paste0(asm_name, "_samples_totalROHsMb.tsv"))
plotScatter(totalROHsMb_data, "totalROHsMb", "Sunset", "Total RoHs in Mb", "Total RoHs (Mb)", "TotalROHsMb_Plot")

total_ROHs_number_data <- processData(paste0(asm_name, "_samples_Total_ROHs_number.tsv"))
plotScatter(total_ROHs_number_data, "Total_ROHs_number", "BurgYl", "Total Number of RoHs", "Number of RoHs", "Total_ROHs_Number_Plot")
