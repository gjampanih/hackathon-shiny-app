
library(flexdashboard)
library(tidyverse)
library(tuneR)
library(audio)
library(plotly)
library(oce)
#library(fftw)
library(cowplot)
library(dplyr)
library(seewave)
library(reshape2)
#library(findpython)

#py_dir <- find_python_cmd(minimum_version='3.0', maximum_version = '3.8')
#Sys.setenv(RETICULATE_PYTHON=py_dir)
#library(reticulate)

library(kableExtra)
source('helpers.R')




## UI page
ui <- fluidPage(
  
    titlePanel("This is the App"),
    
    sidebarLayout(
    
    sidebarPanel(
    selectInput("choose", "Select the Wav File", choices = c(5,7)),
    actionButton("gobutton0","Hear the sound for the Pred Kegl clip"),
    actionButton("gobutton00","Hear the sound for the Kid clip"),
    plotOutput("sound_output"),
    plotOutput("sound_output0")
    ),
    
    mainPanel(
   actionButton("gobutton1","Show the heads of df predictions"),
   actionButton("gobutton2","Show the kable table"),
   actionButton("gobutton3","Show the plot"),
   actionButton("gobutton4","Show the original waveform"),
   verbatimTextOutput("plot_model_output"),
   htmlOutput("kable_output"),
   plotOutput("plot_output"),
   plotOutput("plot2_output")
    )
    )
)
#library(reticulate)


## Server
server <- function(input,output){
    
  ### function 0: play the sound ## go button 0
  data0 <- eventReactive(input$gobutton0,{
    output_model<- function0(dat)
    output_model
  })
  ## Output the sound
  output$sound_output <- renderPlot({
    data0()
  })
  ### function 0: play the sound ## go button 0
  data00 <- eventReactive(input$gobutton00,{
    output_model<- function00(dat)
    output_model
  })
  ## Output the sound
  output$sound_output0 <- renderPlot({
    data00()
  })
  ### function 1: show the heads of the dataframes ## go button 1
  data <- eventReactive(input$gobutton1,{
    dat<- input$choose
    output_model<- function1(dat)
    output_model
  })
  ## Output the heads of data frame
  output$plot_model_output <- renderPrint({
    data()
  })
  ### function 2: show kable table ## go button 2
  data2 <- eventReactive(input$gobutton2,{
    dat<- input$choose
    output_model<- function2(dat)
    output_model
  })
  ## Output the predictions
  output$kable_output <- renderText({
    data2()
  })
  ### function 3: show plot ## go button 3
  data3 <- eventReactive(input$gobutton3,{
    dat<- input$choose
    output_model<- function3(dat)
    output_model
  })
  ## Output the predictions
  output$plot_output <- renderPlot({
    data3()
  })
  ### function 4: show plot ## go button 3
  data4 <- eventReactive(input$gobutton3,{
    dat<- input$choose
    output_model<- function4(dat)
    output_model
  })
  ## Output the predictions
  output$plot2_output <- renderPlot({
    data4()
  })

    
}
  
shinyApp(ui, server)