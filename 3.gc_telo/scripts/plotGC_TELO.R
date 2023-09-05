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



################################################################################
### FUNCTIONS ##################################################################
################################################################################
customCeiling <- function(x, Decimals=3) {
  x2<-x*10^Decimals
  ceiling(x2)/10^Decimals
}

################################################################################

suppressPackageStartupMessages(library("karyoploteR"))

################################################################################
### INPUTS #####################################################################
################################################################################
#Prep GENOME
genomeFile <- genomeFile[genomeFile$V3>=minLen,]
custom.genome <- toGRanges(data.frame(chr=genomeFile$V2, start=rep(1, length(genomeFile$V2)), end=genomeFile$V3))

###############
#Prep GAPS
gapIn$gieStain=""
gapIn[gapIn$V4=="CODING",]$gieStain <- "gneg"
gapIn[gapIn$V4=="GAP",]$gieStain <- "gpos75"
custom.gaps <- toGRanges(data.frame(chr=gapIn$V1, start=gapIn$V2, end=gapIn$V3, gieStain=gapIn$gieStain))
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


################################################################################
### PLOT ALL CONTIG ############################################################
################################################################################
ticks_gc=seq(0,1, length=3)

outname <- paste(outDir, '/', "COMBINED_GAPS_GC_TELO.svg", sep="")

svg(outname, height=16, width=12)
kp <- plotKaryotype(genome = custom.genome, cytobands=custom.gaps, cex=1)

#GENES
#kpPlotDensity(kp, custom.anno, window.size = 0.1e6, data.panel="ideogram", col="#3388FF", border="#3388FF", r0=0.5, r1=1)
#TELO
kpAddLabels(kp, labels = "%TELO", label.margin = 0.04, cex=0.4, r0=0, r1=0.5)
kpAxis(kp, cex=0.3, ymin=0, ymax=max(telo.cont$telo), r0=0, r1=0.5)
kpLines(kp, data=telo.cont, y=telo.cont$telo, ymin=0, ymax=max(telo.cont$telo), col="red", r0=0, r1=0.5)
#GC
kpAddLabels(kp, labels = "%GC", label.margin = 0.04, cex=0.4, r0=0.51, r1=1)
kpAxis(kp, cex=0.3, tick.pos = ticks_gc, r0=0.51, r1=1)
kpBars(kp,data=gc.cont, y0=0.5, y1 = gc.cont$gc, 
       col=colByValue(gc.cont$gc, colors = c("blue", "white", "red")), border=NA, r0=0.51, r1=1)

kpAddBaseNumbers(kp, units="Mb", tick.dist=10000000)
dev.off()

################################################################################
### PLOT PER CONTIG ############################################################
################################################################################
contigs <- unique(genomeFile$V2)
nContigs <- length(contigs)
ticks_gc <- c(0,0.25,0.5,0.75,1)
for(i in 1:nContigs){
  curCont <- contigs[i]
  
  outname <- paste(outDir, '/', curCont, "_GAPS_GC_TELO.svg", sep="")
  teloMax <- as.numeric(max(teloCont[teloCont$chr==curCont, ]$telo))
  ticks_telo <- seq(0, customCeiling(teloMax), length=2)
  
  teloF<-teloCont[teloCont$chr==curCont, ]
  
  svg(outname, width=14, height=8)
  kp <- plotKaryotype(genome = custom.genome, chromosomes=curCont, cytobands=custom.gaps, cex=1)
  kpAddBaseNumbers(kp, units="Mb", tick.dist=10000000)
  #GENES
  #kpPlotDensity(kp, custom.anno, window.size = 0.1e6, data.panel="ideogram", col="#3388FF", border="#3388FF", r0=0.5, r1=1)
  #kpPlotDensity(kp, custom.anno, window.size = 0.1e6, data.panel="ideogram", col="#3388FF", border="#3388FF", r0=0.5, r1=0)
  #TELO
  kpAddLabels(kp, labels = "%TELO", label.margin = 0.04, r0=autotrack(1,2), cex=0.8)
  kpAxis(kp, cex=0.7, r0=autotrack(1,2), ymin=0, ymax=teloMax, tick.pos = ticks_telo)
  kpLines(kp, chr=curCont, x=teloF$end, y=teloF$telo, col="red", r0=autotrack(1,2), ymin=0, ymax=teloMax)
  #GC 
  kpAddLabels(kp, labels = "%GC", label.margin = 0.04, cex=0.8, r0=autotrack(2,2))
  kpAxis(kp, cex=0.7, tick.pos=ticks_gc, r0=autotrack(2,2))
  kpBars(kp,data=gc.cont, y0=0.5, y1 = gc.cont$gc, r0=autotrack(2,2),
         col=colByValue(gc.cont$gc, colors = c("blue", "white", "red")), border=NA)
  dev.off()
}
