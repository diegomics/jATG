# LOAD SCRIPT
source(commandArgs(trailingOnly = TRUE)[1])

# SET WORKING DIR
mywd <- commandArgs(trailingOnly = TRUE)[2]
setwd(mywd)

# LOAD LIBRARIES
#if(!"zoo"%in%rownames(installed.packages())){install.packages("zoo")}
#if(!"graphics"%in%rownames(installed.packages())){install.packages("graphics")}
library(zoo)
library(graphics)
library(tidyr)
library(ggplot2)
library(svglite)
library(rcartocolor)


# SET VALUES
window_size <- as.double(commandArgs(trailingOnly = TRUE)[3])
nr_windows <- as.double(commandArgs(trailingOnly = TRUE)[4])
miss_max <- as.double(commandArgs(trailingOnly = TRUE)[5])
hethres_vec <- as.double(commandArgs(trailingOnly = TRUE)[6])


# LOAD DATA
getwindowdata(maxmiss=miss_max,
              suffix=paste0(window_size, ".allsites_roh.txt"),
              mydir=mywd)


# CALCULATE GENOME-WIDE HETEROZYGOSITY
# window he
calcwindowhe(maxmiss=miss_max)
# region he
calcregionhe(maxmiss=miss_max, nwindows=nr_windows)

# Ratio between He within ROHs versus He outside ROHs: ??????????????????????????????
#calculate background he (i.e. excluding runs of homozygosity)
#esto anda pero el popboxplo2 no anda
#correcthe() # por lo que veo no suma nada al dwd$ind   hay que ver si no suma con el resultado de bcftools


# PLOT HETEROZYGOSITY
#Genomewide_He.pop.pdf:
#popboxplot(export="pdf", mywidth=5)
#He_with_vs_withoutROH.pop.pdf
#popboxplot2(export="pdf")

# esto da la misma información! # ver lo de las regiones!!!!!
write.table(data.frame(dwd$ind$name, dwd$ind$regionhe),
                       file = "Genomewide_He.txt",
                       sep = "\t",
                       row.names = FALSE,
                       col.names = c("Sample", "Het(%)"),
                       quote = FALSE)

write.table(cbind(Scaffold = rownames(dwd$chromhedf),
                  Het = apply(dwd$chromhedf, 1, function(x) ifelse(is.na(x), NA, sprintf("%.4f", x)))),
                  file = "Scaff_He.txt",
                  col.names = TRUE,
                  row.names = FALSE,
                  quote = FALSE,
                  sep = "\t")



#He_histo_region.pdf
indhisto(export="pdf",
         plotname="He_histo_region",
         inputdf=dwd$regionhedf,
         missdf=NULL,
         windowsize=window_size,
         nwindows=nr_windows,
         mybreaks=seq(-0.01,5,0.005),
         xmax=0.75,
         ymax=10,
         legendcex=1)

#Genomewide_regionHe.ind.barplot.pdf #da la misma informacion que #Genomewide_He.pop.pdf:
#indbarplot(export="pdf", mywidth=5)
#hay que cambiar los nombres porque están mal


# ESTO AHORA ES AL PEDO, SE PUEDE HACER UNA TABLITA QUE EN UN TXT QUE TE MUESTRE LAS DOS ESTIMACIONES MEJOR!

# In case you provided bcftools stats output, make a comparison between he-estimates generated with Darwindow versus he-estimates generated with bcftools: 
#indscatter(export="pdf",addlegend=FALSE,plotname="Darwindow_vs_Bcftools",xscore="he",yscore="bcfhe2",xlabel="Darwindow heterozygosity (%)",ylabel="Bcftools heterozygosity (%)",yline=5.5,symbolsize=2.5,labcex=2.75,add_diagonal=TRUE)

# DETECT RUNS OF HOMOZYGOSITY
#Region boolean values (indicating whether region has heterozygosity below threshold) have been stored in a dataframe stored as 'dwd$regionbooldf'.
#The number of rows equals the number of regions (by default 5 windows), the number of columns equals the number of samples plus one (column with scaffold name).
findroh(hethreshold=hethres_vec,
        windowsize=window_size,
        nwindows=nr_windows)

#ROH-lengths have been stored at 'dwd$lrohlist' (number of RLEs), and dwd$lrohlist2 (lengths in bp), as well as in dataframe dwd$allrohdf.
getrohlengths(windowsize=window_size, nrwindows=nr_windows)

# ROH-bin data has been stored at dwd$nrohbindf, dwd$lrohbindf and dwd$frohbindf.
getrohbin()


