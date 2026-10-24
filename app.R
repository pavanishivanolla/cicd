```r
# app.R
# CI/CD Pipeline Optimization - Iris Species Prediction

library(shiny)

# Load the trained model
model_path <- "artifacts/iris_model.rds"

if (!file.exists(model_path)) {
  stop("Model file not found. Please run train.R first.")
}

saved <- readRDS(model_path)
model <- saved$model
model_accuracy <- saved$accuracy

# User interface
ui <- fluidPage(
  titlePanel("Iris Species Prediction"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Enter Flower Measurements"),
      
      numericInput(
        "sepal_length",
        "Sepal Length (cm)",
        value = 5.1,
        min = 0.1,
        max = 10,
        step = 0.1
      ),
      
      numericInput(
        "sepal_width",
        "Sepal Width (cm)",
        value = 3.5,
        min = 0.1,
        max = 10,
        step = 0.1
      ),
      
      numericInput(
        "petal_length",
        "Petal Length (cm)",
        value = 1.4,
        min = 0.1,
        max = 10,
        step = 0.1
      ),
      
      numericInput(
        "petal_width",
        "Petal Width (cm)",
        value = 0.2,
        min = 0.1,
        max = 10,
        step = 0.1
      ),
      
      actionButton(
        "predict",
        "Predict Species",
        class = "btn-primary"
      )
    ),
    
    mainPanel(
      h3("Prediction Result"),
      verbatimTextOutput("prediction"),
      
      hr(),
      
      h4("Model Information"),
      textOutput("accuracy"),
      
      p("Model: Decision Tree (rpart)"),
      p("Dataset: Iris")
    )
  )
)

# Server logic
server <- function(input, output, session) {
  
  prediction_result <- eventReactive(input$predict, {
    
    flower <- data.frame(
      Sepal.Length = input$sepal_length,
      Sepal.Width = input$sepal_width,
      Petal.Length = input$petal_length,
      Petal.Width = input$petal_width
    )
    
    prediction <- predict(
      model,
      newdata = flower,
      type = "class"
    )
    
    as.character(prediction)
  })
  
  output$prediction <- renderText({
    req(input$predict > 0)
    
    paste(
      "Predicted Iris Species:",
      prediction_result()
    )
  })
  
  output$accuracy <- renderText({
    paste0(
      "Test accuracy: ",
      round(model_accuracy * 100, 2),
      "%"
    )
  })
}

# Launch application
shinyApp(ui = ui, server = server)
```
