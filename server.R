# Load libraries.
library(shiny)
library(ggplot2)
library(scales)

# Load all support data and convert column names in each dataframe
lowest_fifth <- read.csv("/srv/shiny-server/Income_Race/Data/lowest_fifth.csv", header=TRUE)
names(lowest_fifth) <- c("Year", "White", "Black", "Hispanic", "Asian", "All Races")
second_fifth <- read.csv("/srv/shiny-server/Income_Race/Data/second_fifth.csv", header=TRUE)
names(second_fifth) <- c("Year", "White", "Black", "Hispanic", "Asian", "All Races")
third_fifth <- read.csv("/srv/shiny-server/Income_Race/Data/third_fifth.csv", header=TRUE)
names(third_fifth) <- c("Year", "White", "Black", "Hispanic", "Asian", "All Races")
fourth_fifth <- read.csv("/srv/shiny-server/Income_Race/Data/fourth_fifth.csv", header=TRUE)
names(fourth_fifth) <- c("Year", "White", "Black", "Hispanic", "Asian", "All Races")
highest_fifth <- read.csv("/srv/shiny-server/Income_Race/Data/highest_fifth.csv", header=TRUE)
names(highest_fifth) <- c("Year", "White", "Black", "Hispanic", "Asian", "All Races")
top_5_percent <- read.csv("/srv/shiny-server/Income_Race/Data/top_5_percent.csv", header=TRUE)
names(top_5_percent) <- c("Year", "White", "Black", "Hispanic", "Asian", "All Races")
average <- read.csv("/srv/shiny-server/Income_Race/Data/average.csv", header=TRUE)
names(average) <- c("Year", "White", "Black", "Hispanic", "Asian", "All Races")

shinyServer(
  # Function takes input from ui.R and returns output objects.
  function(input, output) {
    
    # Get income group from input list.
    income_group <- reactive({
      input$income_group  
    })
    
    # Get appropriate dataset/income category based on income group
    income_cat <- reactive({
      if (input$income_group == "Bottom 20% (1-20%)") {
        income_cat <- lowest_fifth }
      else if (input$income_group == "Second 20% (21-40%)") {
        income_cat <- second_fifth }
      else if (input$income_group == "Third 20% (41-60%)") {
        income_cat <- third_fifth }
      else if (input$income_group == "Fourth 20% (61-80%)") {
        income_cat <- fourth_fifth }
      else if (input$income_group == "Top 20% (81-100%)") {
        income_cat <- highest_fifth }
      else if (input$income_group == "Top 5% (96-100%)") {
        income_cat <- top_5_percent }
      else if (input$income_group == "Average") {
        income_cat <- average }
    })
    
    # Get year from input list.
    year <- reactive({
      input$year
    })
    
    # Get race(s) from input list.
    race <- reactive({
      input$race  
    })
    
    # Get income vector using race(s), year, and income category
    income <- reactive({
      r <- race()
      ic <- income_cat()
      y <- year()
      income <- c()
      for (i in 1:length(r)) {
        newline <- ic[ic$Year==y, r[i]]
        income <- c(income,newline)
      }
      return(income)
    })
    
    # Create a dataframe of reactive race and income data from race(s) and income
    df <- reactive({
      df <- data.frame(Race = factor(race()), Income = income())
      #          if (is.null(Income)) {
      #            df <- NULL
      #          } else {
      #            df <- df
      #          }
      #          return(df)
    })
    
    # Create a reactive barplot from all the inputs
    output$plot <- renderPlot({
      newplot <- ggplot(data=df(), aes(x=Race, y=Income, fill=Race, label=comma(Income))) + geom_bar(stat="identity", width=.75)
      newplot <- newplot + scale_y_continuous(labels = comma) + geom_text(fontface="bold") + labs(y = "Income ($)")
      newplot <- newplot + theme(axis.text=element_text(size=12), axis.title=element_text(size=14,face="bold"))
      print(newplot)
    })
  }
)

