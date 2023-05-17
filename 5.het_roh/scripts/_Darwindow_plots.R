# LOAD FUNCTIONS:
source(commandArgs(trailingOnly = TRUE)[1])
library("zoo")

# LOAD FILES:
mywd <- commandArgs(trailingOnly = TRUE)[2]
setwd(mywd)
getwindowdata(suffix=commandArgs(trailingOnly = TRUE)[3],samplefile="popfile.txt",vcfsamples="myvcfsamples.txt",annotated=FALSE,indlevel=TRUE,poplevel=FALSE,mydir=mywd)

# CALCULATE HETEROZYGOSITY:
window_size	<- 100000	# window size in bp
nr_windows	<- 5			# minimum number of adjacent windows to be considered as a ROH (for example: if n_windows is set 5, and window size is 100000, then reported ROHs are minimum 500Kb)
missmax		<- 0.8
calcwindowhe(maxmiss=missmax)
calcregionhe(maxmiss=missmax,nwindows=nr_windows)

# FIND RUNS OF HOMOZYGOSITY:
findroh(silent=TRUE,hethreshold=0.05,min_rle_length=1,windowsize=window_size,nwindows=nr_windows)
getrohlengths(windowsize=window_size,nrwindows=nr_windows)
getrohbin()

# Ratio between He within ROHs versus He outside ROHs:
correcthe()

# CREATE PLOTS:
popboxplot(export="pdf")
popboxplot2(export="pdf")
indhisto(export="pdf",plotname="He_histo_region",inputdf=dwd$regionhedf,missdf=NULL,windowsize=window_size,nwindows=nr_windows)
indhisto(export="pdf",plotname="He_histo_region",inputdf=dwd$regionhedf,missdf=NULL,windowsize=window_size,nwindows=nr_windows,mybreaks=seq(-0.01,23,0.005),xmax=10,ymax=0.75)
indboxplot(export="pdf",inputdf=dwd$hedf,plotname="Genomewide_windowHe",ylabel="Heterozygosity (%)",yline=3.25,samplesize=500,maxmiss=miss_thres,ymax=23,mywidth=1.5)
popboxplot(export="pdf")

