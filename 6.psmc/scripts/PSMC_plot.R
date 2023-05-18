# Plotting through ggplot (R)
# Loading libraries, defining paths, variables
library(tidyverse)
library(scales)
PLOT_FILE_PATH <- "/home/larissaarantes/Documents/Larissa/PSMC/HardMask_27Chrom_boot.combined"

# Reading in data
Ind1_data <- read_tsv(paste(PLOT_FILE_PATH,"EleMax_HardMask_27Chrom_boot.combined_plot.0.txt",sep="/"),col_names = FALSE)
Boot1_data <- read_tsv(paste(PLOT_FILE_PATH,"EleMax_HardMask_27Chrom_boot.combined_plot.1.txt",sep="/"),col_names = FALSE)
Boot2_data <- read_tsv(paste(PLOT_FILE_PATH,"EleMax_HardMask_27Chrom_boot.combined_plot.2.txt",sep="/"),col_names = FALSE)
Boot3_data <- read_tsv(paste(PLOT_FILE_PATH,"EleMax_HardMask_27Chrom_boot.combined_plot.3.txt",sep="/"),col_names = FALSE)
Boot4_data <- read_tsv(paste(PLOT_FILE_PATH,"EleMax_HardMask_27Chrom_boot.combined_plot.4.txt",sep="/"),col_names = FALSE)
Boot5_data <- read_tsv(paste(PLOT_FILE_PATH,"EleMax_HardMask_27Chrom_boot.combined_plot.5.txt",sep="/"),col_names = FALSE)
Boot6_data <- read_tsv(paste(PLOT_FILE_PATH,"EleMax_HardMask_27Chrom_boot.combined_plot.6.txt",sep="/"),col_names = FALSE)
Boot7_data <- read_tsv(paste(PLOT_FILE_PATH,"EleMax_HardMask_27Chrom_boot.combined_plot.7.txt",sep="/"),col_names = FALSE)
Boot8_data <- read_tsv(paste(PLOT_FILE_PATH,"EleMax_HardMask_27Chrom_boot.combined_plot.8.txt",sep="/"),col_names = FALSE)
Boot9_data <- read_tsv(paste(PLOT_FILE_PATH,"EleMax_HardMask_27Chrom_boot.combined_plot.9.txt",sep="/"),col_names = FALSE)
Boot10_data <- read_tsv(paste(PLOT_FILE_PATH,"EleMax_HardMask_27Chrom_boot.combined_plot.10.txt",sep="/"),col_names = FALSE)

paleo_temp <- read_tsv(paste(PLOT_FILE_PATH,"All_palaeotemps.txt",sep="/"),col_names = TRUE)

# paleo_temp: Utilising  Zachos et al (2008) & Hansen et al (2013) as summarised through http://gergs.net/all_palaeotemps-2/ for temperature traces.
# Need to get paleo_time scale into years
paleo_temp <- paleo_temp %>% mutate(Age_years=`Age My`*1000000)
# Going to filter to only include Zachos et al (2008) & Hansen et al (2013) as covers whole time scale of data
# Removing any records older than oldest date for any of the psmc plots
paleo_temp <- paleo_temp %>% filter(Age_years < max(Ind1_data$X1,
                                                    Boot1_data$X1,
                                                    Boot2_data$X1,
                                                    Boot3_data$X1,
                                                    Boot4_data$X1,
                                                    Boot5_data$X1,
                                                    Boot6_data$X1,
                                                    Boot7_data$X1,
                                                    Boot8_data$X1,
                                                    Boot9_data$X1,
                                                    Boot10_data$X1))
  
paleo_temp <- paleo_temp %>% filter(Source=="Zachos et al (2008) & Hansen et al (2013)")
# Averaging any temperatures where multiple records exist for a given time point
paleo_temp <- paleo_temp %>% group_by(`Age_years`) %>% summarise(mean_temp_anom=mean(`Temperature anomaly`))

# Finding what the smallest "gap" is between entries in the paleo_temp
gaps <- 5000
i_record <- NULL
for (i in 1:(dim(paleo_temp)[1]-1)) {
  temp_gap <- paleo_temp$Age_years[i+1]-paleo_temp$Age_years[i]
  if (temp_gap < gaps ) {
    gaps <- temp_gap
    i_record <- i
  }
}

# It (i.e. "gaps") is 100 years

