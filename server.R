# loading packages
library(ggplot2)
library(igraph)

# analyzing tweets
dat <- read.csv("F1twts_2014-08-19 12:00:00.csv",
                stringsAsFactors=FALSE)
# create time variable:
dat$created <- as.POSIXct(dat$created)
# check "#F1" is in the tweet
dat$F1 <- grepl("#F1", dat$text)



shinyServer(function(input, output) {

  # Expression that generates a plot of the distribution. The expression
  # is wrapped in a call to renderPlot to indicate that:
  #
  #  1) It is "reactive" and therefore should be automatically 
  #     re-executed when inputs change
  #  2) Its output type is a plot 
  #
  
  

  output$distPlot <- renderPlot({

    # generate an rnorm distribution and plot it
    if(input$per_user){
      # subset data
      plot_data <- dat[(dat$screenName %in% input$users),] 
      # plot it
      g <- ggplot(plot_data,
             aes(x=created, color=screenName)) + 
           geom_line(stat="bin")
    } else {
      # copy data
      plot_data <- dat
      # plot it
      g <- ggplot(dat,
          aes(x=created)) + 
        geom_line(stat="bin", color="blue")
    }
    
    # if number of #F1 hashtags are important:
    if(input$F1){
      if(input$per_user){
        g <- g + geom_area(data=plot_data[plot_data$F1,],
                           aes(created,
                             color=screenName,
                             fill= screenName),
                           stat="bin")
      } else {
        g <- g + geom_area(data=plot_data[plot_data$F1,],
                           aes(created),
                           stat="bin",
                           color="red",
                           fill="red")
      }
    }

    # print the plot
    print(g)
  })
})
