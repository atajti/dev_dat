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
                             as.numeric(max(dat$created)))),
      helpText(HTML("<b>Break down tweets to user level:</b> Shows the number of
        tweets by users given in the box below. Only users with at least
        quarter of the most active can be chosen."), br(),
        HTML("<b>Display number of #F1 tweets:</b> Shows the number of tweets which
          contains the #F1 hashtag."), br(),
        HTML("<b>Users:</b> Which users' activity should be shown on user level?"), br(),
        HTML("<b>Time range:</b> When the tweets should become published to display.
          Some clues abou the meaning of the numbers can be seen on the horizontal axis."))
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot"),
      helpText(HTML("Tweets are downloaded from official accounts of FOM,
       F1 teams and drivers, also tweets tagged with '#F1'. This is an
       experimentation, its content may change, do not use as data source!"),
        br(),
        HTML("Code can be found at <a href='https://github.com/atajti/dev_dat.'>my GitHub</a>"))
    )
  )
))