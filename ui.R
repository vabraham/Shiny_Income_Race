# Load libraries
library(shiny)

shinyUI(fluidPage(
  
  tags$head(
    tags$style(HTML("@import url('//fonts.googleapis.com/css?family=Open+Sans:300');"))
  ),
  
  pageWithSidebar(
    headerPanel("US Average Household Income by Race and Year"),
    
    # Inputs: race, income_group, year
    sidebarPanel(
      # Race check box group
      checkboxGroupInput(
        inputId = "race",
        label   = h4("Race, Select 1 or More"),
        choices = list("White, NH", "White", "Black", "Hispanic", "Asian", "All Races"),
        selected= c("White, NH", "White", "Black", "Hispanic", "Asian", "All Races")),
      
      # Income group radio buttons
      radioButtons(
        inputId = "income_group",
        label   = h4("Income Group"),
        choices = list("Bottom 20% (1-20%)", "Second 20% (21-40%)", "Third 20% (41-60%)", "Fourth 20% (61-80%)", "Top 20% (81-100%)", "Top 5% (96-100%)", "Average")),
      
      # Year slider input
      sliderInput(
        inputId = "year",
        label   = h4("Year"),
        min     = 1972,
        max     = 2013,
        value   = 2010,
        sep		  = "",
        step    = 1)
    ),
    
    # The output goes in mainPanel(). Plot the bargraph based on the inputs.
    mainPanel(
      	plotOutput("plot"),
      	# Include sourcing information for the data 
      	HTML("<p><em>Data source: United States Census Bureau Mean Household Income Received by Each Fifth and Top 5 Percent, unadjusted for inflation</em>"),     
      	br(),      
      	em("*White, NH = White, Not Hispanic", style = "font-family: 'Open Sans'; font-weight: 300"),
      	br(),
      	em(a("Census Bureau Website", href="https://www.census.gov/hhes/www/income/data/historical/household/")))     
  ))
)