#PLOT ROH ACROSS SCAFFOLDS
#He_withROH_linechart2.50000.NC_059485.1.pdf para todos los scaf # hay que ver de cambiar el nombre
runindscaffold(height_unit=1,
               do_export=TRUE,
               input_df1=dwd$hedf,
               input_df2=dwd$frohdf,
               plot_label="He_withROH",
               add_roh=TRUE,
               add_he=TRUE,
               max_miss=miss_max,
               n_windows=nr_windows,
               window_size=window_size,
               line_width=0.1)


#Plot ROH summary statistics:
#Genomewide_froh_20000.pop.pdf # este es bien al pedo, se puede reemplazar con el valor como hice antes!
#popboxplot(export="pdf",
#           ymax=NULL,
#           indscore="froh",
#           plotname="Genomewide_froh",
#           ylabel="F_roh",
#           mywidth=5)

write.table(data.frame(dwd$ind$name, dwd$ind$froh),
                       file = "Genomewide_propROH.txt",
                       sep = "\t",
                       row.names = FALSE,
                       col.names = c("Sample", "propROH"),
                       quote = FALSE)

write.table(cbind(Scaffold = rownames(dwd$frohdf),
                  propROH = apply(dwd$frohdf, 1, function(x) ifelse(is.na(x), NA, sprintf("%.2f", x)))),
                  file = "Scaff_propROH.txt",
                  col.names = TRUE,
                  row.names = FALSE,
                  quote = FALSE,
                  sep = "\t")


# total length versus number: #plot al pedo!
#indscatter(export="pdf",plotname="Lroh_vs_Nroh",xscore="nroh",yscore="lroh",xlabel="Number of ROHs",ylabel="Total ROH length (Mb)",legendpos="bottomright",legendcex=1,yline=5.5)

#Total number of ROH
write.table(data.frame(dwd$ind$name, sum(dwd$nrohdf[,1], na.rm = TRUE)),
                       file = "Total_ROHs_number.txt",
                       sep = "\t",
                       row.names = FALSE,
                       col.names = c("Sample", "totalROHs"),
                       quote = FALSE)



#Total ROH lenght in Mb
write.table(data.frame(dwd$ind$name, sum(dwd$lrohlist2[[1]], na.rm = TRUE)/1000000),
                       file = "totalROHsMb.txt",
                       sep = "\t",
                       row.names = FALSE,
                       col.names = c("Sample", "totalROHsMb"),
                       quote = FALSE)


# total length versus heterozygosity: #grafico al pedo!!! ya tengo los valores!
#indscatter(export="pdf",plotname="Froh_vs_He",xscore="regionhe",yscore="froh",xlabel="Genome wide He",ylabel="F (ROH-content)",legendpos="topright",legendcex=0.85,yline=5.75)




# f-roh mean versus f-roh standard deviation across chromosomes: # medio al pedo....
#indscatter(export="pdf",plotname="Froh_mean_vs_sd",xscore="froh",yscore="froh_sd_scaffold",xlabel="F-roh mean",ylabel="F-roh sd (across chromosomes)",addlegend=FALSE,yline=5.75)

#The most informative ROH summary plot is arguably the stacked barplot:

stackedBarPlot <- function(data, sample, y_axis, palette, out_name){
  
  df <- data.frame(data)
  colnames(df) <- c("<0.2", "0.2-0.5", "0.5-1", "1-2", "2-5", "5-10", ">10")
  long_data <- gather(df, key="length", value="count")
  colnames(long_data)[colnames(long_data) == "count"] <- out_name
  
  long_data$length <- factor(long_data$length, levels = rev(unique(long_data$length)))
  
  palette_colors <- rev(carto_pal(7, palette))
  
  stacked_bar <- ggplot(long_data, aes(x = factor(1), y = !!sym(out_name), fill = length)) +
    geom_bar(stat = "identity", width = 0.6) +
    theme_minimal() +
    labs(title = "", y = y_axis, x = sample, fill = "RoH category (Mbp)") +
    theme(axis.text.x=element_blank(), axis.ticks.x=element_blank()) +
    scale_fill_manual(values = palette_colors)
  
  ggsave(paste0(out_name, ".svg"), stacked_bar, svg, width=10, height=7, bg="white")
  write.table(long_data, file=paste0(out_name, ".txt"), sep="\t", row.names=FALSE, quote=FALSE)
}

stackedBarPlot(dwd$nrohbindf, dwd$ind$name, "Number of RoH", "PurpOr", "nROH")
stackedBarPlot(dwd$frohbindf, dwd$ind$name, "Proportion of RoH", "BluYl", "fROH")
stackedBarPlot(dwd$lrohbindf, dwd$ind$name, "Total RoH length (Mbp)", "SunsetDark", "lROH")




# Save the generated data
save(dwd, file = "darwindow.RData")
