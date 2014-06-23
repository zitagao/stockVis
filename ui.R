library(shiny)

shinyUI(fluidPage(
  titlePanel("stockVis"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Select a stock to examine."),
 
      textInput("symb", "Symbol:", "FB"),
    
      dateRangeInput("dates", 
        "Date range:",
        start = "2014-03-01", 
        end = as.character(Sys.Date())),
      h4("What is your target margin in n days?"),
      p("Tip:Target margin is the price variation of today's close to trading price.
        If the price vary more than target margin, you consider this worthwhile in 
        terms of trading.(e.g.,covering transaction costs)"),
      textInput("tgtMargin","Target Margin",0.05),
      textInput("nDays","n days",30),
      actionButton("get", "Get Stock"),
      
      p("The daily average price plot on the top will let you know how the stock
               price changes with the time."), 
      p("The profix index at the botton shows the profitablity in n days."),
      
      br(),
      
      checkboxInput("log", "Plot y axis on log scale", 
        value = FALSE),
      
      checkboxInput("adjust", 
        "Adjust prices for inflation", value = FALSE)
    ),
    
    mainPanel(plotOutput("stockImage"),
            h4("Technical Explaination:"),
              p("The daily average price is approximated by the average of close, high, and low quotes respectively."),
              p("The n days profit index is the average of the percentage returns of today's 
                close to the following n days whose absolute value is above our target margin.")
        )
)
)
)