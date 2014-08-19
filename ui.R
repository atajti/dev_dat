# analyzing tweets
dat <- read.csv("F1twts_2014-08-19 12:00:00.csv",
                stringsAsFactors=FALSE)
# create time variable:
dat$created <- as.POSIXct(dat$created)
# create a ggplot with users:
scnames <- sort(unique(dat$screenName))



# ui.R for shiny tweet number visualzation
shinyUI(fluidPage(

  # Application title
  titlePanel("Number of F1 tweets"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("users",
                  "Users:",
                  scnames,
                  multiple=TRUE)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))