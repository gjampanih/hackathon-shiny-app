# source_python('/Users/katwilson/Desktop/iHeart/hackathon/shinyappF2/python_ref.py')
curr_dir = getwd()
dat<-read_csv(paste(curr_dir,"/pred.csv",sep=""))
dat2<-read_csv(paste(curr_dir,"/silenceidx.csv",sep=""))

setwd('..')
dir_one_above = getwd()

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
  col.names = c("Silence", "Start", "End"),
  align = c("l", "c", "c", "c", "c"),
  digits = 2,
  caption = "Model Prediction of Silence"
) 
function2 <- function(x) {
  
  ifelse(x==5,kab, kab2
  )
  
}


### function 3: show the predictions # go with button 3


dat_1 <- dat %>%
  mutate(prediction_class = case_when(prediction == "[0]" ~ 0,
                                      prediction == "[1]" ~ 1,
                                      prediction == "[2]" ~ 2))
plot1<- dat_1 %>%
  ggplot(aes(x = starttime, y = prediction, color = as.factor(prediction_class), size = 5)) +
  geom_point() +
  ggtitle("Model Predictions") +
  xlab("Time Points") +
  ylab("Prediction") +
  theme_minimal() +
  scale_color_manual(values=c("#00BA38", "#619CFF", "#F8766D")) +
  theme(legend.position = "none")

plot2<- dat2 %>%
  ggplot(aes(x = start, y = end)) +
  geom_point() 

function3 <- function(x) {
  ifelse(x==5,print(plot1), print(plot2))
  
}


function4 <- function(x) {
    ifelse(x==5,'Rplot1.png', 'Rplot2.png')
    
}











