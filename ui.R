library(shiny)

# Define UI for file upload and user selection of summary month.
shinyUI(fluidPage(
    
  # Application title
  titlePanel("Plot and Summarize 2 Years of Monthly Data"),
  
  # The Sidebar panel has a control for selecting a csv file to upload.
  
    sidebarPanel(
         
         helpText("Select a file with 2 years of monthly data.  
                   You can load sample file provided or copy and edit with 
                   your own values.  See \"About\" tab for more information."),
         
         fileInput('file1', 'Choose CSV File',
                   accept=c('text/csv', 
                            'text/comma-separated-values,text/plain', 
                            '.csv')),
         tags$hr(),
         checkboxInput('header', 'Header', TRUE),
         radioButtons('sep', 'Separator',
                      c(Comma=',',
                        Semicolon=';',
                        Tab='\t'),
                      ','),
         radioButtons('quote', 'Quote',
                      c(None='',
                        'Double Quote'='"',
                        'Single Quote'="'"),
                      '"')
         
         
    ),
    
    # On the main Pane, show tabs where each tab
    # displays - the data table, the line plot, bar plot and a summary
    # of periods, values and change in values for the same period. Year 1 relative to Year2
  
    mainPanel(
         selectInput("mth", 
                     label = "Choose a month to summarize.",
                     choices = list("jan", "feb", "mar", "apr", "may", "jun",
                                    "jul", "aug","sep","oct","nov","dec"),
                     selected = "dec"),
      tabsetPanel(type = "tabs",
        tabPanel("About",
                   h3("Instructions"),
                   p("Plot and summarize data from a file with 2 years of
                   monthly values.  You can load the sample file provided and, edit with 
                   your own values."),
                   p("The sample file is MyData.csv"),
                   br(),
                   p("File is CSV and should have 3 columns, header for each column, col 1 (month)
                      has the month,  col 2 (year1) has year 1 values and col 3 (year2) has 
                      year 3 values."),
                   p("After you load the file, select a month to summarize.
                      The summary will be month to date for each year and year to month
                      selected.  Then the table will show the change from year 1 to year 2
                     given the same month and year 1 to year 2 for the beginning of the year
                     to the month selected."),
                   div("If no file is selected, the default data table is loaded.
                        You can review the ", style = "color:blue"), 
                   em("Data Table"),
                   div("tab to see what the data should look like.",
                         style = "color:blue")
                   
                   ),         
        tabPanel("Data Table", tableOutput("contents")),         
        tabPanel("Plot-Line", plotOutput("plot")), 
        tabPanel("Plot-Bar", plotOutput("plotbar")),
        tabPanel("Summary", tableOutput("table")) 
        
      )
    )
  )
)
