library(shiny); library(data.table);  
library(caret); library(klaR); library(MASS)
library(xgboost); library(gbm); library(survival)
library(splines); library(parallel); library(plyr)

# loading the models
Extreme_gb <- xgb.load("Extreme_gb")
load("nb.RData")
load("gbm_ada.RData")
Extreme_xgb <- xgb.load("Extreme_xgb")

predict_xgb <- function(Extreme_gb, input_data){
    inputd<- xgb.DMatrix(data = as.matrix(input_data))
    xgb_prediction_prob<-predict(Extreme_gb,inputd)
    return(xgb_prediction_prob)
}


shinyServer(function(input, output) {
  
  # Reactive expression to predict the mpg. This is 
  # called upon change of input parameters
  output$ada_pred <- renderText({ 
    input$actionButton
    isolate({
      # These features are needed to make a prediction.
        #"age"                "Late30_59"          "Credit_lines"      
        # "Late90"             "Real_estate_loans"  "Late60_89" "Dependents"        
        #"Log_line_usage"     "Log_debt_ratio"     "Log_monthly_income"
        
      input_data = data.table(age=input$age,
                              Late30_59=input$Late30_59,
                              Credit_lines=input$Credit_lines,
                              Late90= input$Late90,
                              Real_estate_loans= input$loans,
                              Late60_89=input$Late60_89,
                              Dependents= input$Dependents,
                              Log_line_usage= log(input$Line_usage+1e-8),
                              Log_debt_ratio= log(input$Debt_ratio+1e-8),
                              Log_monthly_income= log(input$Monthly_income+1e-8))

      ada_pred_l <- predict.train(gbm_ada,newdata= input_data, type='prob')$Risky
      if (ada_pred_l>0.5){ color<- "red"}else{color<- 'green'}
      ada_str <- sprintf("Risk probability is %5.3f", ada_pred_l)
      ada_pred <- HTML(paste0("<font color=",color,">",ada_str,"</font>"))

    })
  })
  output$xgb_pred <- renderText({ 
      input$actionButton
      isolate({
          
          input_data = data.table(age=input$age,
                                  Late30_59=input$Late30_59,
                                  Credit_lines=input$Credit_lines,
                                  Late90= input$Late90,
                                  Real_estate_loans= input$loans,
                                  Late60_89=input$Late60_89,
                                  Dependents= input$Dependents,
                                  Log_line_usage= log(input$Line_usage+1e-8),
                                  Log_debt_ratio= log(input$Debt_ratio+1e-8),
                                  Log_monthly_income= log(input$Monthly_income+1e-8))
          
          xgb_pred_1  <- predict_xgb(Extreme_gb,input_data)
          if (xgb_pred_1>0.5){ color<- "red"}else{color<- 'green'}
          xgb_str <- sprintf("Risk probability is %5.3f", xgb_pred_1)
          xgb_pred <- HTML(paste0("<font color=",color,">",xgb_str,"</font>"))
      })
  })
  
  output$nb_pred <- renderText({ 
      input$actionButton
      isolate({
          input_data = data.table(age=input$age,
                                  Late30_59=input$Late30_59,
                                  Credit_lines=input$Credit_lines,
                                  Late90= input$Late90,
                                  Real_estate_loans= input$loans,
                                  Late60_89=input$Late60_89,
                                  Dependents= input$Dependents,
                                  Log_line_usage= log(input$Line_usage+1e-8),
                                  Log_debt_ratio= log(input$Debt_ratio+1e-8),
                                  Log_monthly_income= log(input$Monthly_income+1e-8))
          nb_pred_1  <- predict.train(nb ,newdata= input_data, type='prob')$Risky
          if (nb_pred_1>0.5){ color<- "red"}else{color<- 'green'}
          nb_str <- sprintf("Risk probability is %5.3f", nb_pred_1)
          nb_pred <- HTML(paste0("<font color=",color,">",nb_str,"</font>"))
      })
  })
  
  output$ens_pred <- renderText({ 
      input$actionButton
      isolate({
          input_data = data.table(age=input$age,
                                  Late30_59=input$Late30_59,
                                  Credit_lines=input$Credit_lines,
                                  Late90= input$Late90,
                                  Real_estate_loans= input$loans,
                                  Late60_89=input$Late60_89,
                                  Dependents= input$Dependents,
                                  Log_line_usage= log(input$Line_usage+1e-8),
                                  Log_debt_ratio= log(input$Debt_ratio+1e-8),
                                  Log_monthly_income= log(input$Monthly_income+1e-8))
          xgb_pred_lc  <- predict_xgb(Extreme_gb,input_data)
          nb_pred_lc  <- predict.train(nb,newdata= input_data, type='prob')$Risky
          ada_prob_lc  <- predict.train(gbm_ada,newdata= input_data, type='prob')$Risky
          ens_df  <- data.frame(xgb= xgb_pred_lc, nb=nb_pred_lc , ada=ada_prob_lc)
          ens_pred_1  <- predict_xgb(Extreme_xgb,ens_df)
          if (ens_pred_1>0.5){ color<- "red"}else{color<- 'green'}
          ens_str <- sprintf("Risk probability is %5.3f", ens_pred_1)
          ens_pred <- HTML(paste0("<font size=5px, color=",color,">",ens_str,"</font>"))
      })
  })

})