curr_dir = getwd()
source_python(paste(curr_dir,"/python_ref.py", sep=""))

dat<-read_csv(paste(curr_dir,"/pred.csv",sep=""))
dat2<-read_csv(paste(curr_dir,"/silenceidx.csv",sep=""))

setwd('..')
dir_one_above <- getwd()
fin = paste(dir_one_above,'/data/audio/KDGE_2_glitch_SNR-6.wav',sep="")
fin2 = paste(dir_one_above, '/data/audio/KDGE_2_glitch_SNR-6.wav', sep="")


### function 0: hear the sound ## go button 0
function0 <- function(var) {
  fin = paste(dir_one_above,'/data/audio/pred_kegl-1.wav',sep="")
  wave<- fin
  # read and normalize wav file using tuneR
  data <- tuneR::readWave(wave) %>%
    tuneR::normalize(unit = c("1"), center = FALSE, rescale = FALSE)
  # extracting sampled data, y
  y = data@left
  
  # extracting the sample rate, Fs
  Fs = data@samp.rate
  
  # you can listen to the audio too!
  audio::play.audioSample(y, Fs)
}


### function 0: hear the sound ## go button 0
function00 <- function(var) {
  fin = paste(dir_one_above,'/data/audio/silencedintervals.wav',sep="")
  wave<- fin
  # read and normalize wav file using tuneR
  data <- tuneR::readWave(wave) %>%
    tuneR::normalize(unit = c("1"), center = FALSE, rescale = FALSE)
  # extracting sampled data, y
  y = data@left
  
  # extracting the sample rate, Fs
  Fs = data@samp.rate
  
  # you can listen to the audio too!
  audio::play.audioSample(y, Fs)
}



### function 1: show the heads of the dataframes ## go button 1
function1 <- function(x) {
  ifelse(x==5, print(head(dat)), print(head(dat2)))
}

### function 2: show the kable table ## go button 2
kab<- kable(
  dat,
  col.names = c("File", "TimeFrame", "Prediction"),
  align = c("l", "c", "c", "c", "c"),
  digits = 2,
  caption = "Model Prediction of Audio Anomaly"
) 
kab

kab2<- kable(
  dat2,
  col.names = c("File", "TimeFrame", "Prediction"),
  align = c("l", "c", "c", "c", "c"),
  digits = 2,
  caption = "Model Prediction of Audio Anomaly"
) 
function2 <- function(x) {
  
  ifelse(x==5,kab, kab2
  )
  
}


### function 3: show the predictions # go with button 3


plot1<- dat %>%
  ggplot(aes(x = starttime, y = prediction, size = 5)) +
  geom_point() +
  ggtitle("Model Predictions") +
  xlab("Time Points") +
  ylab("Prediction") +
  theme_minimal() 

plot2<- dat2 %>%
  ggplot(aes(x = start, y = end)) +
  geom_point() 

function3 <- function(x) {
    ifelse(x==5,print(plot1), print(plot2))
    
}





### function 4: show the original waveform # go with button 4

## some fancy ggplot which shows the wav form
fin = paste(dir_one_above,'/data/audio/pred_kegl-1.wav',sep="")

wave<- fin
wav <- readWave(wave) 

ss <- spectro(wav, plot = F)

mm <- melt(ss$amp) %>%
  dplyr::select(FrequencyIndex = Var1, TimeIndex = Var2, Amplitude = value)

ff <- melt(ss$freq) %>%
  dplyr::mutate(Frequency = value, FrequencyIndex = row_number(), Frequency = Frequency * 1000)

tt <- melt(ss$time) %>%
  dplyr::mutate(Time = value, TimeIndex = row_number())

sp <- mm %>%
  dplyr::left_join(ff, by = "FrequencyIndex") %>%
  dplyr::left_join(tt, by = "TimeIndex") %>%
  dplyr::select(Time, Frequency, Amplitude)


pop <-  sp %>% mutate(Freq.pop = Frequency, Amp.pop = Amplitude) %>%
  dplyr::select(-c(Amplitude, Frequency))

plot<- ggplot(data = pop, mapping = aes(x = Time, y = Amp.pop)) +
  geom_line(color = 'blue') +
  labs(x = "time (s)", y = "amplitude", title = 'Sound Waveform') +
  theme(plot.title = element_text(hjust = 0.5))

dat%>%
  mutate(predicted = ifelse(prediction > 0, 1,0)) %>%
  mutate(start = ifelse(prediction > 0, starttime, 0),
         end = ifelse(prediction > 0, lead(starttime), 0))  %>%
  select(c(start, end)) -> rects
plot1 <- plot +
  geom_rect(data=rects, inherit.aes=FALSE, aes(xmin=start, xmax=end, ymin=min(-200),
                                               ymax=max(5)), color="transparent", fill="red", alpha=0.5) +
  theme_minimal() +
  labs(subtitle = 'Predicted Anomalies Highlighted in Red')


## some fancy ggplot which shows the wav form
fin = paste(dir_one_above,'/data/audio/silencedintervals.wav',sep="")

wave<- fin
wav <- readWave(wave) 

ss <- spectro(wav, plot = F)

mm <- melt(ss$amp) %>%
  dplyr::select(FrequencyIndex = Var1, TimeIndex = Var2, Amplitude = value)

ff <- melt(ss$freq) %>%
  dplyr::mutate(Frequency = value, FrequencyIndex = row_number(), Frequency = Frequency * 1000)

tt <- melt(ss$time) %>%
  dplyr::mutate(Time = value, TimeIndex = row_number())

sp <- mm %>%
  dplyr::left_join(ff, by = "FrequencyIndex") %>%
  dplyr::left_join(tt, by = "TimeIndex") %>%
  dplyr::select(Time, Frequency, Amplitude)


pop <-  sp %>% mutate(Freq.pop = Frequency, Amp.pop = Amplitude) %>%
  dplyr::select(-c(Amplitude, Frequency))

plot<- ggplot(data = pop, mapping = aes(x = Time, y = Amp.pop)) +
  geom_line(color = 'blue') +
  labs(x = "time (s)", y = "amplitude", title = 'Sound Waveform') +
  theme(plot.title = element_text(hjust = 0.5))

dat %>%
  mutate(predicted = ifelse(prediction > 0, 1,0)) %>%
  mutate(start = ifelse(prediction > 0, starttime, 0),
         end = ifelse(prediction > 0, lead(starttime), 0))  %>%
  select(c(start, end)) -> rects
plot2 <- plot +
  geom_rect(data=rects, inherit.aes=FALSE, aes(xmin=start, xmax=end, ymin=min(-200),
                                               ymax=max(5)), color="transparent", fill="red", alpha=0.5) +
  theme_minimal() +
  labs(subtitle = 'Predicted Anomalies Highlighted in Red')

function4 <- function(x) {
 
  ifelse(x==5,print(plot1), print(plot2))
  
}






