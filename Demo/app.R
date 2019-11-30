#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(rstudioapi)
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
setwd("..")
library(bnlearn)
library(shiny)
library(shinyjs)

MyData <- read.csv(file = "Data_discrete_10_final.csv", header = TRUE, sep = ";")
randomind = sample(nrow(MyData))
dataset <- MyData[randomind, ] 

dataset$x1 = factor(dataset$x1)
dataset$x2 = factor(dataset$x2)
dataset$x3 = factor(dataset$x3)
dataset$x4 = factor(dataset$x4)
dataset$y1 = factor(dataset$y1)
dataset$y2 = factor(dataset$y2)
dataset$y3 = factor(dataset$y3)
dataset$y4 = factor(dataset$y4)
dataset$z1 = factor(dataset$z1)
dataset$z2 = factor(dataset$z2)
dataset$z3 = factor(dataset$z3)
dataset$z4 = factor(dataset$z4)
#our_model = model2network("[class][x1|class][y1|class][z1|class][x3|class][y3|class][z3|class][x2|class:x1:x3][y2|class:y1:y3][z2|class:z1:z3][x4|class][y4|class][z4|class]")
our_model = model2network("[y2][z2][class|z2:y2][x1|class][x2|class][x3|class][x4|class][y4|class:y2][y3|y2:class][y1|y2:y3:class][z1|z2:class][z3|z1:z2:class][z4|z1:z3:class]")
our_fit = bn.fit(our_model, dataset, method = "bayes")

