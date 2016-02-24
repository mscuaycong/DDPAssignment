library(shiny)
library(ggplot2)
library(reshape2)


shinyServer(function(input, output) {
     
     # Reactive expression to generate the requested distribution.
     # This is called whenever the inputs change. The output
     # functions defined below then all use the value computed from
     # this expression.
     
   data <- reactive({
          
          # input$file1 will be NULL initially. After the user selects
          # and uploads a file, it will be a data frame with 'name',
          # 'size', 'type', and 'datapath' columns. The 'datapath'
          # column will contain the local filenames where the data can
          # be found.
          
          inFile <- input$file1
          
          if (is.null(inFile)) {
               
               month<-c("jan","feb","mar","apr","may","jun","jul","aug","sep",
                        "oct","nov","dec")
               year1<-seq(10,by=10,length=12)
               year2<-year1*1.2
               
               MyData<-data.frame(month,year1,year2)
               
              #return(NULL)
               
          }  else
               
          MyData<-read.csv(inFile$datapath, header=input$header, sep=input$sep, 
                           quote=input$quote, nrows=13)
          
     })  
   
   output$contents <- renderTable({
           data() 
      
  })
  
  # Generate a plot of the data. Use the data from the file input selected by user 
  # in the reactive statement.
  
  output$plot <- renderPlot({

       MyData<-data()
       MyData$month <- factor(MyData$month, levels = MyData$month[order(row(MyData)[,1])])
       
       #Transform data to Long Format
       MDlong <-melt(MyData, id.vars = "month",
                     variable.name = "year") 
       
       #Plot 2 separate lines based on year              
       g<- ggplot(MDlong, aes(x = month,y=value, group=year, shape=year, color=year)) + 
            geom_line() +
            geom_point() +
            ylab(label="Value") + 
            xlab("Month")
       
       g
       
  
  })
  
  #Plot Bar Graph
  output$plotbar <- renderPlot({
     
       MyData<-data()
       MyData$month <- factor(MyData$month, levels = MyData$month[order(row(MyData)[,1])])
       
       #Transform data to Long Format
       MDlong <-melt(MyData, id.vars = "month",
                     variable.name = "year") 
       #Plot bars per month based on year
       g<- ggplot(MDlong, aes(x = month,y=value, group=year, fill=year)) + 
            geom_bar(stat="identity", position=position_dodge()) +
            ylab(label="Value") + 
            xlab("Month")
       g
       
       
  })
  
  # Generate an HTML table view ofthe data file that is created
  # by calculating change in periods - e.g., MTD or YTD based on the 
  # Month selected by the user and the data in the data file.
  
  output$table <- renderTable({ 
       x<-input$mth #this is the mmonth selected by the user
       
       y<-switch(x,"jan"=1,"feb"=2,"mar"=3, "apr"=4,"may"=5,"jun"=6,
                 "jul"=7,"aug"=8,"sep"=9,"oct"=10,"nov"=11,"dec"=12)  
       
       MyData<-data()
       MDmonth<-MyData[1:y,]
       
       ytd1<-colSums(MDmonth[2])# year1 col
       ytd2<-colSums(MDmonth[3])# year2 col
       ytdchg <-round((ytd2/ytd1)-1,4)
       mtdchg <-round((MDmonth[y,3]/MDmonth[y,2])-1,4)
       m2mchg <- if(y>1) round((MDmonth[y,3]/MDmonth[y-1,3])-1,4) else
            round((MDmonth[y,3]/MDmonth[12,2]) - 1,4)
       
       
       disp <- c(x,MDmonth[y,2],MDmonth[y,3],mtdchg*100)
       disp <- rbind(disp,c("YTD",ytd1,ytd2,ytdchg*100))
       disp<-as.data.frame(disp)
       rownames(disp)<-NULL
       colnames(disp)<-c("Period","Year1","Year2","%Chg-YoY")
       disp
  })
  
  # Generate a summary of the data
   output$summary <- renderPrint({
       summary(data())
  })
})
