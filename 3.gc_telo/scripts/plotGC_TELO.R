args = commandArgs(trailingOnly=TRUE)

if (length(args)<6) {
  stop("Error 6 arguments needed!!! Usage: Rscript plotGC.R <GenomeFile> <minLen> <GC-File> <Telo-file> <GAP-BED> <outDir>", call.=FALSE)
}
options(scipen = 999)


args = commandArgs(trailingOnly=TRUE)

if (length(args)<6) {
  stop("Error 6 arguments needed!!! Usage: Rscript plotGC.R <GenomeFile> <minLen> <GC-File> <Telo-file> <GAP-BED> <outDir>", call.=FALSE)
}
options(scipen = 999)

genomeFile=read.table(args[1], header=FALSE, sep="\t")
minLen=as.numeric(args[2])*1000000
gcIN <- read.csv(args[3], sep='\t', header=FALSE, stringsAsFactors=TRUE)
teloIn <- read.csv(args[4], sep='\t', header=TRUE, stringsAsFactors=TRUE)
gapIn <- read.csv(args[5], sep="\t", header=FALSE, stringsAsFactors=TRUE)
outDir <- args[6]

#teloIn <- read.csv("/home/max/Desktop/test_JATG_telomeres/mPipNat2_l3_hap2/mPipNat2_l3_hap2_V1_TELOMERES_telomeric_repeat_windows.csv", sep=',', header=TRUE, stringsAsFactors=TRUE)


suppressPackageStartupMessages(library("karyoploteR"))


################################################################################
### INPUTS #####################################################################
################################################################################
#Prep GENOME
genomeFile <- genomeFile[genomeFile$V3>=minLen,]
custom.genome <- toGRanges(data.frame(chr=genomeFile$V2, start=rep(1, length(genomeFile$V2)), end=genomeFile$V3))

###############
#Prep GAPS

# if a chromosome has no gaps, you need to add it manually to the table 
contigs <- unique(genomeFile$V2)
nContigs <- length(contigs)

contigs_in_gaps <- levels(gapIn$V1)
V1_gap_complete <- subset(contigs, !(contigs %in% contigs_in_gaps))
V2_gap_complete <- rep(1, length(V1_gap_complete)) 
V3_gap_complete <- genomeFile$V3[match(V1_gap_complete, genomeFile$V2)]
V4_gap_complete <- rep("CODING", length(V1_gap_complete)) 


new_rows <- data.frame(V1 = V1_gap_complete, 
                       V2 = V2_gap_complete,
                       V3 = V3_gap_complete,
                       V4 = V4_gap_complete) 
# Adding new rows to gapIN
gapIn <- rbind(gapIn, new_rows)

gapIn$gieStain=""
gapIn[gapIn$V4=="CODING",]$gieStain <- "gneg"

# not showing any color, because of the borders!
gapIn[gapIn$V4=="GAP",]$gieStain <- "gpos75"

gap_counts <- table(gapIn[gapIn$gieStain == "gpos75", "V1"])

custom.gaps <- toGRanges(data.frame(chr=gapIn$V1, start=gapIn$V2, end=gapIn$V3, gieStain=gapIn$gieStain,  border=NA))

###############
#Prep GC
out <- strsplit(as.character(gcIN$V1),'_sliding:')
s <- do.call(rbind, out)
out <- strsplit(as.character(s[,2]),'-')

ranges <- do.call(rbind, out)

gcCont <- cbind(s[,1], as.numeric(ranges[,1]), as.numeric(ranges[,2]), as.numeric(gcIN$V2/100))
colnames(gcCont) <- c("chr", "start", "end", "gc")

gcCont <- as.data.frame(gcCont)
gc.cont <- toGRanges(gcCont)
gc.cont$gc <- as.numeric(gc.cont$gc)

avg_gc_content <- aggregate(as.numeric(gc) ~ chr, data = gcCont, FUN = mean)

###############
#Prep TELO
teloIn$start <- teloIn$window-10000
telLen=nchar(as.character(teloIn$telomeric_repeat[1]))
windowSize=teloIn$window[1]
teloIn$teloFreq <- (teloIn$forward_repeat_number+teloIn$reverse_repeat_number)/windowSize*telLen

teloCont <- cbind(as.character(teloIn$id), as.numeric(teloIn$start), as.numeric(teloIn$window), as.numeric(teloIn$teloFreq))
colnames(teloCont) <- c("chr", "start", "end", "telo")

teloCont <- as.data.frame(teloCont)
teloCont$start <- as.numeric(teloCont$start)
teloCont$end <- as.numeric(teloCont$end)
teloCont$telo <- as.numeric(teloCont$telo)
telo.cont <- toGRanges(teloCont)
telo.cont$telo <- as.numeric(telo.cont$telo)


## all chromosomes
outname <- paste(outDir, '/', "COMBINED_GAPS_GC_TELO_all.svg", sep="")

contigs <- unique(genomeFile$V2)
nContigs <- length(contigs)