# Define UI for application that draws a histogram
ui <- fluidPage(
  navbarPage("",
             tabPanel(
               'Predizione in base ai sensori',
              sidebarLayout(
                mainPanel(
                  useShinyjs(),
                  h5('Sensore 1'),

                  div(style="display: inline-block;vertical-align:top; width: 100%;", 
                      checkboxInput("s1", "Evidence", FALSE)
                      ),
                
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("x1", "x",
                                  min = -75, max = 54, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("y1", "y",
                                  min = 0, max = 212, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("z1", "z",
                                  min = -603, max = 75, value = 0
                      )),
                  
                  h5('Sensore 2'),
                  div(style="display: inline-block;vertical-align:top; width: 100%;", 
                      checkboxInput("s2", "Evidence", FALSE)
                  ),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("x2", "x",
                                  min = -494, max = 473, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("y2", "y",
                                  min = -517, max = 241, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("z2", "z",
                                  min = -617, max = 122, value = 0
                      )),
                  
                  h5('Sensore 3'),
                  div(style="display: inline-block;vertical-align:top; width: 100%;", 
                      checkboxInput("s3", "Evidence", FALSE)
                  ),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("x3", "x",
                                  min = -499, max = 507, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("y3", "y",
                                  min = -506, max = 517, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("z3", "z",
                                  min = -613, max = 298, value = 0
                      )),
                  
                  h5('Sensore 4'),
                  div(style="display: inline-block;vertical-align:top; width: 100%;", 
                      checkboxInput("s4", "Evidence", FALSE)
                  ),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("x4", "x",
                                  min = -702, max = -13, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("y4", "y",
                                  min = -214, max = 9, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("z4", "z",
                                  min = -259, max = -43, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 45%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:bottom; width: 20%;", actionButton("update", "Calcola")),
                  
                  div(style="display: inline-block;vertical-align:bottom; width: 20%;", actionButton("reset", "Reset"))
                ),
                sidebarPanel(
                  div(style = "background-color: white; padding: 20px;",
                      img(src = "acc_pos.png", height = 250, width = 300),
                      h2('Posizione:'),
                      span(textOutput("probabilities"), style = "font-size:30px")
                  )
                )
              )
            ),
            tabPanel(
              'Predizione in base ai sensori discretizzati',
              sidebarLayout(
                mainPanel(
                  h5('Sensore 1'),
                  
                  div(style="display: inline-block;vertical-align:top; width: 100%;", 
                      checkboxInput("s1d", "Evidence", FALSE)
                  ),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("x1d", "x",
                                  min = 0, max = 4, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("y1d", "y",
                                  min = 0, max = 4, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("z1d", "z",
                                  min = 0, max = 4, value = 0
                      )),
                  
                  h5('Sensore 2'),
                  
                  div(style="display: inline-block;vertical-align:top; width: 100%;", 
                      checkboxInput("s2d", "Evidence", FALSE)
                  ),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("x2d", "x",
                                  min = 0, max = 4, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("y2d", "y",
                                  min = 0, max = 4, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("z2d", "z",
                                  min = 0, max = 4, value = 0
                      )),
                  
                  h5('Sensore 3'),
                  
                  div(style="display: inline-block;vertical-align:top; width: 100%;", 
                      checkboxInput("s3d", "Evidence", FALSE)
                  ),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("x3d", "x",
                                  min = 0, max = 4, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("y3d", "y",
                                  min = 0, max = 4, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("z3d", "z",
                                  min = 0, max = 4, value = 0
                      )),
                  
                  h5('Sensore 4'),
                  
                  div(style="display: inline-block;vertical-align:top; width: 100%;", 
                      checkboxInput("s4d", "Evidence", FALSE)
                  ),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("x4d", "x",
                                  min = 0, max = 4, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("y4d", "y",
                                  min = 0, max = 4, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 5%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:top; width: 28%;", 
                      sliderInput("z4d", "z",
                                  min = 0, max = 4, value = 0
                      )),
                  div(style="display: inline-block;vertical-align:top; width: 45%;",HTML("<br>")),
                  
                  div(style="display: inline-block;vertical-align:bottom; width: 20%;", actionButton("update_disc", "Calcola")),
                  
                  div(style="display: inline-block;vertical-align:bottom; width: 20%;", actionButton("resetd", "Reset"))
                ),
                sidebarPanel(
                  img(src = "acc_pos.png", height = 250, width = 300),
                  h2('Posizione:'),
                  span(textOutput("probabilities_disc"), style = "font-size:30px")
                )
              )
            )
    )
  )

# Define server logic required to draw a histogram
server <- function(input, output, session) {
  observeEvent(input$update, {
    # Change the following line for more examples
    output$probabilities <- renderText({ 
      # creating structure node=evidence
      variables = c(input$x1, input$y1, input$z1, input$x2, input$y2, input$z2, input$x3, input$y3, input$z3, input$x4, input$y4, input$z4)
      variables_name = c("x1", "y1", "z1", "x2", "y2", "z2", "x3", "y3", "z3", "x4", "y4", "z4")
      checkbokes = c(input$s1, input$s2, input$s3, input$s4)
      ev = list()
      discrete_ev = list()
      cutoffs = matrix(
        c(-76, -14, -8, -4, 1, 54, -1, 71, 91, 96, 102, 212, -604, -124, -104, -92, -60, 75, -495, -233, -18, -3, 6, 473, -518, -225, 10, 71, 88, 241, -628, -332, -124, -99, -26, 122, -500, 6, 17, 26, 38, 507, -507, 88, 104, 108, 123, 517, -614, -107, -96, -86, -77, 298, -703, -194, -176, -163, -149, -13, -215, -106, -94, -88, -77, 9, -260, -169, -163, -158, -152, -43),
        nrow = 12,
        ncol = 6,
        byrow = TRUE
      )
      
      for (i in 1 : length(variables)){
        if((checkbokes[1] == TRUE & i >= 1 & i <=3) | (checkbokes[2] == TRUE & i >= 4 & i <=6) | (checkbokes[3] == TRUE & i >= 7 & i <=9) |(checkbokes[4] == TRUE & i >= 10 & i <=12)){
          tmp_name = variables_name[i]
          tmp_v = variables[i]
          for(j in 1: 5){
            if(tmp_v > cutoffs[i, j] & tmp_v <= cutoffs[i, j+1]){
              val = j - 1
              ev[[tmp_name]] = toString(val)
            }
          }
        }
      }
      
      print(ev)
      
      if(length(ev) != 0){
        probs = list()
        
        positions_values = c("Sitting", "SittingDown", "Standing", "StandingUp", "Walking")
        
        tmp = list()
        s <- 0
        res = cpquery(our_fit, event=class=="sitting", method="lw", evidence = ev)
        tmp[[1]] = res
        s <- s + res
        
        res = cpquery(our_fit, event=class=="sittingdown", method="lw", evidence = ev)
        tmp[[2]] = res
        s <- s + res
        
        res = cpquery(our_fit, event=class=="standing", method="lw", evidence = ev)
        tmp[[3]] = res
        s <- s + res
        
        res = cpquery(our_fit, event=class=="standingup", method="lw", evidence = ev)
        tmp[[4]] = res
        s <- s + res
        
        res = cpquery(our_fit, event=class=="walking", method="lw", evidence = ev)
        tmp[[5]] = res
        s <- s + res
        
        for (i in 1 : 5){
          tmp[[i]] = round((tmp[[i]] / s), digits = 3) * 100
          probs[[i]] = paste0(positions_values[i], " : ", tmp[i], "%")
        }
        
        sprintf("%s", probs)
        
      }
      else{
        sprintf("Seleziona almeno un sensore")
      }
    })
  })
  
  observeEvent(input$update_disc, {
    output$probabilities_disc <- renderText({ 
      # creating structure node=evidence
      variables = c(input$x1d, input$y1d, input$z1d, input$x2d, input$y2d, input$z2d, input$x3d, input$y3d, input$z3d, input$x4d, input$y4d, input$z4d)
      variables_name = c("x1", "y1", "z1", "x2", "y2", "z2", "x3", "y3", "z3", "x4", "y4", "z4")
      ev = list()
      
      for (i in 1 : length(variables)){
        if((checkbokes[1] == TRUE & i >= 1 & i <=3) | (checkbokes[2] == TRUE & i >= 4 & i <=6) | (checkbokes[3] == TRUE & i >= 7 & i <=9) |(checkbokes[4] == TRUE & i >= 10 & i <=12)){
          tmp_name = variables_name[i]
          tmp_v = variables[i]
          ev[[tmp_name]] = toString(tmp_v)
        }
      }
      
      if(length(ev) != 0){
        probs = list()
        
        positions_values = c("Sitting", "SittingDown", "Standing", "StandingUp", "Walking")
        
        tmp = list()
        s <- 0
        res = cpquery(our_fit, event=class=="sitting", method="lw", evidence = ev)
        tmp[[1]] = res
        s <- s + res
        
        res = cpquery(our_fit, event=class=="sittingdown", method="lw", evidence = ev)
        tmp[[2]] = res
        s <- s + res
        
        res = cpquery(our_fit, event=class=="standing", method="lw", evidence = ev)
        tmp[[3]] = res
        s <- s + res
        
        res = cpquery(our_fit, event=class=="standingup", method="lw", evidence = ev)
        tmp[[4]] = res
        s <- s + res
        
        res = cpquery(our_fit, event=class=="walking", method="lw", evidence = ev)
        tmp[[5]] = res
        s <- s + res
        
        for (i in 1 : 5){
          tmp[[i]] = round((tmp[[i]] / s), digits = 3) * 100
          probs[[i]] = paste0(positions_values[i], " : ", tmp[i], "%")
        }
        
        sprintf("%s", probs)
        
      }
      else{
        sprintf("Seleziona almeno un sensore")
      }
    })
  })
  
  observeEvent(input$s1, {
    toggleState("x1")
    toggleState("y1")
    toggleState("z1")
  })
  
  observeEvent(input$s2, {
    toggleState("x2")
    toggleState("y2")
    toggleState("z2")
  })
  
  observeEvent(input$s3, {
    toggleState("x3")
    toggleState("y3")
    toggleState("z3")
  })
  
  observeEvent(input$s4, {
    toggleState("x4")
    toggleState("y4")
    toggleState("z4")
  })
  
  observeEvent(input$s1d, {
    toggleState("x1d")
    toggleState("y1d")
    toggleState("z1d")
  })
  
  observeEvent(input$s2d, {
    toggleState("x2d")
    toggleState("y2d")
    toggleState("z2d")
  })
  
  observeEvent(input$s3d, {
    toggleState("x3d")
    toggleState("y3d")
    toggleState("z3d")
  })
  
  observeEvent(input$s4d, {
    toggleState("x4d")
    toggleState("y4d")
    toggleState("z4d")
  })
  
  observeEvent(input$reset, {
    updateSliderInput(session, 'x1', value = 0)
    updateSliderInput(session, 'y1', value = 0)
    updateSliderInput(session, 'z1', value = 0)
    
    updateSliderInput(session, 'x2', value = 0)
    updateSliderInput(session, 'y2', value = 0)
    updateSliderInput(session, 'z2', value = 0)
    
    updateSliderInput(session, 'x3', value = 0)
    updateSliderInput(session, 'y3', value = 0)
    updateSliderInput(session, 'z3', value = 0)
    
    updateSliderInput(session, 'x4', value = 0)
    updateSliderInput(session, 'y4', value = 0)
    updateSliderInput(session, 'z4', value = 0)
  })
  
  observeEvent(input$resetd, {
    updateSliderInput(session, 'x1d', value = 0)
    updateSliderInput(session, 'y1d', value = 0)
    updateSliderInput(session, 'z1d', value = 0)
    
    updateSliderInput(session, 'x2d', value = 0)
    updateSliderInput(session, 'y2d', value = 0)
    updateSliderInput(session, 'z2d', value = 0)
    
    updateSliderInput(session, 'x3d', value = 0)
    updateSliderInput(session, 'y3d', value = 0)
    updateSliderInput(session, 'z3d', value = 0)
    
    updateSliderInput(session, 'x4d', value = 0)
    updateSliderInput(session, 'y4d', value = 0)
    updateSliderInput(session, 'z4d', value = 0)
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

