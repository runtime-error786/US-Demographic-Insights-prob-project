
install.packages("corrgram")

library(shiny)
library(psych)
library(corrgram)
#data(iris)
us_data <- read.csv("acs2015_census_tract_data.csv")

#Creating 2 subsets of the US data, which have different no.of rows but data from 2 states only
US_data1<-us_data[c(1:50,1182:1231),]
US_data2<-us_data[(us_data$State=="Alabama") | (us_data$State=="Alaska"),]
               
                              
shinyServer(
  
  function(input, output) {
    
    output$data <- renderTable({
      colm <- as.numeric(input$var)
      us_data[colm]
      head(us_data)
      
      #title(main = "Ist few obs of dataset")
      
    })
    
    output$myhist <- renderPlot({
      colm <- as.numeric(input$var)
      hist(us_data[,colm], breaks=seq(0, max(us_data[,colm]), l=input$bins+1), col=input$color, main="Histogram of US Dataset", xlab=names(us_data[colm]), xlim=c(0,max(us_data[,colm])))
      
    })
    
    output$myhist2 <- renderPlot({
     colm <- as.numeric(input$var2)
    hist(us_data[,colm], breaks=seq(0, max(us_data[,colm]), l=input$bins+1), col=input$color, main="Histogram of US Dataset", xlab=names(us_data[colm]), xlim=c(0,max(us_data[,colm])))
      
   })
    
    output$myhist3 <- renderPlot({
      colm <- as.numeric(input$var3)
      hist(us_data[,colm], breaks=seq(0, max(us_data[,colm]), l=input$bins+1), col=input$color, main="Histogram of US Dataset", xlab=names(us_data[colm]), xlim=c(0,max(us_data[,colm])))
      
    })
    
    output$myscatter <- renderPlot({
      colm1 <- as.numeric(input$var6)
      colm2 <- as.numeric(input$var7)
      if(colm1==8 && colm2==20){
        plot(Professional~White,data = US_data2,spread=FALSE,
             smoother.args=list(lty=2),pch=1,
             main="Plot between percent of White people and percent employed in Management,Business,Science and Arts")
      }
      
      if(colm1==5 && colm2==23)
      {
        plot(Construction~Men,data = US_data2,spread=FALSE,
             smoother.args=list(lty=2),pch=1,
             main="Plot between no.of men and percent employed in Construction sector")
      }
     
    })
    
    output$mycorgram <- renderPlot({
      corrgram(US_data2[,4:20],order = TRUE,lower.panel = panel.shade,
               upper.panel = panel.pie,text.panel = panel.txt,
               main="Corrgram of numeric variables in the US Demographic Dataset")
    })
    
    output$t_test <-renderPrint({
     if(input$var9 == 1)
     {
       tags$b("p-value suggests that there isn’t any significant difference between the percent of native and asian people")
       t.test(US_data2$Native,US_data2$Asian)  
     }
      else if (input$var9 == 2)
      {
        tags$b("p-value suggests that there is a significant difference between the no.of men and women")
        t.test(US_data2$Men,US_data2$Women)
        
      }
    })
   
    output$regression <- renderPrint({
      fit1<-lm(Income~Men+Women+Hispanic+White+Black+Native+Asian+Pacific+Poverty+ChildPoverty
               +Professional+Service+Office+Construction+Production+WorkAtHome+Employed
               +PrivateWork
               +PublicWork+SelfEmployed+Unemployment,data = us_data)
      summary(fit1)
    })
    
    output$b_boxplot<- renderPlot({
      if(input$var11 == 2)
      {
        boxplot(TotalPop~County,data = US_data1,
                main="Boxplot of Population in 6 counties",
                xlab="Counties",ylab="Population")
        axis(side=1,at=2,labels = "Aleutians West")
      }
      else if (input$var11 == 1)
      {
        boxplot(Income~State,data = US_data2,
                main="Boxplot of Income in 2 specific states in US",
                xlab="States",ylab="Income")
      }
      
    })
    
    
    output$d_dnorm <- renderPlot({
     colm <- as.numeric(input$var12)
      t_min <- min(us_data[,colm])
      t_max <- max(us_data[,colm])
      m <- mean(us_data[,colm])
      std_dev <- sd(us_data[,colm])
       x <- seq(t_min, t_max, by = .1)
       y <- dnorm(x, mean = m, sd = std_dev)
       plot(x,y, main = "dnorm()", col = "blue")
      
    })
    
    output$mean_t <-renderPrint({
      colm <- as.numeric(input$var)
      mean(us_data[,colm])
    }
    )
    
  }
)
