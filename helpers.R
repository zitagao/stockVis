if (!exists(".inflation")) {
  .inflation <- getSymbols('CPIAUCNS', src = 'FRED', 
     auto.assign = FALSE)
}  

# adjusts yahoo finance data with the monthly consumer price index 
# values provided by the Federal Reserve of St. Louis
# historical prices are returned in present values 
adjust <- function(data) {

      latestcpi <- last(.inflation)[[1]]
      inf.latest <- time(last(.inflation))
      months <- split(data)               
      
      adjust_month <- function(month) {               
        date <- substr(min(time(month[1]), inf.latest), 1, 7)
        coredata(month) * latestcpi / .inflation[date][[1]]
      }
      
      adjs <- lapply(months, adjust_month)
      adj <- do.call("rbind", adjs)
      axts <- xts(adj, order.by = time(data))
      axts[ , 5] <- Vo(data)
      axts
}

# T indicator function ####
# The general idea of the variable T is to signal k-days period that 
# have several days with average daily prices clearly above the 
# target variation
###################################################
### Defining the Prediction Tasks
###################################################

avgPrice <- function(p) apply(HLC(p),1,mean)

T.ind <- function(quotes,dailyAveragePrice,tgt.margin=0.025,n.days=10) {
    v <- dailyAveragePrice
    if(is.null(v)) v <- apply(HLC(quotes),1,mean)
    
    r <- matrix(NA,ncol=n.days,nrow=NROW(quotes))
    for(x in 1:n.days) r[,x] <- Next(Delt(Cl(quotes),v,k=x),x)
    
    x <- apply(r,1,function(x) sum(x[x > tgt.margin | x < -tgt.margin]))
    if (is.xts(quotes)) xts(x,time(quotes)) else x
}

