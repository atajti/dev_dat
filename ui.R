library(shiny)
library(ggplot2)

# analyzing tweets
dat <- read.csv("F1twts_2014-08-19 15:30:00.csv",
                stringsAsFactors=FALSE)
# create time variable:
dat$created <- as.POSIXct(dat$created)
# create a ggplot with users:
scnames <- sort(names(table(dat$screenName))[
  which(table(dat$screenName) > 0.25*max(table(dat$screenName)))])
# check "#F1" is in the tweet
dat$F1 <- grepl("#F1", dat$text)


# ui.R for shiny tweet number visualzation
shinyUI(fluidPage(

  # Application title
  titlePanel("Number of F1 tweets"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      # checkBoxGroup("opts",
      #               "Tweets to display:",
      #               choices=c("#F1",
      #                         "Official tweets",
      #                         "Teams",
      #                         "Drivers",
      #                         "All",
      #                         "Random",
      #                         "Other"),
      #               selected="All"),
      
      # set if user partition is interesting
      checkboxInput("per_user",
                    "Break down tweets to user level",
                    FALSE),
      # set if Number of #F1 is interesting
      checkboxInput("F1",
                    "Display number of #F1 tweets",
                    FALSE),


      selectInput(inputId="users",
                  label="Users:",
                  choices=scnames,
                  multiple=TRUE,
                  selected=sample(scnames,3)),
    

      sliderInput(inputId="date",
                     label="Time range",
                     min=as.numeric(min(dat$created)),
                     max=as.numeric(max(dat$created)),
                     value=c(as.numeric(min(dat$created)),
                             as.numeric(max(dat$created))))
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))