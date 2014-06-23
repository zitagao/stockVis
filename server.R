# server.R

library(quantmod)
library(ggplot2)
library(gridExtra)
source("helpers.R")


shinyServer(function(input, output) {

  dataInput <- reactive({
      data=getSymbols(input$symb, src = "yahoo", 
                 from = input$dates[1],
                 to = input$dates[2],
                 auto.assign = FALSE)
      colnames(data) <- c("Open","High","Low","Close","Volume","Adjusted")
      return(data)
  })
  
  finalInput <- reactive({
      if(!input$adjust) return(dataInput())
      adjust(dataInput())
  })

 
 
  output$stockImage <- renderPlot({
      data = finalInput()
      dailyAvgPrice = avgPrice(data)
      T.ind = T.ind(data,dailyAvgPrice)
      Indexs = data.frame(date=as.Date(names(dailyAvgPrice)),dailyAvgPrice,T.ind)
      
      dailyAvgPricePlot <- ggplot(Indexs,aes(date,dailyAvgPrice))+ geom_line() +
          labs(title=paste(input$symb,"Stock Visulization"),y="Daily Average Price")+
          theme(
              axis.text.x  = element_blank(),
              axis.title.x = element_blank(),
              axis.ticks.x = element_blank(),
              plot.title = element_text(size = rel(2))
          )
      T.indPlot <- ggplot(Indexs,aes(date,T.ind))+geom_line(col="green")+
          labs(y=paste(input$nDays,"days period profit Index"))+
          theme(plot.title = element_blank(),
                axis.title.x = element_blank()
          )
    
      grid.arrange(dailyAvgPricePlot,T.indPlot,heights=c(0.6,0.4),ncol=1, nrow=2)        
    })

})


