library(shiny)

# Define UI for Predicting MPG of a car based on displacement, number of cylinders, transmission type, and weight of the vehicle.
shinyUI(fluidPage(theme = "cosmos.css",

    fluidRow(
        column(12, align="center",
               h2("Loan Default Prediction", style="font-size: 50px") 
        )  
    ),
    HTML('<hr style="color: blue;">'),

  sidebarPanel(
    h4("Applicant Data"),
    helpText("Please enter the following information."),
    numericInput("age","Age of the applicant (years)",value=35,min=18,max=100,step=1),
    numericInput("Dependents","Number of dependents",value=0,min=0,max=20,step=1),
    numericInput("Monthly_income","Montly income ($)",value=0,min=0,max=200000,step=1),
    numericInput("Line_usage","Revolving utilization of unsecured lines (%)",value=0,min=0,max=100000,step=0.01),
    numericInput("Debt_ratio","Total monthly debt payement over income (%)",value=0,min=0,max=100000,step=0.01),
    numericInput("Credit_lines","Number of open credit lines and loans",value=0,min=0,max=100000,step=1),
    numericInput("loans","Number of real estate loans or lines",value=0,min=0,max=50,step=1),
    numericInput("Late30_59","Number of times 30-59 days past due",value=0,min=0,max=100,step=1),
    numericInput("Late60_89","Number of times 60-89 days past due",value=0,min=0,max=100,step=1),
    numericInput("Late90","Number of times 90 days past due",value=0,min=0,max=100,step=1),
    actionButton("actionButton","Predict",align = "center")
  ),
  
  # Show a tabset that includes mpg prediction, plot, summary, and table view of mtcars dataset
  mainPanel(
      fluidRow(column(12, offset = 0, align="center",
                      h4("Model predictions", style="font-size: 35px") 
                      )
      ),
      fluidRow(column(12, offset = 0, align="left",
                      h4("All four models make risk probability predictions based on the input data. The probablity values ranege from 0 (safe) to 1 (very risky). Traditionaly, probabilities less than 0.5 (green) are assigned to the safe class and more than that (red) ro risky class.", style="font-size: 20px") 
      )
      ),
      fluidRow(
      column(12,offset = 0,align="center",
             h4("Ensemble Model ", style="font-size: 30px") 
             
      )
  ),
  fluidRow(
      column(12,offset = 0,align="center",
             htmlOutput("ens_pred")
             
      )
  ),
  br(),
  fluidRow(
      
      column(4,offset = 0,align="center",
             h4("XGB", style="font-size: 25px")
      ),
      column(4,offset = 0,align="center",
             h4("Naive Bayes", style="font-size: 25px")
      ),
      column(4,offset = 0,align="center",
             h4("gbm", style="font-size: 25px")
      )
  ),
  fluidRow(
      
      column(4,offset = 0,align="center",
             htmlOutput("xgb_pred") 
      ),
      column(4,offset = 0,align="center",
             htmlOutput("nb_pred")    
      ),
      column(4,offset = 0,align="center",
             htmlOutput("ada_pred")     
      )
  ),
  HTML('<hr style="color: blue;">'),
  fluidRow(column(12, offset = 0, align="left",
                  h4("Description:", style="font-size: 25px") 
  )
  ),
  fluidRow(column(12,offset = 0,align="left",
                  h4("Banks play a crucial role in market economies. They decide who can get finance and on what terms and can make or break investment decisions. For markets and society to function, individuals and companies need access to credit.", style="font-size: 20px"),
                  h4("Credit scoring algorithms, which make a guess at the probability of default, are the method banks use to determine whether or not a loan should be granted. Here I try to improve on the state of the art in credit scoring, by predicting the probability that somebody will experience financial distress in the next two years. ", style="font-size: 20px")
    )
  ),
  HTML('<hr style="color: blue;">'),
  fluidRow(column(12,offset = 0,align="left",
                  h4("Ensembel Model:", style="font-size: 25px"),
                  h4("Ensemble modeling is the process of running two or more related but different analytical models and then synthesizing the results into a single score or spread in order to improve the accuracy of predictive analytics and data mining applications. Here, I ensembled the following algorithms.", style="font-size: 20px"),
                  h4("XGB:", style="font-size: 25px"),
                  h4("The underlying algorithm of XGBoost is similar, specifically it is an extension of the classic gbm algorithm. By employing multi-threads and imposing regularization, XGBoost is able to utilize more computational power and get more accurate prediction.", style="font-size: 20px"),
                  h4("Naive Bayes:", style="font-size: 25px"),
                  h4("This algorithms is a simple yet powerful probabilistic classifier based on applying Bayes' theorem with strong (naive) independence assumptions between the features.", style="font-size: 20px"),
                  h4("gbm:", style="font-size: 25px"),
                  h4("A classification algorithm, which produces a prediction model in the form of an ensemble of weak prediction models, typically decision trees.", style="font-size: 20px")
  )
  )
  
  )
)
)

