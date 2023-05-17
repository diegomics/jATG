#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)


if (length(args)<2) {
  stop("Error 2 argument needed!!! Usage: Rscript plotHet.R <configFile> <out.svg>", call.=FALSE)
}

###############################################################################
############### FUNCTION ETC ##################################################
###############################################################################
customCols <- c("Unknown"="#999999",
                  "Other"="#4D4D4D",
                  "DNA.Academ"="#FF0000",
                  "DNA.CMC"="#FF200B",
                  "DNA.Crypton"="#FF3115",
                  "DNA.Ginger"="#FF3D1E",
                  "DNA.Harbinger"="#FF4825",
                  "DNA.hAT"="#FF512D",
                  "DNA.Kolobok"="#FF5A34",
                  "DNA.Maverick"="#FF623B",
                  "DNA"="#FF6A42",
                  "DNA.Merlin"="#FF7149",
                  "DNA.MULE"="#FF7850",
                  "DNA.P"="#FF7F57",
                  "DNA.PiggyBac"="#FF865E",
                  "DNA.Sola"="#FF8D65",
                  "DNA.TcMar"="#FF936C",
                  "DNA.Transib"="#FF9972",
                  "DNA.Zator"="#FF9F79",
                  "DNA.Dada"="#FFCFBC",
                  "DNA.Ginger-1"="#FFCFBC",
                  "DNA.Zisupton"="#FF8D65",
                  "RC.Helitron"="#FF00FF",
                  "LTR.DIRS"="#006400",
                  "LTR.Ngaro"="#197214",
                  "LTR.Pao"="#2A8024",
                  "LTR.Copia"="#3A8F33",
                  "LTR.Gypsy"="#489E42",
                  "LTR.ERVL"="#57AE51",
                  "LTR"="#65BD61",
                  "LTR.ERV1"="#73CD70",
                  "LTR.ERV"="#81DD80",
                  "LTR.ERVK"="#90ED90",
                  "LINE.L1"="#00008B",
                  "LINE"="#251792",
                  "LINE.RTE"="#38299A",
                  "LINE.CR1"="#483AA2",
                  "LINE.Rex-Babar"="#554BAA",
                  "LINE.L2"="#625CB1",
                  "LINE.Proto2"="#6E6DB9",
                  "LINE.LOA"="#797EC0",
                  "LINE.R1"="#848FC8",
                  "LINE.Jockey-I"="#8FA1CF",
                  "LINE.Dong-R4"="#99B3D7",
                  "LINE.R2"="#A3C5DE",
                  "LINE.Penelope"="#ACD8E5",
                  "LINE.CRE"="#C1D9FF",
                  "Retroposon.SVA"="#FF4D4D",
                  "SINE"="#9F1FF0",
                  "SINE.5S"="#A637F1",
                  "SINE.7SL"="#AD49F2",
                  "SINE.Alu"="#B358F3",
                  "SINE.tRNA"="#B966F4",
                  "SINE.tRNA-Alu"="#BF74F4",
                  "SINE.tRNA-RTE"="#C481F5",
                  "SINE.RTE"="#C98EF6",
                  "SINE.Deu"="#CE9BF7",
                  "SINE.tRNA-V"="#D3A7F7",
                  "SINE.MIR"="#D7B4F8",
                  "SINE.U"="#DFCDF9",
                  "SINE.tRNA-7SL"="#E2D9F9",
                  "SINE.tRNA-CR1"="#E5E5F9")

# function to parse the config file and create the table
parseConfig <- function(configIN){
  
  final_tab <- data.frame(Kimura=character(), vPer=character(), Category=character(), Sample=character(),
                          stringsAsFactors=FALSE)
  
  # loop over tabs in config file
  for (i in seq(1, nrow(configIN), 1)){
    sID <- configIN$V1[i]
    filePath <- configIN$V2[i]
    
    curTab <- read.table(filePath, sep = "\t", header = T)
  
      for (i in seq(2, ncol(curTab), 1)) {
        df <- data.frame(curTab$Divergence, curTab[,i])
        df$Category <- colnames(curTab)[i]
        df$Sample <- sID
        colnames(df) <- c("Kimura", "Per", "Category", "Sample")
        final_tab <- rbind(final_tab, df)
      }
  }
  return(final_tab)
}

###############################################################################
############### MAIN ##########################################################
###############################################################################
library(ggplot2)
confFile=read.table(args[1], header=F, sep="\t")
repData <- parseConfig(confFile)

svg(args[2], height=10, width=12)
ggplot(repData, aes(fill=Category, y=Per, x=Kimura, group=Category)) +
  geom_bar(position="stack", stat="identity") + ylab("Percentage of the genome")+
  scale_fill_manual(values=customCols) + facet_wrap(. ~ Sample, ncol = 3) + theme_bw() +
   theme(legend.position="bottom") + guides(fill=guide_legend(""))
dev.off()