indhisto(export="pdf",plotname="He_histo_region",inputdf=dwd$regionhedf,missdf=NULL,windowsize=window_size,nwindows=nr_windows)
runindhisto(exporttype="pdf",plot_name="He_histo_window_20000",window_size=window_size,n_windows=nr_windows,x_max=0.6,y_max=12.5,silent=FALSE,missrange=seq(0.3,0.9,0.1),legend_cex=1.35)
indbarplot(export="pdf",mywidth=5)
indboxplot(export="pdf",inputdf=dwd$hedf,plotname="Genomewide_windowHe",ymax=0.7,ylabel="Heterozygosity (%)",yline=3.25,samplesize=500,maxmiss=missmax)
indboxplot(export="pdf",inputdf=dwd$regionhedf,plotname="Genomewide_regionHe",ymax=0.7,ylabel="Heterozygosity (%)",yline=3.25,samplesize=500)
# In case you provided bcftools stats output, make a comparison between he-estimates generated with Darwindow versus he-estimates generated with bcftools: 
indscatter(export="pdf",addlegend=FALSE,plotname="Darwindow_vs_Bcftools",xscore="he",yscore="bcfhe2",xlabel="Darwindow heterozygosity (%)",ylabel="Bcftools heterozygosity (%)",yline=5.5,symbolsize=2.5,labcex=2.75,add_diagonal=TRUE)
rohbarplot(inputdf=dwd$frohbindf,ylabel="F-roh",plotname="ROHf_barplot",export="pdf",yline=3,mywidth=0.2,legendcex=1.75,addlegend=TRUE,mycolours=NULL,ypopcol=0.775,legx=20,legy=0.725,mybg="lightblue4",axiscol="grey80")
rohbarplot(inputdf=dwd$frohbindf,ylabel="F-roh",plotname="ROHf_barplot",export="pdf",yline=3,mywidth=0.2,legendcex=1.75,addlegend=TRUE,mycolours=NULL,ypopcol=0.775,legx=20,legy=0.725)
rohbarplot(inputdf=dwd$lrohbindf,ylabel="Total ROH-length",plotname="ROHl_barplot",export="pdf",yline=4.5,mywidth=0.2,legendcex=1.75,addlegend=TRUE,mycolours=NULL,ypopcol=1850,legx=18.5,legy=1550)
rohbarplot(inputdf=dwd$nrohbindf,ylabel="# ROHs",plotname="ROHn_barplot",export="pdf",yline=4.5,mywidth=0.2,legendcex=1.75,addlegend=TRUE,mycolours=NULL,ypopcol=1850,legx=20,legy=1700)
#
# CREATE SCAFFOLD PLOTS:
# These plots are crucial. Have a look at them and observe whether regions marked as ROH (grey areas) do indeed have low heterozygosity. If not, rerun with different settings.
runindscaffold(do_export=TRUE,input_df1=dwd$hedf,input_df2=dwd$frohdf,plot_label="He_withROH",add_roh=TRUE,add_he=TRUE,add_dxy=FALSE,max_miss=missmax,n_windows=nr_windows,min_rle_len=1,window_size=window_size)
popboxplot(export="pdf",ymax=NULL,indscore="froh",plotname="Genomewide_froh_20000",ylabel="F_roh")
#
# SUMMARY PER CHROMOSOME:
chrombarplot(inputdf1=dwd$chromhedf,inputdf2=dwd$frohdf,plotlabel="Chrom_barplot",export=TRUE,silent=TRUE,win_size=window_size)
#
# SUMMARY PLOTS:
# total length versus ROH number per 100 bp: 
indscatter(export="pdf",plotname="Froh_vs_NrohPER100Mb_20000",xscore="nroh_per100Mb",yscore="froh",x_lim=c(0,100),y_lim=c(0,1),xlabel="# ROHs per 100Mb",ylabel="F-roh",legendpos="topleft",yline=4,addlegend=FALSE,symbolsize=3)
# total length versus number:
indscatter(export="pdf",plotname="Lroh_vs_Nroh_20000",xscore="nroh",yscore="lroh",xlabel="Number of ROHs",ylabel="Total ROH length (Mb)",legendpos="topleft",yline=5.5,legendcex=1.25,symbolsize=3)
indscatter(export="pdf",plotname="Lroh_vs_Nroh_20000",xscore="nroh",yscore="lroh",xlabel="Number of ROHs",ylabel="Total ROH length (Mb)",legendpos="topleft",yline=5.5,addlegend=FALSE,symbolsize=3,mybg="lightblue4",axiscol="grey80")
indscatter(export="pdf",plotname="Lroh_vs_Nroh_20000",xscore="nroh",yscore="lroh",xlabel="Number of ROHs",ylabel="Total ROH length (Mb)",legendpos="topleft",yline=5.5,legendcex=1.25,symbolsize=3,mybg="lightblue4",axiscol="grey80")
# total length versus heterozygosity:
indscatter(export="pdf",plotname="Froh_vs_He_20000",xscore="regionhe",yscore="froh",xlabel="Genome wide He",ylabel="F (ROH-content)",legendpos="bottomleft",yline=5.75,addlegend=FALSE,symbolsize=3)
indscatter(export="pdf",plotname="Froh_vs_He_20000",xscore="regionhe",yscore="froh",xlabel="Genome wide He",ylabel="F (ROH-content)",legendpos="bottomleft",yline=5.75,legendcex=1.4,symbolsize=3)
indscatter(export="pdf",plotname="Froh_vs_He_20000",xscore="regionhe",yscore="froh",xlabel="Genome wide He",ylabel="F (ROH-content)",legendpos="bottomleft",yline=5.75,addlegend=FALSE,symbolsize=3,mybg="lightblue4",axiscol="grey80")
indscatter(export="pdf",plotname="Froh_vs_He_20000",xscore="regionhe",yscore="froh",xlabel="Genome wide He",ylabel="F (ROH-content)",legendpos="bottomleft",yline=5.75,legendcex=1.4,symbolsize=3,mybg="lightblue4",axiscol="grey80")
# froh versus number:
indscatter(export="pdf",plotname="Froh_vs_Nroh",xscore="nroh",yscore="froh",xlabel="Number of ROHs",ylabel="F (ROH-content)",legendpos="topright",yline=5.5,labels=FALSE,symbolsize=3,logx=FALSE,logy=FALSE,addlegend=FALSE)
indscatter(export="pdf",plotname="Froh_vs_Nroh",xscore="nroh",yscore="froh",xlabel="Number of ROHs",ylabel="F (ROH-content)",legendpos="topright",yline=5.5,labels=FALSE,symbolsize=3,logx=TRUE,logy=TRUE,addlegend=FALSE)
indscatter(export="pdf",plotname="Froh_vs_Nroh",xscore="nroh",yscore="froh",xlabel="Number of ROHs",ylabel="F (ROH-content)",legendpos="topright",yline=5.5,labels=FALSE,symbolsize=3,logx=TRUE,logy=TRUE,addlegend=FALSE,mybg="lightblue4",axiscol="grey80")
# f-roh mean versus f-roh standard deviation across chromosomes:
indscatter(export="pdf",textdf=mytextdf,plotname="Froh_mean_vs_sd",xscore="froh",yscore="froh_sd_scaffold",xlabel="F-roh mean",ylabel="F-roh sd (across chromosomes)",addlegend=FALSE,yline=5.75)

