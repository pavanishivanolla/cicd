
# 1. Check the required package
if (!requireNamespace("rpart", quietly = TRUE)) {
  stop("The rpart package is missing.")
}

# 2. Load the built-in dataset
data(iris)

# 3. Split the data into training and testing sets
set.seed(123)

train_ids <- sample(
  seq_len(nrow(iris)),
  size = floor(0.8 * nrow(iris))
)

train_data <- iris[train_ids, ]
test_data <- iris[-train_ids, ]

# 4. Train a decision tree model
model <- rpart::rpart(
  Species ~ .,
  data = train_data,
  method = "class"
)

# 5. Predict flower species
predictions <- predict(
  model,
  newdata = test_data,
  type = "class"
)

# 6. Calculate accuracy
accuracy <- mean(predictions == test_data$Species)

cat("Model accuracy:", round(accuracy * 100, 2), "%\n")

# 7. Validate model quality
if (!is.finite(accuracy) || accuracy < 0.70) {
  stop("Pipeline failed: accuracy is below 70%.")
}

# 8. Save the model
dir.create("artifacts", showWarnings = FALSE)

saveRDS(
  list(model = model, accuracy = accuracy),
  "artifacts/iris_model.rds"
)

cat("SUCCESS: Model passed validation.\n")