## convert height as a function of the number of chromosomes!
tot_height <- nContigs * 2.5
svg(outname, height=tot_height, width=24)

## telomere upper bound is 5 times the 0.99 quantile
upper_limit_telomere <- quantile(telo.cont$telo, probs = 0.99)*5
telomere_max <- upper_limit_telomere

pp <- getDefaultPlotParams(plot.type=1)
pp$data1outmargin <- 300
pp$data1height <- 800
pp$data1inmargin <- 50
pp$ideogramheight <- 100


kp <- plotKaryotype(genome = custom.genome, cytobands=custom.gaps, plot.type=1, plot.params = pp)

#GENES
#kpPlotDensity(kp, custom.anno, window.size = 0.1e6, data.panel="ideogram", col="#3388FF", border="#3388FF", r0=0.5, r1=1)

#TELO
ticks_telo=c(0, telomere_max/2, telomere_max)
kpAddLabels(kp, labels = "%TELO", label.margin = 0.04, cex=0.75, r0=0.05, r1=0.45)
kpAxis(kp, cex=0.5, tick.pos = ticks_telo, ymin=0, ymax=telomere_max, r0=0.05, r1=0.45)
telo.cont$telo_modified <- ifelse(telo.cont$telo > telomere_max, telomere_max, telo.cont$telo)
kpLines(kp, data=telo.cont, y=telo.cont$telo_modified, ymin= 0, ymax=0.04, col="red", r0=0.05, r1=0.45)

#GC
ticks_gc=seq(0,1, length=3)
kpAddLabels(kp, labels = "%GC", label.margin = 0.04, cex=0.75, r0=0.55, r1=0.95)
kpAxis(kp, cex=0.5, tick.pos = ticks_gc, r0=0.55, r1=0.95)
kpBars(kp,data=gc.cont, y0=0.5, y1 = gc.cont$gc,
       col=colByValue(gc.cont$gc, colors = c("blue", "white", "red")), border=NA, r0=0.55, r1=0.95)
kpAddBaseNumbers(kp, units="Mb", tick.dist=10000000)


## adding number of gaps
for (chromosome_name in contigs){
  # Fetch the size for the specified chromosome name from genomeFile
  chromosome_size <- genomeFile$V3[genomeFile$V2 == chromosome_name]
  
  x <- c(chromosome_size + 7000000, chromosome_size + 7000000)
  y <- c(0.75, -0.15)
  gc_mean <- round(avg_gc_content[avg_gc_content$chr == chromosome_name, "as.numeric(gc)"], 3)
  label <- c(paste ("mean: ", gc_mean), paste( "# of gaps: ", gap_counts[chromosome_name]))
  kpText(kp, chr = c(chromosome_name), x=x, y=y, labels=label, cex = 0.8)
  
}


dev.off()


ticks_telo=c(0, telomere_max/2, telomere_max)
for(i in 1:nContigs){
  curCont <- contigs[i]
  
  outname <- paste(outDir, '/', curCont, "_GAPS_GC_TELO.svg", sep="")
  
  teloF<-teloCont[teloCont$chr==curCont, ]
  teloF$telo_modified <- ifelse(teloF$telo > telomere_max, telomere_max, teloF$telo)
  
  
  svg(outname, width=14, height=8)
  
  
  pp <- getDefaultPlotParams(plot.type=1)
  pp$data1outmargin <- 20
  pp$data1height <- 800
  pp$data1inmargin <- 50
  pp$ideogramheight <- 100
  
  
  kp <- plotKaryotype(genome = custom.genome, chromosomes=curCont, cytobands=custom.gaps, cex=1, plot.params = pp)
  kpAddBaseNumbers(kp, units="Mb", tick.dist=10000000)
  #GENES
  #kpPlotDensity(kp, custom.anno, window.size = 0.1e6, data.panel="ideogram", col="#3388FF", border="#3388FF", r0=0.5, r1=1)
  #kpPlotDensity(kp, custom.anno, window.size = 0.1e6, data.panel="ideogram", col="#3388FF", border="#3388FF", r0=0.5, r1=0)
  #TELO
  kpAddLabels(kp, labels = "%TELO", label.margin = 0.04, r0=0.05, r1=0.4, cex=0.8)
  kpAxis(kp, cex=0.7, r0=0.05, r1=0.4, tick.pos = ticks_telo, ymin=0, ymax=telomere_max)
  kpLines(kp, chr=curCont,  x=teloF$end, y=teloF$telo_modified, ymin= 0, ymax=telomere_max, col="red", r0=0.05, r1=0.4)
  #GC 
  kpAddLabels(kp, labels = "%GC", label.margin = 0.04, cex=0.8, r0=0.55, r1=0.9)
  kpAxis(kp, cex=0.7, tick.pos=ticks_gc, r0=0.55, r1=0.9)
  kpBars(kp,data=gc.cont, y0=0.5, y1 = gc.cont$gc, r0=0.55, r1=0.9,
         col=colByValue(gc.cont$gc, colors = c("blue", "white", "red")), border=NA)
  dev.off()
}