# Interpolating to 100 year intervals so that temperature can be plotted in the background
paleo_temp$Age_years <- round(paleo_temp$Age_years,-1)
one_year_time_slice <- seq(min(paleo_temp[,1]),max(paleo_temp[,1]),100)
fill_in <- rep(NA,length(one_year_time_slice))
fill_in[which(one_year_time_slice %in% paleo_temp$Age_years)] <- paleo_temp$mean_temp_anom

for (i in 2:length(fill_in)) {
  if (is.na(fill_in[i])) {
    fill_in[i] <- fill_in[i-1]
  }
}

interpolated_paleo_temp <- as_tibble(cbind(one_year_time_slice,fill_in))

# Obtaining the maximum Ne for plotting the turtle data
maximum_Ne <- max(Ind1_data$X2,
                  Boot1_data$X2,
                  Boot2_data$X2,
                  Boot3_data$X2,
                  Boot4_data$X2,
                  Boot5_data$X2,
                  Boot6_data$X2,
                  Boot7_data$X2,
                  Boot8_data$X2,
                  Boot9_data$X2,
                  Boot10_data$X2)

# Diving the time scale by 10,000 to help with plotting
interpolated_paleo_temp$one_year_time_slice <- interpolated_paleo_temp$one_year_time_slice/10000
Ind1_data$X1 <- Ind1_data$X1/10000
Boot1_data$X1 <- Boot1_data$X1/10000
Boot2_data$X1 <- Boot2_data$X1/10000
Boot3_data$X1 <- Boot3_data$X1/10000
Boot4_data$X1 <- Boot4_data$X1/10000
Boot5_data$X1 <- Boot5_data$X1/10000
Boot6_data$X1 <- Boot3_data$X1/10000
Boot7_data$X1 <- Boot4_data$X1/10000
Boot8_data$X1 <- Boot8_data$X1/10000
Boot9_data$X1 <- Boot9_data$X1/10000
Boot10_data$X1 <- Boot10_data$X1/10000

ggplot() +
  geom_rect(interpolated_paleo_temp,
            mapping=aes(xmin=one_year_time_slice-(50/10000),
                        xmax=one_year_time_slice+(50/10000),ymin=0,ymax=maximum_Ne,
                        fill=fill_in),alpha=0.3) +
  scale_fill_fermenter(palette="RdBu",name="°C vs\n1960-1990\naverage",position="right") +
  geom_step(data=Ind1_data,mapping = aes(x=X1,y=X2),color="black",size=1, alpha=0.7) +
  geom_step(data=Boot1_data,mapping = aes(x=X1,y=X2),color="black",size=0.7, alpha=0.3) +
  geom_step(data=Boot2_data,mapping = aes(x=X1,y=X2),color="black",size=0.7, alpha=0.3) +
  geom_step(data=Boot3_data,mapping = aes(x=X1,y=X2),color="black",size=0.7, alpha=0.3) +
  geom_step(data=Boot4_data,mapping = aes(x=X1,y=X2),color="black",size=0.7, alpha=0.3) +
  geom_step(data=Boot5_data,mapping = aes(x=X1,y=X2),color="black",size=0.7, alpha=0.3) +
  geom_step(data=Boot6_data,mapping = aes(x=X1,y=X2),color="black",size=0.7, alpha=0.3) +
  geom_step(data=Boot7_data,mapping = aes(x=X1,y=X2),color="black",size=0.7, alpha=0.3) +
  geom_step(data=Boot8_data,mapping = aes(x=X1,y=X2),color="black",size=0.7, alpha=0.3) +
  geom_step(data=Boot9_data,mapping = aes(x=X1,y=X2),color="black",size=0.7, alpha=0.3) +
  geom_step(data=Boot10_data,mapping = aes(x=X1,y=X2),color="black",size=0.7, alpha=0.3) +
  theme_bw() +
  theme_bw(base_size = 14) +
  coord_cartesian(ylim=c(0,6.232291),xlim=c(1,3000)) +
  scale_x_log10(breaks=c(1,10,100,1000,10000), 
                name=expression(bold('Time (years) ×'~10^4)),
                expand=c(0,0),
                labels=comma_format(accuracy=1)) +
  scale_y_continuous(name=expression(bold('Effective population size'~(10^4))),
                     expand=c(0,0)) +
  theme(axis.title = element_text(face="bold", colour = "black")) +
  theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank()) +
  theme(legend.position = c(0.89, 0.3),
        axis.ticks.y = element_line()) +
  annotation_logticks(sides="b")

ggsave("psmc.pdf",units = "in",width = 10,height=5)
ggsave("psmc.png",units = "in",width = 10,height=5)
