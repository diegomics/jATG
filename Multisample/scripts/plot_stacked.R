# SET WORKING DIR
mywd <- commandArgs(trailingOnly = TRUE)[1]
setwd(mywd)

# SET ASM NAME 
asm_name <- commandArgs(trailingOnly = TRUE)[2]

# LOAD LIBRARIES
library(svglite)
library(ggplot2)
library(tidyr)
library(rcartocolor)

# Function to process the data
processData <- function(file_name) {
    # Read the data
    data <- read.table(file_name, header = TRUE, sep = "\t", check.names = FALSE)

    # Extract sample names from the header, excluding the 'length' column
    sample_names <- colnames(data)[-1]

    # Reshape the data from wide to long format
    long_data <- gather(data, key = "Sample", value = "count", -length)

    # Convert 'length' to factor with reversed order for plot
    long_data$length <- factor(long_data$length, levels = c(">10", "5-10", "2-5", "1-2", "0.5-1", "0.2-0.5", "<0.2"))

    # Set the order of the Samples based on the header order
    long_data$Sample <- factor(long_data$Sample, levels = sample_names)

    return(long_data)
}

# Function to plot stacked bar plot
plotStackedBar <- function(data, palette, title, y_axis, out_name) {
    palette_colors <- carto_pal(7, palette) # Palette for colors
    
    plot <- ggplot(data, aes(x = Sample, y = count, fill = length)) +
        geom_bar(stat = "identity", position = "stack") +
        scale_fill_manual(values = palette_colors, 
                          breaks = rev(levels(data$length)), 
                          labels = rev(levels(data$length))) +
        labs(title = title, y = y_axis, x = "Sample", fill = "RoH category (Mbp)") +
        theme_minimal() +
        theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
        guides(fill = guide_legend(reverse = TRUE)) # Reverse the legend order

    # Save the plot using svglite
    svglite(file = paste0(out_name, ".svg"), width = 10, height = 7)
    print(plot)
    dev.off()
}

# Process and plot for each file type
nROH_data <- processData(paste0(asm_name, "_samples_nROH.tsv"))
plotStackedBar(nROH_data, "PurpOr", "nRoH", "Count", "nRoH_samples_Stacked_Barplot")

fROH_data <- processData(paste0(asm_name, "_samples_fROH.tsv"))
plotStackedBar(fROH_data, "BluYl", "fRoH", "Proportion", "fRoH_samples_Stacked_Barplot")

lROH_data <- processData(paste0(asm_name, "_samples_lROH.tsv"))
plotStackedBar(lROH_data, "SunsetDark", "lRoH", "Length", "lRoH_samples_Stacked_Barplot")
