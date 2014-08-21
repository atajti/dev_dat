# loading packages
library(ggplot2)
library(shiny)

# analyzing tweets
dat <- read.csv("F1twts_2014-08-19 15:30:00.csv",
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
      # subset data by users and time
      plot_data <- dat[(dat$screenName %in% input$users) &
                       (as.numeric(dat$created) > input$date[1] &
                       as.numeric(dat$created) < input$date[2]),] 
      # plot it
      g <- ggplot(plot_data,
             aes(x=created, color=screenName)) + 
           geom_line(stat="bin") +
           labs(x="Time",
                y="Number of tweets",
                color="User")
    
    } else {
      # subset data by time
      plot_data <- dat[(as.numeric(dat$created) > input$date[1] &
                       as.numeric(dat$created) < input$date[2]),]
      # plot it
      g <- ggplot(plot_data,
          aes(x=created)) + 
        geom_line(stat="bin", color="blue") +
        labs(x="Time",
            y="Number of tweets",
            color="User")
    }
    
    # if number of #F1 hashtags are important:
    if(input$F1){
      if(input$per_user){
        g <- g + geom_area(data=plot_data[plot_data$F1,],
                           aes(created,
                             color=screenName,
                             fill= screenName),
                           stat="bin") +
        labs(fill="Users' #F1 tweets", color="Users' tweets")
      } else {
        g <- g + geom_area(data=plot_data[plot_data$F1,],
                           aes(created),
                           stat="bin",
                           color="red",
                           fill="red") +
        labs(fill="", color="")
      }
    }

    # print the plot
    print(g)
  })
})
